import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_web_auth_2/flutter_web_auth_2.dart';

class AuthService {
  static const String _clientId = '2a9d872b-594c-80bc-854d-003719e3f508';
  // TODO: Move this to a secure storage or environment variable
  static const String _clientSecret =
      'secret_CoWD69w40RJV82HoBtCmySQ28ZwgeJL9KtqkRliA1k0';
  static const String _redirectUri =
      'https://polymath000.github.io/notion-callback/';

  Future<String?> authenticateWithNotion() async {
    final url = Uri.parse(
      //https://api.notion.com/v1/oauth/authorize?client_id=2a9d872b-594c-80bc-854d-003719e3f508&response_type=code&owner=user&redirect_uri=https%3A%2F%2Fpolymath000.github.io%2Fnotion-callback%2F
      "https://api.notion.com/v1/oauth/authorize?client_id=2a9d872b-594c-80bc-854d-003719e3f508&response_type=code&owner=user&redirect_uri=https%3A%2F%2Fpolymath000.github.io%2Fnotion-callback%2F",
    );
    try {
      final result = await FlutterWebAuth2.authenticate(
        url: url.toString(),
        callbackUrlScheme: 'myapp',
      );
      final code = Uri.parse(result).queryParameters['code'];
      return code;
    } catch (e) {
      print('Authentication error: $e');
      return null;
    }
  }

  Future<String?> exchangeCodeForToken(String code) async {
    try {
      final response = await http.post(
        Uri.parse('https://api.notion.com/v1/oauth/token'),
        headers: {
          'Authorization':
              'Basic ${base64Encode(utf8.encode('$_clientId:$_clientSecret'))}',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'grant_type': 'authorization_code',
          'code': code,
          'redirect_uri': _redirectUri,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['access_token'];
      } else {
        print('Token exchange failed: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Error exchanging code for token: $e');
      return null;
    }
  }

  Future<void> fetchAccessibleDatabases(String accessToken) async {
    try {
      final response = await http.post(
        Uri.parse('https://api.notion.com/v1/search'),
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Notion-Version': '2022-06-28',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'filter': {'value': 'database', 'property': 'object'},
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final results = data['results'] as List;
        print('Found ${results.length} accessible databases:');
        for (var db in results) {
          final titleList = db['title'] as List?;
          final title = titleList != null && titleList.isNotEmpty
              ? titleList[0]['plain_text']
              : 'Untitled';
          print('- ID: ${db['id']}, Title: $title');
        }
      } else {
        print('Failed to fetch databases: ${response.body}');
      }
    } catch (e) {
      print('Error fetching databases: $e');
    }
  }
}
