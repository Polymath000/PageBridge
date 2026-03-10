import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quicknotion/config/themes/app_colors.dart';
import 'package:quicknotion/config/themes/app_text_style.dart';
import 'package:quicknotion/core/helpers/custom_back_arrow.dart';
import 'package:quicknotion/feature/databases/domain/entities/page_entity.dart';

PreferredSizeWidget relationSearchAppBar({
  required BuildContext context,
  required String name,
  required bool isReloading,
  required List<PageEntity> selectedPages,
  required Future<void> Function() getPages,
  ValueChanged<List<PageEntity>>? onSelectionConfirmed,
}) {
  final theme = Theme.of(context);

  return PreferredSize(
    preferredSize: const Size.fromHeight(kToolbarHeight),
    child: Material(
      color: theme.scaffoldBackgroundColor,
      child: SafeArea(
        bottom: false,
        child: SizedBox(
          height: kToolbarHeight,
          child: Row(
            children: [
              CustomBackArrow(),
              Expanded(
                child: Text(
                  "Search in $name",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.titleMedium?.copyWith(fontSize: 18.sp),
                ),
              ),
              if (isReloading)
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
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
            ],
          ),
        ),
      ),
    ),
  );
}
