import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pagebridge/core/theme/app_colors.dart';
import 'package:pagebridge/config/themes/app_text_style.dart';

import 'package:pagebridge/core/helpers/custom_back_arrow.dart';
import 'package:pagebridge/feature/databases/domain/entities/page_entity.dart';

PreferredSizeWidget relationSearchAppBar({
  required BuildContext context,
  required String name,
  required List<PageEntity> selectedPages,
  ValueChanged<List<PageEntity>>? onSelectionConfirmed,
}) {
  final colorScheme = Theme.of(context).colorScheme;
  final topPadding = MediaQuery.of(context).padding.top;
  const toolbarHeight = 70.0;

  return PreferredSize(
    preferredSize: Size.fromHeight(toolbarHeight + topPadding),
    child: DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            colorScheme.secondaryContainer,
            colorScheme.surface,
            colorScheme.secondaryContainer,
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
              data: IconThemeData(color: colorScheme.onSurface),
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
                        color: colorScheme.onSurface,
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
                        color: colorScheme.onSurface,
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
