import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:quicknotion/feature/databases/data/model/property_model.dart';
import 'package:quicknotion/feature/databases/data/repos/create_new_page_repo_impl.dart';

part 'new_page_state.dart';

class NewPageCubit extends Cubit<NewPageState> {
  NewPageCubit({required this.createNewPageRepoImpl}) : super(NewPageInitial());
  CreateNewPageRepoImpl createNewPageRepoImpl;

  Future<void> createNewPage({required List<PropertyModel> properties}) async {
    emit(NewPageLoading());
    final result = await createNewPageRepoImpl.createNewPage(
      properties: properties,
    );
    result.fold(
      (failure) => emit(NewPageFailure(message: failure.message)),
      (r) => emit(NewPageSuccess()),
    );
  }
}
