import 'package:flutter/material.dart';
import 'package:pagebridge/core/theme/app_colors.dart';
import 'package:pagebridge/config/themes/app_images.dart';

class WelcomeVisual extends StatelessWidget {
  const WelcomeVisual({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 140,
      height: 140,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.welcomeGradientStart,
            AppColors.welcomeGradientEnd,
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.35),
            blurRadius: 24,
            offset: const Offset(0, 16),
          ),
        ],
      ),
      child: Image.asset(
        Assets.assetsImagesPageBridgeBrandLogo,
        fit: BoxFit.contain,
      ),
    );
  }
}
