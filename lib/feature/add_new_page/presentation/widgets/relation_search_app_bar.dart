import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pagebridge/core/theme/app_colors.dart';
import 'package:pagebridge/config/themes/app_text_style.dart';
import 'package:pagebridge/core/helpers/custom_back_arrow.dart';

class RelationSearchAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String name;
  final VoidCallback onDone;

  const RelationSearchAppBar({
    super.key,
    required this.name,
    required this.onDone,
  });

  @override
  Size get preferredSize {
    // Note: We use a fixed height, the system top padding is handled safely by SafeArea or Padding
    return const Size.fromHeight(70.0);
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final topPadding = MediaQuery.of(context).padding.top;

    return PreferredSize(
      preferredSize: Size.fromHeight(70.0 + topPadding),
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
              height: 70.0,
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
                      onPressed: onDone,
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
}
