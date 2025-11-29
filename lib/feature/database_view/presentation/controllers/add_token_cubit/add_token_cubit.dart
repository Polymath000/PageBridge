import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:quicknotion/feature/database_view/data/repos/database_repo_impl.dart';
import 'package:quicknotion/feature/database_view/domain/entities/database_entity.dart';

part 'add_token_state.dart';

class AddTokenCubit extends Cubit<AddTokenState> {
  AddTokenCubit({required this.databaseRepo}) : super(AddTokenInitial());
  final DatabaseRepoImpl databaseRepo;
  Future<void> addToken(String token) async {
    emit(AddTokenLoading());
    final result = await databaseRepo.checkTokenAndReturnTheDatabases(token);
    result.fold(
      (failure) => emit(AddTokenFailure(message: failure.message)),
      (databases) => emit(AddTokenSuccess(databases: databases)),
    );
  }
}
