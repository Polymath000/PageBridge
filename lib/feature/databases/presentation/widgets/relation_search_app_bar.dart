import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quicknotion/config/themes/app_colors.dart';
import 'package:quicknotion/config/themes/app_text_style.dart';
import 'package:quicknotion/feature/databases/domain/entities/page_entity.dart';

PreferredSizeWidget relationSearchAppBar({
  required BuildContext context,
  required String name,
  required bool isReloading,
  required List<PageEntity> selectedPages,
  required Future<void> Function() getPages,
  ValueChanged<List<PageEntity>>? onSelectionConfirmed,
}) {
  return AppBar(
    elevation: 0,
    backgroundColor: Colors.transparent,
    title: Text(
      "Search in $name",
      style: AppTextStyles.titleMedium?.copyWith(fontSize: 18.sp),
    ),
    leading: IconButton(
      icon: const Icon(Icons.arrow_back_ios_new, size: 20),
      onPressed: () => Navigator.pop(context),
    ),
    actions: [
      if (isReloading)
        const Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          ),
        )
      else
        IconButton(
          tooltip: 'Reload',
          icon: const Icon(Icons.refresh),
          onPressed: getPages,
        ),
      TextButton(
        onPressed: () {
          onSelectionConfirmed?.call(selectedPages);
          Navigator.pop(context, selectedPages);
        },
        child: Text(
          "Done",
          style: AppTextStyles.titleMedium?.copyWith(
            color: AppColors.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      SizedBox(width: 8.w),
    ],
  );
}
