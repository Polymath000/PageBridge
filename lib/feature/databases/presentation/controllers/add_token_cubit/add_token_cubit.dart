import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:quicknotion/feature/databases/data/repos/database_repo_impl.dart';
import 'package:quicknotion/feature/databases/domain/entities/database_entity.dart';

part 'add_token_state.dart';

class AddTokenCubit extends Cubit<AddTokenState> {
  AddTokenCubit({required this.databaseRepo}) : super(AddTokenInitial());
  final DatabaseRepoImpl databaseRepo;
  Future<void> addToken(
      {required String token, String query = "", String? startCursor}) async {
    emit(AddTokenLoading());
    final result =
        await databaseRepo.returnTheDatabases(token, query, startCursor);
    
    result.fold(
      (failure) async {
        emit(AddTokenFailure(message: failure.message));
      },
      (data) {
        final databases = data['databases'] as List<DatabaseEntity>;
        final hasMore = data['has_more'] as bool;
        final nextCursor = data['next_cursor'] as String?;
        if (query.isEmpty) {
          emit(AddTokenSuccess(
              databases: databases, hasMore: hasMore, nextCursor: nextCursor));
        } else {
          emit(AddTokenSearchSuccess(
              databases: databases, hasMore: hasMore, nextCursor: nextCursor));
        }
      },
    );
  }
}
