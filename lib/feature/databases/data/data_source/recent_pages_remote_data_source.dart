import 'package:dio/dio.dart';
import 'package:pagebridge/core/constants/constants.dart';
import 'package:pagebridge/core/database/api/dio_consumer.dart';
import 'package:pagebridge/core/database/api/end_ponits.dart';
import 'package:pagebridge/core/database/cache/secure_storage.dart';
import 'package:pagebridge/feature/databases/data/model/page_model.dart';
import 'package:pagebridge/feature/databases/domain/entities/page_entity.dart';

abstract class RecentPagesRemoteDataSource {
  Future<Map<String, dynamic>> getRecentPages({
    String? startCursor,
    CancelToken? cancelToken,
  });
}

class RecentPagesRemoteDataSourceImpl implements RecentPagesRemoteDataSource {
  final DioConsumer dioConsumer;
  RecentPagesRemoteDataSourceImpl(this.dioConsumer);

  @override
  Future<Map<String, dynamic>> getRecentPages({
    String? startCursor,
    CancelToken? cancelToken,
  }) async {
    final token = await SecureStorage.readData(key: tokenKey);

    var data = await dioConsumer.post(
      EndPoint.search,
      options: headers(token: token ?? "", notionVersion: "2022-06-28"),
      cancelToken: cancelToken,
      data: {
        'page_size': pageSizeOfTheAPI,
        "filter": {
          "value": "page",
          "property": "object"
        },
        "sort": {
          "direction": "descending",
          "timestamp": "last_edited_time"
        },
        if (startCursor != null) 'start_cursor': startCursor,
      },
    );

    List<PageEntity> pages = [];
    if (data.data != null && data.data['results'] != null) {
      for (var page in data.data["results"]) {
        pages.add(PageModel.fromJson(page));
      }
    }
    return {
      'pages': pages,
      'has_more': data.data["has_more"],
      'next_cursor': data.data["next_cursor"],
    };
  }
}
