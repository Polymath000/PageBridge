import 'package:flutter/material.dart';
import 'package:quicknotion/feature/databases/domain/entities/property_entity.dart';
import 'package:flutter/widgets.dart';

class PropertyModel extends PropertyEntity {
  const PropertyModel({
    required super.name,
    required super.type,
    required super.canEdit,
    List<SelectOptionModel>? super.selectOptions,
    super.formulaExpression,
    super.relationDatabaseId,
    IconData? super.icon,
    super.value,
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
    IconData? icon;

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
      icon: icon,
    );
  }

  Map<String, dynamic> toJson() {
    if (value == null) return {};

    switch (type) {
      // Different Types
      case 'date':
        return {
          'date': {'start': value},
        };
      case 'files':
        // Assuming value is a list of file URLs or objects, defaulting to empty if not list
        // Note: Notion API requires external URL for creating files
        return {
          'files': (value is List)
              ? value
                    .map(
                      (file) => {
                        'name': 'File',
                        'external': {'url': file.toString()},
                      },
                    )
                    .toList()
              : [],
        };
      case 'checkbox':
        return {'checkbox': value as bool};

      // Drop Menu
      case 'status':
        return {
          'status': {'name': value},
        };
      case 'select':
        return {
          'select': {'name': value},
        };
      case 'multi_select':
        // Assuming value is a list of names
        return {
          'multi_select': (value is List)
              ? value.map((name) => {'name': name}).toList()
              : [],
        };

      // String
      case 'url':
        return {'url': value as String};
      case 'rich_text':
        return {
          'rich_text': [
            {
              'text': {'content': value as String},
            },
          ],
        };
      case 'phone_number':
        return {'phone_number': value as String};
      case 'email':
        return {'email': value as String};
      case 'number':
        // Ensure it's a number
        return {
          'number': value is num ? value : num.tryParse(value.toString()),
        };
      case 'title':
        return {
          'title': [
            {
              'text': {'content': value as String},
            },
          ],
        };

      // Not Supported / Read-only (Ignore)
      case 'created_time':
      case 'place':
      case 'created_by':
      case 'relation':
      case 'rollup':
      case 'people':
      case 'button':
      case 'last_edited_by':
      case 'last_edited_time':
      case 'formula':
      case 'unique_id':
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
