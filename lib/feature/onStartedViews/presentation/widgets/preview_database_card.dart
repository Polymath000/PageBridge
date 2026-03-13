import 'package:flutter/material.dart';
import 'package:quicknotion/config/themes/app_colors.dart';

class PreviewDatabaseCard extends StatelessWidget {
  final String title;
  final String icon;

  const PreviewDatabaseCard({super.key, required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDark ? AppColors.spaceBlack : AppColors.white;
    final foregroundColor = isDark ? AppColors.white : AppColors.spaceBlack;
    final borderColor = isDark
        ? AppColors.transparent
        : AppColors.spaceBlack.withValues(alpha: 0.08);
    final textTheme = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        children: [
          Text(icon, style: const TextStyle(fontSize: 18)),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              title,
              style: textTheme.titleMedium?.copyWith(
                color: foregroundColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Icon(
            Icons.arrow_forward_ios_rounded,
            size: 14,
            color: foregroundColor.withValues(alpha: 0.7),
          ),
        ],
      ),
    );
  }
}
