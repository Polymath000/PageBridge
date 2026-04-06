import 'package:flutter/material.dart';
import 'package:pagebridge/config/themes/app_colors.dart';

class PrivacyVisual extends StatelessWidget {
  const PrivacyVisual({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final foreground = isDark ? AppColors.white : AppColors.spaceBlack;
    final fillColor = foreground.withValues(alpha: isDark ? 0.12 : 0.08);
    final borderColor = foreground.withValues(alpha: isDark ? 0.35 : 0.2);
    return Container(
      width: 140,
      height: 140,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: fillColor,
        border: Border.all(
          color: borderColor,
          width: 1.2,
        ),
      ),
      child: Icon(
        Icons.lock_outline_rounded,
        size: 62,
        color: foreground,
      ),
    );
  }
}
