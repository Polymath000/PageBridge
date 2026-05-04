import 'package:pagebridge/core/constants/constants.dart';
import 'package:pagebridge/core/database/api/dio_consumer.dart';
import 'package:pagebridge/core/database/api/end_ponits.dart';
import 'package:pagebridge/core/database/cache/secure_storage.dart';
import 'package:pagebridge/feature/databases/data/model/property_model.dart';

abstract class CreateNewPageDataSource {
  Future<String> createNewPage({
    required String databaseId,
    required List<PropertyModel> properties,
    String? content,
  });
}

class CreateNewPageDataSourceImpl implements CreateNewPageDataSource {
  DioConsumer dioConsumer;
  CreateNewPageDataSourceImpl(this.dioConsumer);
  @override
  Future<String> createNewPage({
    required String databaseId,
    required List<PropertyModel> properties,
    String? content,
  }) async {
    final token = await SecureStorage.readData(key: tokenKey);
    final Map<String, dynamic> mappedProperties = {};
    for (var prop in properties) {
      final json = prop.toJson();
      if (json.isNotEmpty) {
        mappedProperties[prop.name] = json;
      }
    }

    final Map<String, dynamic> requestData = {
      'parent': {'database_id': databaseId},
      'properties': mappedProperties,
    };

    if (content != null && content.trim().isNotEmpty) {
      requestData['children'] = [
        {
          "object": "block",
          "type": "paragraph",
          "paragraph": {
            "rich_text": [
              {
                "type": "text",
                "text": {"content": content.trim()}
              }
            ]
          }
        }
      ];
    }

    final response = await dioConsumer.post(
      EndPoint.addNewPage,
      data: requestData,
      options: headers(token: token!),
    );
    return response.data['url'] as String;
  }
}
