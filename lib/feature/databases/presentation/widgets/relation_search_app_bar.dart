import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quicknotion/config/themes/app_colors.dart';
import 'package:quicknotion/config/themes/app_text_style.dart';
import 'package:quicknotion/core/helpers/custom_back_arrow.dart';
import 'package:quicknotion/feature/databases/domain/entities/page_entity.dart';

PreferredSizeWidget relationSearchAppBar({
  required BuildContext context,
  required String name,
  required List<PageEntity> selectedPages,
  ValueChanged<List<PageEntity>>? onSelectionConfirmed,
}) {
  final isLight = Theme.of(context).brightness == Brightness.light;
  final topPadding = MediaQuery.of(context).padding.top;
  const toolbarHeight = 70.0;

  return PreferredSize(
    preferredSize: Size.fromHeight(toolbarHeight + topPadding),
    child: DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(24)),
        gradient: LinearGradient(
          colors: [
            isLight ? AppColors.darkerEdge : AppColors.grey,
            AppColors.darkGrey,
            isLight ? AppColors.grey : AppColors.darkerEdge,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Material(
        color: AppColors.transparent,
        child: Padding(
          padding: EdgeInsets.only(top: topPadding),
          child: SizedBox(
            height: toolbarHeight,
            child: IconTheme(
              data: const IconThemeData(color: AppColors.white),
              child: Row(
                children: [
                  const CustomBackArrow(),
                  Expanded(
                    child: Text(
                      "Search in $name",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.titleMedium?.copyWith(
                        fontSize: 18.sp,
                        color: AppColors.white,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      onSelectionConfirmed?.call(selectedPages);
                      Navigator.pop(context, selectedPages);
                    },
                    child: Text(
                      "Done",
                      style: AppTextStyles.titleMedium?.copyWith(
                        color: AppColors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    ),
  );
}
