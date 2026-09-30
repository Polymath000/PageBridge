import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pagebridge/config/themes/app_text_style.dart';

class PropertyTypeText extends StatelessWidget {
  const PropertyTypeText({super.key, this.onChanged});
  final ValueChanged<dynamic>? onChanged;

  @override
  Widget build(BuildContext context) {
    return TextField(
      maxLines: 1,
      enabled: true,
      onChanged: onChanged,
      decoration: InputDecoration(
        border: InputBorder.none,
        hintText: "Empty",
        hintStyle: AppTextStyles.titleMedium?.copyWith(
          color: Theme.of(context).colorScheme.onSurfaceVariant,
          fontSize: 16.sp,
        ),
      ),
      style: AppTextStyles.titleMedium?.copyWith(
        color: Theme.of(context).colorScheme.onSurface,
        fontSize: 16.sp,
      ),
    );
  }
}
