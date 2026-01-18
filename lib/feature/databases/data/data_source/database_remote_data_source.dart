import 'package:quicknotion/core/constants/constants.dart';
import 'package:quicknotion/core/database/api/dio_consumer.dart';
import 'package:quicknotion/core/database/api/end_ponits.dart';
import 'package:quicknotion/core/database/cache/secure_storage.dart';
import 'package:quicknotion/feature/databases/data/model/database_model.dart';
import 'package:quicknotion/feature/databases/domain/entities/database_entity.dart';

abstract class DatabaseRemoteDataSource {
  Future<Map<String, dynamic>> returnTheDatabases(
    String token,
    String? query,
    String? startCursor,
  );
}

class DatabaseRemoteDataSourceImpl implements DatabaseRemoteDataSource {
  DioConsumer dioConsumer;
  DatabaseRemoteDataSourceImpl(this.dioConsumer);
  @override
  Future<Map<String, dynamic>> returnTheDatabases(
    String token,
    String? query,
    String? startCursor,
  ) async {
    var data = await dioConsumer.post(
      EndPoint.search,
      options: headers(token),
      data: {
        if (query != null && query.isNotEmpty) "query": query,
        "filter": {"value": "database", "property": "object"},
        'page_size': pageSizeOfTheAPI,
        if (startCursor != null) 'start_cursor': startCursor,
      },
    );
    List<DatabaseEntity> databases = [];
    if (data.data != null && data.data['results'] != null) {
      databases = await getDatabaseList(data);
      SecureStorage.writeData(key: tokenKey, value: token);
    }
    return {
      'databases': databases,
      'has_more': data.data["has_more"],
      'next_cursor': data.data["next_cursor"],
    };
  }

  Future<List<DatabaseEntity>> getDatabaseList(var data) async {
    List<DatabaseEntity> databases = [];
    for (var database in data.data["results"]) {
      databases.add(DatabaseModel.fromJson(database));
    }
    return databases;
  }
}
