import 'package:quicknotion/core/constants/constants.dart';
import 'package:quicknotion/core/database/api/dio_consumer.dart';
import 'package:quicknotion/core/database/api/end_ponits.dart';
import 'package:quicknotion/core/database/cache/secure_storage.dart';
import 'package:quicknotion/feature/databases/data/model/property_model.dart';

abstract class CreateNewPageDataSource {
  Future<void> createNewPage({required List<PropertyModel> properties});
}

class CreateNewPageDataSourceImpl implements CreateNewPageDataSource {
  DioConsumer dioConsumer;
  CreateNewPageDataSourceImpl(this.dioConsumer);
  @override
  Future<void> createNewPage({required List<PropertyModel> properties}) async {
    final token = await SecureStorage.readData(key: tokenKey);
    await dioConsumer.post(
      EndPoint.addNewPage,
      data: properties,
      options: headers(token!),
    );
  }
}
