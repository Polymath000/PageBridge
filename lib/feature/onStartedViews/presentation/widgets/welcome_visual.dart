import 'package:flutter/material.dart';
import 'package:quicknotion/config/themes/app_colors.dart';
import 'package:quicknotion/core/utls/app_images.dart';

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
          colors: [Color(0xFFF5F7FA), Color(0xFFD7DCE4)],
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
        Assets.assetsImagesQuickNotionLogo,
        fit: BoxFit.contain,
      ),
    );
  }
}
