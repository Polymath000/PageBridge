import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:quicknotion/feature/databases/data/model/property_model.dart';

import 'package:quicknotion/feature/databases/data/repos/create_new_page_repo_impl.dart';

part 'new_page_state.dart';

class NewPageCubit extends Cubit<NewPageState> {
  NewPageCubit({required this.createNewPageRepoImpl}) : super(NewPageInitial());
  CreateNewPageRepoImpl createNewPageRepoImpl;

  List<PropertyModel> newPageProperties = [];

  void addProperty({
    required String key,
    required dynamic value,
    required String type,
  }) {
    newPageProperties.add(
      PropertyModel(name: key, type: type, canEdit: true, value: value),
    );
  }

  Future<void> createNewPage({required String databaseId}) async {
    emit(NewPageLoading());
    final result = await createNewPageRepoImpl.createNewPage(
      properties: newPageProperties,
      databaseId: databaseId,
    );
    result.fold(
      (failure) => emit(NewPageFailure(message: failure.message)),
      (r) => emit(NewPageSuccess()),
    );
  }
}
