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
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.white.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.white.withValues(alpha: 0.1)),
      ),
      child: Row(
        children: [
          Text(
            label,
            style: textTheme.labelMedium?.copyWith(
              color: AppColors.white.withValues(alpha: 0.6),
            ),
          ),
          const Spacer(),
          Text(
            value,
            style: textTheme.labelLarge?.copyWith(
              color: AppColors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
