import 'package:flutter/material.dart';
import 'package:quicknotion/config/themes/app_colors.dart';

class PreviewField extends StatelessWidget {
  final String label;
  final String value;
  final TextTheme textTheme;

  const PreviewField({super.key, 
    required this.label,
    required this.value,
    required this.textTheme,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final foreground = isDark ? AppColors.white : AppColors.spaceBlack;
    final fillColor = foreground.withValues(alpha: isDark ? 0.08 : 0.06);
    final borderColor = foreground.withValues(alpha: isDark ? 0.14 : 0.12);
    final labelColor =
        isDark ? AppColors.white.withValues(alpha: 0.6) : AppColors.darkGrey;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: fillColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        children: [
          Text(
            label,
            style: textTheme.labelMedium?.copyWith(
              color: labelColor,
            ),
          ),
          const Spacer(),
          Text(
            value,
            style: textTheme.labelLarge?.copyWith(
              color: foreground,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
