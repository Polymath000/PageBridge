import '../../domain/entities/auth_token_entity.dart';

/// Data model for Notion OAuth token response.
class AuthTokenModel extends AuthTokenEntity {
  const AuthTokenModel({
    required super.accessToken,
    super.workspaceId,
    super.workspaceName,
    super.botId,
  });

  factory AuthTokenModel.fromJson(Map<String, dynamic> json) {
    final accessToken = json['access_token'] as String?;
    if (accessToken == null || accessToken.isEmpty) {
      throw StateError('Notion token response missing access_token.');
    }

    return AuthTokenModel(
      accessToken: accessToken,
      workspaceId: json['workspace_id'] as String?,
      workspaceName: json['workspace_name'] as String?,
      botId: json['bot_id'] as String?,
    );
  }
}
