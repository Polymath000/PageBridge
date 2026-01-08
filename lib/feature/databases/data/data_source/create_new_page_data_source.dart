import 'package:quicknotion/core/constants/constants.dart';
import 'package:quicknotion/core/database/api/dio_consumer.dart';
import 'package:quicknotion/core/database/api/end_ponits.dart';
import 'package:quicknotion/core/database/cache/secure_storage.dart';
import 'package:quicknotion/feature/databases/data/model/property_model.dart';

abstract class CreateNewPageDataSource {
  Future<void> createNewPage({
    required String databaseId,
    required List<PropertyModel> properties,
  });
}

class CreateNewPageDataSourceImpl implements CreateNewPageDataSource {
  DioConsumer dioConsumer;
  CreateNewPageDataSourceImpl(this.dioConsumer);
  @override
  Future<void> createNewPage({
    required String databaseId,
    required List<PropertyModel> properties,
  }) async {
    final token = await SecureStorage.readData(key: tokenKey);
    final Map<String, dynamic> mappedProperties = {};
    for (var prop in properties) {
      final json = prop.toJson();
      if (json.isNotEmpty) {
        mappedProperties[prop.name] = json;
      }
    }

    await dioConsumer.post(
      EndPoint.addNewPage,
      data: {
        'parent': {'database_id': databaseId},
        'properties': mappedProperties,
      },
      options: headers(token!),
    );
  }
}
