class AuthTokenEntity {
  final String accessToken;
  final String? workspaceId;
  final String? workspaceName;
  final String? botId;

  const AuthTokenEntity({
    required this.accessToken,
    this.workspaceId,
    this.workspaceName,
    this.botId,
  });
}
