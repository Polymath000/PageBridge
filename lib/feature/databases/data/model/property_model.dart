import 'package:pagebridge/feature/databases/domain/entities/property_entity.dart';
import 'package:pagebridge/core/enums/notion_property_type.dart';

class PropertyModel extends PropertyEntity {
  const PropertyModel({
    required super.name,
    required super.type,
    required super.canEdit,
    List<SelectOptionModel>? super.selectOptions,
    super.formulaExpression,
    super.relationDatabaseId,
    super.icon,
    super.value,
  });

  factory PropertyModel.fromJson(String name, Map<String, dynamic> json) {
    final String typeStr = json['type'] ?? "text";
    final typeEnum = NotionPropertyType.fromString(typeStr);

    final bool isEditable = switch (typeEnum) {
      NotionPropertyType.lastEditedTime ||
      NotionPropertyType.lastEditedBy ||
      NotionPropertyType.createdBy ||
      NotionPropertyType.createdTime ||
      NotionPropertyType.files => false,
      _ => true,
    };

    List<SelectOptionModel>? options;
    String? expression;
    String? relatedDbId;

    final config =
        json[typeStr]; // Keep typeStr here because the API payload key is still a string

    if (config != null && config is Map<String, dynamic>) {
      switch (typeEnum) {
        case NotionPropertyType.select:
        case NotionPropertyType.multiSelect:
        case NotionPropertyType.status:
          if (config['options'] != null) {
            options = (config['options'] as List)
                .map((e) => SelectOptionModel.fromJson(e))
                .toList();
          }
          break;
        case NotionPropertyType.formula:
          expression = config['expression'];
          break;
        case NotionPropertyType.relation:
          relatedDbId = config['database_id'] ?? config['data_source_id'];
          break;
        default:
          break;
      }
    }

    return PropertyModel(
      name: name,
      type: typeEnum,
      canEdit: isEditable,
      selectOptions: options,
      formulaExpression: expression,
      relationDatabaseId: relatedDbId,
    );
  }

  Map<String, dynamic> toJson() {
    if (value == null) return {};

    switch (type) {
      case NotionPropertyType.date:
        return {
          'date': {'start': value},
        };
      case NotionPropertyType.files:
        return {
          'files': (value is List)
              ? value
                    .map(
                      (file) => {
                        'name': name,
                        'external': {'url': file.toString()},
                      },
                    )
                    .toList()
              : [],
        };
      case NotionPropertyType.checkbox:
        return {'checkbox': value as bool};
      case NotionPropertyType.status:
        return {
          'status': {'name': value},
        };
      case NotionPropertyType.select:
        return {
          'select': {'name': value},
        };
      case NotionPropertyType.multiSelect:
        return {
          'multi_select': (value is List)
              ? value.map((n) => {'name': n}).toList()
              : [],
        };
      case NotionPropertyType.url:
        return {'url': value as String};
      case NotionPropertyType.richText:
        return {
          'rich_text': [
            {
              'text': {'content': value as String},
            },
          ],
        };
      case NotionPropertyType.phoneNumber:
        return {'phone_number': value as String};
      case NotionPropertyType.email:
        return {'email': value as String};
      case NotionPropertyType.number:
        return {
          'number': value is num ? value : num.tryParse(value.toString()),
        };
      case NotionPropertyType.title:
        return {
          'title': [
            {
              'text': {'content': value as String},
            },
          ],
        };
      case NotionPropertyType.relation:
        return {
          'relation': (value is List)
              ? value.map((id) => {'id': id}).toList()
              : [],
        };
      case NotionPropertyType.text:
        return {
          'rich_text': [
            {
              'text': {'content': value as String},
            },
          ],
        };
      default:
        return {};
    }
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

  Map<String, dynamic> toJson() {
    return {'name': name, 'color': color};
  }
}
