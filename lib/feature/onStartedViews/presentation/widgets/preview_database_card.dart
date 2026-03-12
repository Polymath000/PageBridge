import 'package:flutter/material.dart';
import 'package:quicknotion/config/themes/app_colors.dart';

class PreviewDatabaseCard extends StatelessWidget {
  final String title;
  final String icon;

  const PreviewDatabaseCard({super.key, required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.spaceBlack,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Text(icon, style: const TextStyle(fontSize: 18)),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              title,
              style: textTheme.titleMedium?.copyWith(
                color: AppColors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Icon(
            Icons.arrow_forward_ios_rounded,
            size: 14,
            color: AppColors.white.withValues(alpha: 0.7),
          ),
        ],
      ),
    );
  }
}
