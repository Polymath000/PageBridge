import 'package:pagebridge/feature/databases/data/model/property_model.dart';
import 'package:pagebridge/feature/databases/domain/entities/page_entity.dart';

class PageModel extends PageEntity {
  final PropertyModel properties;
  final DateTime createdTime;
  final DateTime lastEditedTime;
  final bool archived;

  PageModel({
    required super.id,
    required super.title,
    required this.createdTime,
    required this.lastEditedTime,
    required this.archived,
    required super.url,
    super.iconEmoji,
    super.iconUrl,
    required super.databaseId,
    required this.properties,
  });

  factory PageModel.fromJson(Map<String, dynamic> json) {
    String parsedTitle = 'No Title';
    final propertiesMap = json['properties'] as Map<String, dynamic>? ?? {};
    for (var value in propertiesMap.values) {
      if (value['type'] == 'title') {
        final titleList = value['title'] as List<dynamic>? ?? [];
        if (titleList.isNotEmpty) {
          parsedTitle = titleList.map((e) => e['plain_text']).join();
        }
        break;
      }
    }

    String? iconEmoji;
    String? iconUrl;
    final iconData = json['icon'];
    if (iconData != null) {
      if (iconData['type'] == 'emoji') {
        iconEmoji = iconData['emoji'];
      } else if (iconData['type'] == 'external') {
        iconUrl = iconData['external']?['url'];
      } else if (iconData['type'] == 'file') {
        iconUrl = iconData['file']?['url'];
      }
    }

    final dynamic properties = PropertyModel.fromJson(parsedTitle, json['properties']);
    
    return PageModel(
      id: json['id'],
      title: parsedTitle,
      createdTime: DateTime.parse(json['created_time']),
      lastEditedTime: DateTime.parse(json['last_edited_time']),
      archived: json['archived'] ?? false,
      url: json['url'],
      iconEmoji: iconEmoji,
      iconUrl: iconUrl,
      databaseId: json['parent']?['database_id'] ?? '',
      properties: properties,
    );
  }
}
