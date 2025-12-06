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
    final Map<String, dynamic> config = {};
    if (['select', 'multi_select', 'status'].contains(type)) {
      config['options'] =
          selectOptions
              ?.map((e) => (e as SelectOptionModel).toJson())
              .toList() ??
          [];
    } else if (type == 'formula') {
      config['expression'] = formulaExpression ?? '';
    } else if (type == 'relation') {
      config['database_id'] = relationDatabaseId ?? '';
    }
    return {type: config};
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
