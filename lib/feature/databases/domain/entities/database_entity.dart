import 'package:flutter/material.dart';

class DatabaseEntity {
  final String title;
  final CoverEntity? cover;
  final IconEntity? icon;
  final List<PropertyEntity> properties;

  const DatabaseEntity({
    required this.title,
    this.cover,
    this.icon,
    required this.properties,
  });

  DatabaseEntity copyWith({
    String? title,
    CoverEntity? cover,
    IconEntity? icon,
    List<PropertyEntity>? properties,
  }) {
    return DatabaseEntity(
      title: title ?? this.title,
      cover: cover ?? this.cover,
      icon: icon ?? this.icon,
      properties: properties ?? this.properties,
    );
  }

}

class PropertyEntity {
  final String name;
  final String type;
  final bool canEdit;
  final List<SelectOptionEntity>? selectOptions;
  final String? formulaExpression;
  final String? relationDatabaseId;
  final IconData? icon;

  const PropertyEntity({
    required this.name,
    required this.type,
    required this.canEdit,
    this.selectOptions,
    this.formulaExpression,
    this.relationDatabaseId,
    this.icon,
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
