import 'package:flutter/material.dart';
import 'package:pagebridge/core/utls/custom_check_box.dart';
import 'package:pagebridge/feature/databases/domain/entities/property_entity.dart';
import 'package:pagebridge/feature/databases/presentation/widgets/property_type_multi_select.dart';
import 'package:pagebridge/feature/databases/presentation/widgets/property_type_notion_date_widget.dart';
import 'package:pagebridge/feature/databases/presentation/widgets/property_type_select_one_item.dart';
import 'package:pagebridge/feature/databases/presentation/widgets/property_type_text.dart';
import 'package:pagebridge/feature/add_new_page/presentation/widgets/relation_type_widget.dart';
import 'package:pagebridge/core/enums/notion_property_type.dart';

class PropertyType extends StatelessWidget {
  const PropertyType({super.key, required this.property, this.onChanged});
  final PropertyEntity property;
  final ValueChanged<dynamic>? onChanged;

  @override
  Widget build(BuildContext context) {
    return switch (property.type) {
      NotionPropertyType.text ||
      NotionPropertyType.number ||
      NotionPropertyType.url ||
      NotionPropertyType.richText ||
      NotionPropertyType.phoneNumber ||
      NotionPropertyType.email ||
      NotionPropertyType.createdTime => PropertyTypeText(onChanged: onChanged),

      NotionPropertyType.select ||
      NotionPropertyType.status => PropertyTypeSelectOneItem(widget: this),

      NotionPropertyType.multiSelect => PropertyTypeMultiSelect(
        property: property,
        onChanged: onChanged,
      ),

      NotionPropertyType.checkbox => CustomCheckBox(onChanged: onChanged),

      NotionPropertyType.date => NotionDateWidget(propertyType: this),

      NotionPropertyType.relation => RelationTypeWidget(
        property: property,
        onChanged: onChanged,
      ),

      _ => const SizedBox.shrink(),
    };
  }
}
