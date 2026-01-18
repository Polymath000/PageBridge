import 'package:quicknotion/feature/databases/data/model/property_model.dart';
import 'package:quicknotion/feature/databases/domain/entities/page_entity.dart';

class PageModel extends PageEntity {
  final PropertyModel properties;
  final DateTime createdTime;
  final DateTime lastEditedTime;
  final bool archived;
  final String url;

  PageModel({
    required super.id,
    required super.title,
    required this.createdTime,
    required this.lastEditedTime,
    required this.archived,
    required this.url,
    required super.databaseId,
    required this.properties,
  });

  factory PageModel.fromJson(Map<String, dynamic> json) {
    final titleList =
        json['properties']?['Task']?['title'] as List<dynamic>? ?? [];

    final title = titleList.isNotEmpty
        ? titleList.map((e) => e['plain_text']).join()
        : 'No Title';

    return PageModel(
      id: json['id'],
      title: title,
      createdTime: DateTime.parse(json['created_time']),
      lastEditedTime: DateTime.parse(json['last_edited_time']),
      archived: json['archived'] ?? false,
      url: json['url'],
      databaseId: json['parent']?['database_id'] ?? '',
      properties: PropertyModel.fromJson(title, json['properties']),
    );
  }
}
