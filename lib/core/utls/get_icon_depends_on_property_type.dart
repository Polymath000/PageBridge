import 'package:flutter/material.dart';
import 'package:pagebridge/core/enums/notion_property_type.dart';

IconData getIconDependsOnPropertyType(NotionPropertyType type) {
  return switch (type) {
    NotionPropertyType.text || NotionPropertyType.richText => Icons.text_fields_outlined,
    NotionPropertyType.number => Icons.numbers,
    NotionPropertyType.select => Icons.arrow_drop_down_circle_outlined,
    NotionPropertyType.multiSelect => Icons.list,
    NotionPropertyType.status => Icons.assignment_turned_in_outlined,
    NotionPropertyType.date => Icons.date_range_outlined,
    NotionPropertyType.person => Icons.person_outline,
    NotionPropertyType.files => Icons.attach_file,
    NotionPropertyType.checkbox => Icons.check_box_outlined,
    NotionPropertyType.url => Icons.link,
    NotionPropertyType.email => Icons.email_outlined,
    NotionPropertyType.phoneNumber => Icons.phone_outlined,
    NotionPropertyType.formula => Icons.functions,
    NotionPropertyType.relation => Icons.compare_arrows,
    NotionPropertyType.rollup => Icons.search,
    NotionPropertyType.createdTime => Icons.access_time,
    NotionPropertyType.createdBy => Icons.person_add_alt_1_outlined,
    NotionPropertyType.lastEditedTime => Icons.update,
    NotionPropertyType.lastEditedBy => Icons.person_search_outlined,
    NotionPropertyType.title => Icons.title,
    NotionPropertyType.unknown => Icons.device_unknown_outlined,
  };
}
