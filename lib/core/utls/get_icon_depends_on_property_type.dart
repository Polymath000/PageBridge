import 'package:flutter/material.dart';
import 'package:quicknotion/config/themes/app_icons.dart';

IconData getIconDependsOnPropertyType(String type) {
  switch (type) {
    case "url":
      return AppIcons.listIcon;
    case 'title':
    case "rich_text":
      return AppIcons.title;
    case "phone_number":
      return AppIcons.phone;
    case "email":
      return AppIcons.email;
    case "number":
      return AppIcons.number;
    case "created_time":
      return AppIcons.clock;
    case "multi_select":
      return AppIcons.listIcon;
    case "select":
      return AppIcons.select;
    case "status":
      return AppIcons.status;
    case "checkbox":
      return AppIcons.checkbox;
    case "files":
      return AppIcons.files;
    case "date":
      return AppIcons.calender;
    case "relation":
      return AppIcons.relationArrow;
    default:
      return AppIcons.save;
  }
}
