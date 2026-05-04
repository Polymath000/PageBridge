import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:pagebridge/feature/databases/domain/entities/database_entity.dart';
import 'package:pagebridge/feature/databases/domain/repo/database_repo.dart';

part 'return_databases_state.dart';

class DatabasesCubit extends Cubit<DatabasesState> {
  final DatabaseRepo databaseRepo;
  CancelToken? _cancelToken;

  DatabasesCubit({required this.databaseRepo}) : super(DatabasesInitial());

  Future<void> returnDatabases({String query = ""}) async {
    _cancelToken?.cancel("New search initiated");
    _cancelToken = CancelToken();

    emit(DatabasesLoading());

    final result = await databaseRepo.returnTheDatabases(
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

    if (currentState is! DatabasesSuccess ||
        !currentState.hasMore ||
        currentState.isPaginating) {
      return;
    }

    emit(currentState.copyWith(isPaginating: true));

    final result = await databaseRepo.returnTheDatabases(
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
