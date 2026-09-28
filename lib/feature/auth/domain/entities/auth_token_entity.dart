class UserEntity {
  final String accessToken;
  final String? workspaceId;
  final String? workspaceName;
  final String? workspaceIcon;
  final String? botId;
  final String? ownerName;
  final String? ownerAvatarUrl;

  const UserEntity({
    required this.accessToken,
    this.workspaceId,
    this.workspaceName,
    this.workspaceIcon,
    this.botId,
    this.ownerName,
    this.ownerAvatarUrl,
  });
}
