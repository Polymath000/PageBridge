import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quicknotion/core/utls/custom_check_box.dart';
import 'package:quicknotion/core/utls/setup_service_locator_getit.dart';
import 'package:quicknotion/feature/databases/data/repos/return_pages_repo_impl.dart';
import 'package:quicknotion/feature/databases/domain/entities/property_entity.dart';
import 'package:quicknotion/feature/databases/presentation/controllers/return_pages_cubit/return_pages_cubit.dart';
import 'package:quicknotion/feature/databases/presentation/widgets/property_type_notion_date_widget.dart';
import 'package:quicknotion/feature/databases/presentation/widgets/property_type_multi_select.dart';
import 'package:quicknotion/feature/databases/presentation/widgets/property_type_select_one_item.dart';
import 'package:quicknotion/feature/databases/presentation/widgets/property_type_text.dart';
import 'package:quicknotion/feature/databases/presentation/widgets/property_type_file.dart';
import 'package:quicknotion/feature/databases/presentation/widgets/relation_type_widget.dart';

class PropertyType extends StatefulWidget {
  const PropertyType({super.key, required this.property, this.onChanged});
  final PropertyEntity property;
  final ValueChanged<dynamic>? onChanged;

  @override
  State<PropertyType> createState() => _PropertyTypeState();
}

class _PropertyTypeState extends State<PropertyType> {
  @override
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
              widget.property.type == 'created_time'
          ? PropertyTypeText(onChanged: widget.onChanged)
          : widget.property.type == "files"
          ? PropertyTypeFile(onChanged: widget.onChanged)
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
          ? NotionDateWidget(propertyType: widget)
          : widget.property.type == "relation"
          ? BlocProvider(
              create: (context) =>
                  ReturnPagesCubit(repoImpl: getit.get<ReturnPagesRepoImpl>()),
              child: RelationTypeWidget(property: widget.property),
            )
          : Container(),
    );
  }
}
