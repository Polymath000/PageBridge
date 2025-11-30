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
        if (value['type'] != 'button') {
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

class PropertyModel extends PropertyEntity {
  const PropertyModel({
    required super.name,
    required super.type,
    required super.canEdit,
    List<SelectOptionModel>? super.selectOptions,
    super.formulaExpression,
    super.relationDatabaseId,
  });

  factory PropertyModel.fromJson(String name, Map<String, dynamic> json) {
    final type = json['type'];

    bool isEditable = true;
    const nonEditableTypes = [
      'last_edited_time',
      'last_edited_by',
      'created_by',
      'created_time',
    ];
    if (nonEditableTypes.contains(type)) {
      isEditable = false;
    }

    List<SelectOptionModel>? options;
    String? expression;
    String? relatedDbId;

    final config = json[type];
    if (config != null && config is Map<String, dynamic>) {
      if (['select', 'multi_select', 'status'].contains(type)) {
        if (config['options'] != null) {
          options = (config['options'] as List)
              .map((e) => SelectOptionModel.fromJson(e))
              .toList();
        }
      }

      if (type == 'formula') {
        expression = config['expression'];
      }

      if (type == 'relation') {
        relatedDbId = config['database_id'];
      }
    }

    return PropertyModel(
      name: name,
      type: type,
      canEdit: isEditable,
      selectOptions: options,
      formulaExpression: expression,
      relationDatabaseId: relatedDbId,
    );
  }
}

class SelectOptionModel extends SelectOptionEntity {
  const SelectOptionModel({required super.name, required super.color});

  factory SelectOptionModel.fromJson(Map<String, dynamic> json) {
    return SelectOptionModel(
      name: json['name'] ?? '',
      color: json['color'] ?? 'default',
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
