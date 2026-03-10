import 'package:bloc/bloc.dart';
import 'package:quicknotion/core/constants/constants.dart';
import 'package:quicknotion/core/database/cache/secure_storage.dart';
import 'package:quicknotion/feature/databases/data/repos/database_repo_impl.dart';
import 'package:quicknotion/feature/databases/domain/entities/database_entity.dart';

part 'return_databases_state.dart';

class DatabasesCubit extends Cubit<DatabasesState> {
  DatabasesCubit({required this.databaseRepo}) : super(DatabasesInitial());
  final DatabaseRepoImpl databaseRepo;
  Future<void> returnDatabases({
    String? token,
    String query = "",
    String? startCursor,
  }) async {
    emit(DatabasesLoading(query: query));
    final tokenfromDB = await SecureStorage.readData(key: tokenKey);
    final result = await databaseRepo.returnTheDatabases(
      token ?? tokenfromDB!,
      query,
      startCursor,
    );

    result.fold(
      (failure) async {
        emit(DatabasesFailure(message: failure.message, query: query));
      },
      (data) {
        final databases = data['databases'] as List<DatabaseEntity>;
        final hasMore = data['has_more'] as bool;
        final nextCursor = data['next_cursor'] as String?;
        if (query.isEmpty) {
          emit(
            DatabasesSuccess(
              databases: databases,
              hasMore: hasMore,
              nextCursor: nextCursor,
              query: query,
            ),
          );
        } else {
          emit(
            DatabasesSearchSuccess(
              databases: databases,
              hasMore: hasMore,
              nextCursor: nextCursor,
              query: query,
            ),
          );
        }
      },
    );
  }
}
