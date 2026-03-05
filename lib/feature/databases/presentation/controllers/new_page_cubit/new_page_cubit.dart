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
    final index = newPageProperties.indexWhere(
      (element) => element.name == key,
    );
    if (index != -1) {
      newPageProperties[index] = PropertyModel(
        name: key,
        type: type,
        canEdit: true,
        value: value,
      );
    } else {
      newPageProperties.add(
        PropertyModel(name: key, type: type, canEdit: true, value: value),
      );
    }
  }

  Future<bool> createNewPage({required String databaseId}) async {
    emit(NewPageLoading());
    final result = await createNewPageRepoImpl.createNewPage(
      properties: newPageProperties,
      databaseId: databaseId,
    );
    return result.fold(
      (failure) {
        emit(NewPageFailure(message: failure.message));
        return false;
      },
      (r) {
        emit(NewPageSuccess());
        return true;
      },
    );
  }
}
