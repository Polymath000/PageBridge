import 'package:flutter/material.dart';
import 'package:quicknotion/core/utls/custom_check_box.dart';
import 'package:quicknotion/feature/databases/domain/entities/database_entity.dart';
import 'package:quicknotion/feature/databases/domain/entities/property_entity.dart';
import 'package:quicknotion/feature/databases/presentation/widgets/property_type_notion_date_widget.dart';
import 'package:quicknotion/feature/databases/presentation/widgets/property_type_multi_select.dart';
import 'package:quicknotion/feature/databases/presentation/widgets/property_type_select_one_item.dart';
import 'package:quicknotion/feature/databases/presentation/widgets/property_type_text_and_file.dart';

class PropertyType extends StatefulWidget {
  const PropertyType({super.key, required this.property, this.onChanged});
  final PropertyEntity property;
  final ValueChanged<dynamic>? onChanged;

  @override
  State<PropertyType> createState() => _PropertyTypeState();
}

class _PropertyTypeState extends State<PropertyType> {
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.sizeOf(context).width * 0.55,
      child:
          widget.property.type == 'text' ||
              widget.property.type == 'number' ||
              widget.property.type == 'url' ||
              widget.property.type == 'rich_text' ||
              widget.property.type == 'phone_number' ||
              widget.property.type == 'email' ||
              widget.property.type == 'created_time' ||
              widget.property.type == 'title' ||
              widget.property.type == "files"
          ? PropertyTypeTextAndFile(
              property: widget.property,
              onChanged: widget.onChanged,
            )
          : widget.property.type == 'select' || widget.property.type == "status"
          ? PropertyTypeSelectOneItem(widget: widget)
          : widget.property.type == 'multi_select'
          ? PropertyTypeMultiSelect(
              property: widget.property,
              onChanged: widget.onChanged,
            )
          : widget.property.type == "checkbox"
          ? CustomCheckBox(onChanged: widget.onChanged)
          : widget.property.type == "date"
          ? NotionDateWidget(widget: widget)
          : Container(),
    );
  }
}
