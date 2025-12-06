import 'package:flutter/material.dart';
import 'package:quicknotion/feature/databases/domain/entities/property_entity.dart';

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