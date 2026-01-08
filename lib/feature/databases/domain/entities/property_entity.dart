import 'package:flutter/material.dart';

class PropertyEntity {
  final String name;
  final String type;
  final bool canEdit;
  final List<SelectOptionEntity>? selectOptions;
  final String? formulaExpression;
  final String? relationDatabaseId;
  final IconData? icon;
  final dynamic value;

  const PropertyEntity({
    required this.name,
    required this.type,
    required this.canEdit,
    this.selectOptions,
    this.formulaExpression,
    this.relationDatabaseId,
    this.icon,
    this.value,
  });

  copyWith({required IconData icon}) {
    return PropertyEntity(
      name: name,
      type: type,
      canEdit: canEdit,
      selectOptions: selectOptions,
      formulaExpression: formulaExpression,
      relationDatabaseId: relationDatabaseId,
      icon: icon,
      value: value,
    );
  }
}

class SelectOptionEntity {
  final String name;
  final String color;

  const SelectOptionEntity({required this.name, required this.color});
}

class CoverEntity {
  final String? type;
  final String? url;

  const CoverEntity({this.type, this.url});
}

class IconEntity {
  final String? type;
  final String? emoji;
  final String? url;
  const IconEntity({this.type, this.emoji, this.url});
}
