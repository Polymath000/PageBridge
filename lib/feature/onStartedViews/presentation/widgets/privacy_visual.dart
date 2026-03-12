import 'package:flutter/material.dart';
import 'package:quicknotion/config/themes/app_colors.dart';

class PrivacyVisual extends StatelessWidget {
  const PrivacyVisual({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 140,
      height: 140,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.white.withValues(alpha: 0.12),
        border: Border.all(
          color: AppColors.white.withValues(alpha: 0.4),
          width: 1.2,
        ),
      ),
      child: const Icon(
        Icons.lock_outline_rounded,
        size: 62,
        color: AppColors.white,
      ),
    );
  }
}
