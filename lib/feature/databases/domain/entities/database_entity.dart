import 'package:pagebridge/feature/databases/domain/entities/property_entity.dart';

class DatabaseEntity {
  final String id;
  final String title;
  final CoverEntity? cover;
  final IconEntity? icon;
  final List<PropertyEntity> properties;

  const DatabaseEntity({
    required this.id,
    required this.title,
    this.cover,
    this.icon,
    required this.properties,
  });

  DatabaseEntity copyWith({
    String? id,
    String? title,
    CoverEntity? cover,
    IconEntity? icon,
    List<PropertyEntity>? properties,
  }) {
    return DatabaseEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      cover: cover ?? this.cover,
      icon: icon ?? this.icon,
      properties: properties ?? this.properties,
    );
  }
}
