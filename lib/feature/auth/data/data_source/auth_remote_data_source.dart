import 'dart:convert';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter_web_auth_2/flutter_web_auth_2.dart';
import 'package:quicknotion/core/database/api/dio_consumer.dart';
import 'package:quicknotion/core/database/api/end_ponits.dart';
import 'package:quicknotion/core/services/notion_oauth_config.dart';

import '../models/auth_token_model.dart';

abstract class AuthRemoteDataSource {
  Future<AuthTokenModel> signInWithNotion();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final DioConsumer dioConsumer;
  final NotionOAuthConfig config;

  const AuthRemoteDataSourceImpl({
    required this.dioConsumer,
    required this.config,
  });

  @override
  Future<AuthTokenModel> signInWithNotion() async {
    config.validate();
    final state = _generateState();
    final authorizeUri = _buildAuthorizeUri(state);
    final callbackUrl = await _authenticate(authorizeUri);
    final code = _extractCode(callbackUrl, state);
    final data = await _exchangeCodeForToken(code);
    return AuthTokenModel.fromJson(data);
  }

  Uri _buildAuthorizeUri(String state) =>
      Uri.https('api.notion.com', '/v1${EndPoint.oAuth}', {
        'client_id': config.clientId,
        'response_type': 'code',
        'owner': 'user',
        'redirect_uri': config.redirectUri,
        'state': state,
      });

  Future<String> _authenticate(Uri authorizeUri) async =>
      FlutterWebAuth2.authenticate(
        url: authorizeUri.toString(),
        callbackUrlScheme: config.callbackScheme,
      );

  String _extractCode(String callbackUrl, String expectedState) {
    final resultUri = Uri.parse(callbackUrl);
    final error = resultUri.queryParameters['error'];
    if (error != null && error.isNotEmpty) {
      throw StateError('Notion authentication failed.');
    }

    final code = resultUri.queryParameters['code'];
    final returnedState = resultUri.queryParameters['state'];
    if (code == null || code.isEmpty) {
      throw StateError('Notion authentication failed.');
    }
    if (returnedState == null || returnedState != expectedState) {
      throw StateError('Notion authentication failed.');
    }

    return code;
  }

  Future<Map<String, dynamic>> _exchangeCodeForToken(String code) async {
    final response = await dioConsumer.post(
      EndPoint.token,
      data: {
        'grant_type': 'authorization_code',
        'code': code,
        'redirect_uri': config.redirectUri,
      },
      options: Options(
        headers: {
          'Authorization': _basicAuthHeader(),
          'Content-Type': 'application/json',
        },
      ),
    );

    final data = response.data;
    if (data is! Map<String, dynamic>) {
      throw StateError('Notion authentication failed.');
    }

    return data;
  }

  String _basicAuthHeader() {
    final credentials = '${config.clientId}:${config.clientSecret}';
    return 'Basic ${base64Encode(utf8.encode(credentials))}';
  }

  String _generateState() {
    final random = Random.secure();
    final bytes = List<int>.generate(16, (_) => random.nextInt(256));
    return base64UrlEncode(bytes);
  }
}
