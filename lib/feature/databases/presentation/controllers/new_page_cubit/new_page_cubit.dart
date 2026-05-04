import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:pagebridge/feature/databases/data/model/property_model.dart';

import 'package:pagebridge/feature/databases/domain/repo/create_new_page_repo.dart';

part 'new_page_state.dart';

class NewPageCubit extends Cubit<NewPageState> {
  NewPageCubit({required this.createNewPageRepo}) : super(NewPageInitial());
  final CreateNewPageRepo createNewPageRepo;

  List<PropertyModel> newPageProperties = [];
  String? pageContent;

  void setContent(String? content) {
    pageContent = content;
  }

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

  Future<String?> createNewPage({required String databaseId}) async {
    emit(NewPageLoading());
    final result = await createNewPageRepo.createNewPage(
      properties: newPageProperties,
      databaseId: databaseId,
      content: pageContent,
    );
    return result.fold(
      (failure) {
        emit(NewPageFailure(message: failure.message));
        return null;
      },
      (url) {
        emit(NewPageSuccess());
        return url;
      },
    );
  }
}
