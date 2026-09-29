class PageEntity {
  final String id;
  final String title;
  final String databaseId;
  final String url;
  final String? iconEmoji;
  final String? iconUrl;
  
  const PageEntity({
    required this.id,
    required this.title,
    required this.databaseId,
    required this.url,
    this.iconEmoji,
    this.iconUrl,
  });
}
