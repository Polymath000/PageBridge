import 'package:quicknotion/core/constants/constants.dart';
import 'package:quicknotion/core/database/api/dio_consumer.dart';
import 'package:quicknotion/core/database/api/end_ponits.dart';
import 'package:quicknotion/core/database/cache/secure_storage.dart';
import 'package:quicknotion/feature/databases/data/model/database_model.dart';
import 'package:quicknotion/feature/databases/domain/entities/database_entity.dart';

String? startCursorFetchDatabases;
bool hasMoreFetchDatabases = false;

abstract class DatabaseRemoteDataSource {
  Future<List<DatabaseEntity>> returnTheDatabases(String token);
}

class DatabaseRemoteDataSourceImpl implements DatabaseRemoteDataSource {
  DioConsumer dioConsumer;
  DatabaseRemoteDataSourceImpl(this.dioConsumer);
  @override
  Future<List<DatabaseEntity>> returnTheDatabases(String token) async {
    int pageSize = 18;
    var data = await dioConsumer.post(
      EndPoint.search,
      options: headers(token),
      data: {
        "filter": {"value": "database", "property": "object"},
        'page_size': pageSize,
        if (startCursorFetchDatabases != null || hasMoreFetchDatabases)
          'start_cursor': startCursorFetchDatabases,
      },
    );
    List<DatabaseEntity> databases = [];
    if (data.data != null && data.data['results'] != null) {
      databases = await getDatabaseList(data);
      SecureStorage.writeData(key: tokenKey, value: token);
    }
    hasMoreFetchDatabases = data.data["has_more"];
    startCursorFetchDatabases = data.data["next_cursor"];
    return databases;
  }

  Future<List<DatabaseEntity>> getDatabaseList(var data) async {
    List<DatabaseEntity> databases = [];
    for (var database in data.data["results"]) {
      databases.add(DatabaseModel.fromJson(database));
    }
    return databases;
  }
}
