import 'package:dio/dio.dart';

class EndPoint {
  EndPoint({required this.dataSourceId});
  static const String baseUrl = 'https://api.notion.com/v1';
  static const String search = '/search';
  static const String addNewPage = '/pages/';
  final String dataSourceId;
  late String returnPages = "/data_sources/$dataSourceId/query";
}

Options headers({required String token, String notionVersion = "2022-06-28"}) => Options(
  headers: {
    "Authorization": "Bearer $token",
    "Notion-Version": notionVersion,
    "Content-Type": "application/json",
  },
);
