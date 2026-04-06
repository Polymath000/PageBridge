import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pagebridge/config/themes/app_colors.dart';
import 'package:pagebridge/config/themes/app_text_style.dart';

class PropertyTypeText extends StatefulWidget {
  const PropertyTypeText({super.key, this.onChanged});
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
        hintStyle: AppTextStyles.titleMedium!.copyWith(
          color: Theme.of(context).brightness == Brightness.light
              ? AppColors.grey
              : AppColors.white,
          fontSize: 16.sp,
        ),
      ),
      style: AppTextStyles.titleMedium!.copyWith(
        color: AppColors.black,
        fontSize: 16.sp,
      ),
    );
  }
}
