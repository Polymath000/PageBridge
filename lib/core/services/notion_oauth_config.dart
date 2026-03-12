import 'dart:developer';

import 'package:flutter/foundation.dart' show immutable;

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
    //TODO:handle the .env here
    const clientId = "2a9d872b-594c-80bc-854d-003719e3f508";
    const clientSecret = "secret_CoWD69w40RJV82HoBtCmySQ28ZwgeJL9KtqkRliA1k0";
    const redirectUri = "https://polymath000.github.io/notion-callback/";
    const callbackScheme = 'quicknotion';

    return const NotionOAuthConfig(
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
