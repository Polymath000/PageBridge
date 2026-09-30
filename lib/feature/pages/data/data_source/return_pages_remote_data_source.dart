import 'package:dio/dio.dart';
import 'package:pagebridge/core/constants/constants.dart';
import 'package:pagebridge/core/database/api/dio_consumer.dart';
import 'package:pagebridge/core/database/api/end_ponits.dart';
import 'package:pagebridge/feature/pages/data/model/page_model.dart';
import 'package:pagebridge/feature/pages/domain/entities/page_entity.dart';

abstract class ReturnPagesRemoteDataSource {
  Future<Map<String, dynamic>> returnPages(
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
  Future<Map<String, dynamic>> returnPages(
    String query,
    String? startCursor,
    String databaseId, {
    CancelToken? cancelToken,
  }) async {
    EndPoint endPoint = EndPoint(dataSourceId: databaseId);

    var data = await dioConsumer.post(
      endPoint.returnPages,
      cancelToken: cancelToken,
      data: {
        'page_size': AppConstants.pageSizeOfTheAPI,
        if (query.trim().isNotEmpty)
          "filter": {
            "property": "Name", // This assumes the primary title property is always "Name"
            "title": {"contains": query.trim()},
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
      'has_more': data.data["has_more"] ?? false,
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
