import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pagebridge/config/themes/app_colors.dart';
import 'package:pagebridge/config/themes/app_text_style.dart';

class TitleProperty extends StatelessWidget {
  const TitleProperty({super.key, required this.onChanged});

  final ValueChanged<dynamic>? onChanged;

  @override
  Widget build(BuildContext context) {
    final isLight = Theme.of(context).brightness == Brightness.light;
    final textColor = isLight ? AppColors.spaceBlack : AppColors.white;

    return TextField(
      onChanged: onChanged,
      maxLines: 2,
      decoration: InputDecoration(
        hintText: 'New Page',
        labelStyle: AppTextStyles.titleLarge!.copyWith(
          color: textColor,
          fontSize: 22.sp,
        ),
        hintStyle: AppTextStyles.titleLarge!.copyWith(
          color: textColor,
          fontSize: 22.sp,
        ),
        border: InputBorder.none,
      ),
      style: AppTextStyles.titleLarge!.copyWith(
        color: textColor,
        fontSize: 22.sp,
      ),
    );
  }
}
