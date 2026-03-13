import 'dart:developer';

import 'package:flutter/foundation.dart' show immutable;
import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Holds Notion OAuth configuration
@immutable
class NotionOAuthConfig {
  final String clientId;

  final String clientSecret;

  final String redirectUri;

  final String callbackScheme;

  const NotionOAuthConfig({
    required this.clientId,
    required this.clientSecret,
    required this.redirectUri,
    required this.callbackScheme,
  });

  factory NotionOAuthConfig.fromEnvironment() {
    final clientId = dotenv.env["NOTION_CLIENT_ID"] ?? "";
    final clientSecret = dotenv.env["NOTION_CLIENT_SECRET"] ?? "";
    final redirectUri = dotenv.env["NOTION_REDIRECT_URI"] ?? "";
    final callbackScheme = dotenv.env["NOTION_CALLBACK_SCHEME"] ?? "";

    return NotionOAuthConfig(
      clientId: clientId,
      clientSecret: clientSecret,
      redirectUri: redirectUri,
      callbackScheme: callbackScheme,
    );
  }

  void validate() {
    final missing = <String>[];
    if (clientId.isEmpty) missing.add('NOTION_CLIENT_ID');
    if (clientSecret.isEmpty) missing.add('NOTION_CLIENT_SECRET');
    if (redirectUri.isEmpty) missing.add('NOTION_REDIRECT_URI');
    if (missing.isNotEmpty) {
      log('Missing OAuth config: ${missing.join(', ')}. ');
      throw StateError(
        'There is an error. Please try again later and we will fix the problem.',
      );
    }

    final uri = Uri.tryParse(redirectUri);
    if (uri == null || !uri.hasScheme || !uri.hasAuthority) {
      throw StateError(
        'There is an error. Please try again later and we will fix the problem.',
      );
    }

    if (callbackScheme.isEmpty || callbackScheme.contains('://')) {
      throw StateError(
        'There is an error. Please try again later and we will fix the problem.',
      );
    }
  }
}
