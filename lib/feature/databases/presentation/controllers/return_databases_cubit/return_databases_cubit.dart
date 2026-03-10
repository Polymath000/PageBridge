import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:quicknotion/core/constants/constants.dart';
import 'package:quicknotion/core/database/cache/secure_storage.dart';
import 'package:quicknotion/feature/databases/data/repos/database_repo_impl.dart';
import 'package:quicknotion/feature/databases/domain/entities/database_entity.dart';

part 'return_databases_state.dart';

class DatabasesCubit extends Cubit<DatabasesState> {
  final DatabaseRepoImpl databaseRepo;
  CancelToken? _cancelToken;

  DatabasesCubit({required this.databaseRepo}) : super(DatabasesInitial());

  Future<void> returnDatabases({String? token, String query = ""}) async {
    // Cancel any ongoing request before starting a new one
    _cancelToken?.cancel("New search initiated");
    _cancelToken = CancelToken();

    emit(DatabasesLoading());

    final tokenfromDB = await SecureStorage.readData(key: tokenKey);

    final result = await databaseRepo.returnTheDatabases(
      token ?? tokenfromDB!,
      query,
      null,
      _cancelToken,
    );

    result.fold(
      (failure) {
        if (failure.message.toLowerCase().contains('cancel')) {
          return;
        }

        emit(DatabasesFailure(message: failure.message));
      },
      (data) => emit(
        DatabasesSuccess(
          databases: data['databases'],
          hasMore: data['has_more'],
          nextCursor: data['next_cursor'],
          query: query,
        ),
      ),
    );
  }

  Future<void> fetchMore() async {
    final currentState = state;

    // Guard against double fetching or fetching when there is no more data
    if (currentState is! DatabasesSuccess ||
        !currentState.hasMore ||
        currentState.isPaginating) {
      return;
    }

    emit(currentState.copyWith(isPaginating: true));

    final tokenfromDB = await SecureStorage.readData(key: tokenKey);
    final result = await databaseRepo.returnTheDatabases(
      tokenfromDB!,
      currentState.query,
      currentState.nextCursor,
      _cancelToken,
    );

    result.fold(
      (failure) {
        if (failure.message.toLowerCase().contains('cancel')) return;
        emit(DatabasesFailure(message: failure.message));
      },
      (data) {
        final List<DatabaseEntity> updatedList = List.from(
          currentState.databases,
        )..addAll(data['databases']);

        emit(
          currentState.copyWith(
            databases: updatedList,
            hasMore: data['has_more'],
            nextCursor: data['next_cursor'],
            isPaginating: false,
          ),
        );
      },
    );
  }
}
