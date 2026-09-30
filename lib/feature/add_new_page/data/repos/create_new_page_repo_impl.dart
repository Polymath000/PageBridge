import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:pagebridge/core/errors/failure.dart';
import 'package:pagebridge/core/network/network_info.dart';
import 'package:pagebridge/feature/add_new_page/data/data_source/create_new_page_data_source.dart';
import 'package:pagebridge/feature/databases/data/model/property_model.dart';
import 'package:pagebridge/feature/databases/domain/entities/property_entity.dart';
import 'package:pagebridge/feature/add_new_page/domain/repo/create_new_page_repo.dart';

class CreateNewPageRepoImpl extends CreateNewPageRepo {
  final CreateNewPageDataSource createNewPageDataSource;
  final NetworkInfo networkInfo;

  CreateNewPageRepoImpl({
    required this.createNewPageDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, String>> createNewPage({
    required String databaseId,
    required List<PropertyEntity> properties,
    String? content,
  }) async {
    try {
      if (await networkInfo.isConnected) {
        // Map domain entities back into data models for the data source
        final mappedProperties = properties.map((e) {
          List<SelectOptionModel>? options;
          if (e.selectOptions != null) {
            options = e.selectOptions!
                .map((o) => SelectOptionModel(name: o.name, color: o.color))
                .toList();
          }

          return PropertyModel(
            name: e.name,
            type: e.type,
            canEdit: e.canEdit,
            selectOptions: options,
            formulaExpression: e.formulaExpression,
            relationDatabaseId: e.relationDatabaseId,
            icon: e.icon,
            value: e.value,
          );
        }).toList();

        final url = await createNewPageDataSource.createNewPage(
          databaseId: databaseId,
          properties: mappedProperties,
          content: content,
        );
        return right(url);
      } else {
        return left(NetworkFailure.error());
      }
    } on Exception catch (e) {
      if (e is DioException) {
        return left(ServerFailure.fromDioError(e));
      } else {
        return left(ServerFailure(message: e.toString()));
      }
    }
  }
}
