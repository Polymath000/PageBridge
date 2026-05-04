import '../../domain/entities/auth_token_entity.dart';

/// Data model for Notion OAuth token response.
class AuthTokenModel extends AuthTokenEntity {
  const AuthTokenModel({
    required super.accessToken,
    super.workspaceId,
    super.workspaceName,
    super.workspaceIcon,
    super.botId,
    super.ownerName,
    super.ownerAvatarUrl,
  });

  factory AuthTokenModel.fromJson(Map<String, dynamic> json) {
    final accessToken = json['access_token'] as String?;
    if (accessToken == null || accessToken.isEmpty) {
      throw StateError('Notion token response missing access_token.');
    }

    final owner = json['owner'] as Map<String, dynamic>?;
    final user = owner?['user'] as Map<String, dynamic>?;

    return AuthTokenModel(
      accessToken: accessToken,
      workspaceId: json['workspace_id'] as String?,
      workspaceName: json['workspace_name'] as String?,
      workspaceIcon: json['workspace_icon'] as String?,
      botId: json['bot_id'] as String?,
      ownerName: user?['name'] as String?,
      ownerAvatarUrl: user?['avatar_url'] as String?,
    );
  }
}
