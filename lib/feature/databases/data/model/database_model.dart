import 'package:quicknotion/feature/databases/data/model/property_model.dart';
import 'package:quicknotion/feature/databases/domain/entities/property_entity.dart';

import '../../domain/entities/database_entity.dart';

class DatabaseModel extends DatabaseEntity {
  final String id;
  const DatabaseModel({
    required this.id,
    required super.title,
    CoverModel? super.cover,
    IconModel? super.icon,
    required List<PropertyModel> super.properties,
  });

  factory DatabaseModel.fromJson(Map<String, dynamic> json) {
    String parsedTitle = "No Title Found";
    if (json['title'] != null && (json['title'] as List).isNotEmpty) {
      final titleList = json['title'] as List;
      parsedTitle = titleList.map((t) => t['plain_text'] ?? '').join();
      if (parsedTitle.isEmpty) parsedTitle = "No Title Found";
    }

    List<PropertyModel> parsedProperties = [];
    if (json['properties'] != null) {
      (json['properties'] as Map<String, dynamic>).forEach((key, value) {
        if (value['type'] != 'button' &&
            value['type'] != 'place' &&
            value['type'] != 'created_by' &&
            value['type'] != 'relation' &&
            value['type'] != 'rollup' &&
            value['type'] != 'people' &&
            value['type'] != 'last_edited_by' &&
            value['type'] != 'last_edited_time' &&
            value['type'] != 'formula' &&
            value['type'] != 'unique_id') {
          parsedProperties.add(PropertyModel.fromJson(key, value));
        }
      });
    }

    return DatabaseModel(
      id: json['id'],
      title: parsedTitle,
      cover: json['cover'] != null ? CoverModel.fromJson(json['cover']) : null,
      icon: json['icon'] != null ? IconModel.fromJson(json['icon']) : null,
      properties: parsedProperties,
    );
  }
}

class CoverModel extends CoverEntity {
  const CoverModel({super.type, super.url});

  factory CoverModel.fromJson(Map<String, dynamic> json) {
    final type = json['type'];
    String? url;
    if (type == 'external') {
      url = json['external']['url'];
    } else if (type == 'file') {
      url = json['file']['url'];
    }
    return CoverModel(type: type, url: url);
  }
}

class IconModel extends IconEntity {
  const IconModel({super.type, super.emoji, super.url});

  factory IconModel.fromJson(Map<String, dynamic> json) {
    final type = json['type'];
    String? emoji;
    String? url;

    if (type == 'emoji') {
      emoji = json['emoji'];
    } else if (type == 'external') {
      url = json['external']['url'];
    } else if (type == 'file') {
      url = json['file']['url'];
    }
    return IconModel(type: type, emoji: emoji, url: url);
  }
}
