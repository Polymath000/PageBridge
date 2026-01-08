import 'dart:io';
import 'package:flutter/material.dart';
import 'package:quicknotion/config/themes/app_colors.dart';
import 'package:quicknotion/config/themes/app_text_style.dart';
import 'package:quicknotion/feature/databases/domain/entities/property_entity.dart';

class PropertyTypeText extends StatefulWidget {
  const PropertyTypeText({super.key, required this.property, this.onChanged});
  final PropertyEntity property;
  final ValueChanged<dynamic>? onChanged;

  @override
  State<PropertyTypeText> createState() => _PropertyTypeTextState();
}

class _PropertyTypeTextState extends State<PropertyTypeText> {
  File? selectedFile;

  @override
  Widget build(BuildContext context) {
    return TextField(
      maxLines: 1,
      enabled: true,
      onChanged: widget.onChanged,
      decoration: InputDecoration(
        border: InputBorder.none,
        hintText: "Empty",
        hintStyle: AppTextStyles.titleMedium!.copyWith(color: AppColors.grey),
      ),
      style: AppTextStyles.titleMedium!.copyWith(color: AppColors.black),
    );
  }
}
