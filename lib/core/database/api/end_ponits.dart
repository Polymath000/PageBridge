import 'package:dio/dio.dart';

sealed class EndPoint {
  const EndPoint();
  static const String baseUrl = 'https://api.notion.com/v1';
  // Endpoints are relative paths — DioConsumer sets the baseUrl to `baseUrl`.
  // This endpoint needs: Token (Authorization), Notion-Version and a body.
  static const String search = '/search';
  // This endpoint needs: Token, Notion-Version and a page body.
  static const String addNewPage = '/pages/';
}

Options headers(String token) => Options(
  headers: {
    "Authorization": "Bearer $token",
    "Notion-Version": "2022-06-28",
    "Content-Type": "application/json",
  },
);
