import 'package:dio/dio.dart';
import 'package:quicknotion/core/constants/constants.dart';
import 'package:quicknotion/core/database/api/dio_consumer.dart';
import 'package:quicknotion/core/database/api/end_ponits.dart';
import 'package:quicknotion/core/database/cache/secure_storage.dart';
import 'package:quicknotion/feature/databases/data/model/page_model.dart';
import 'package:quicknotion/feature/databases/domain/entities/page_entity.dart';

abstract class ReturnPagesRemoteDataSource {
  Future<Map<String, dynamic>> raturnPages(
    String query,
    String? startCursor,
    String databaseId, {
    CancelToken? cancelToken,
  });
}

class ReturnPagesRemoteDataSourceImpl implements ReturnPagesRemoteDataSource {
  DioConsumer dioConsumer;
  ReturnPagesRemoteDataSourceImpl(this.dioConsumer);

  @override
  Future<Map<String, dynamic>> raturnPages(
    String query,
    String? startCursor,
    String databaseId, {
    CancelToken? cancelToken,
  }) async {
    EndPoint endPoint = EndPoint(dataSourceId: databaseId);
    final token = await SecureStorage.readData(key: tokenKey);

    var data = await dioConsumer.post(
      endPoint.returnPages,
      options: headers(token: token ?? "", notionVersion: "2025-09-03"),
      cancelToken: cancelToken,
      data: {
        'page_size': pageSizeOfTheAPI,
        "filter": {
          "property": "Name",
          "title": {"contains": query},
        },
        "sorts": [
          {"timestamp": "last_edited_time", "direction": "ascending"},
        ],
        if (startCursor != null) 'start_cursor': startCursor,
      },
    );
    List<PageEntity> pages = [];
    if (data.data != null && data.data['results'] != null) {
      pages = await getPagesList(data);
    }
    return {
      'pages': pages,
      'has_more': data.data["has_more"],
      'next_cursor': data.data["next_cursor"],
    };
  }

  Future<List<PageEntity>> getPagesList(var data) async {
    List<PageEntity> pages = [];
    for (var page in data.data["results"]) {
      pages.add(PageModel.fromJson(page));
    }
    return pages;
  }
}
