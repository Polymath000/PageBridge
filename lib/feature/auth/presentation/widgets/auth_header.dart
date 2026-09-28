import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:pagebridge/config/themes/app_images.dart';
import 'package:pagebridge/core/constants/constants.dart';
import 'package:pagebridge/core/theme/app_colors.dart';

class AuthHeader extends StatelessWidget {
  const AuthHeader({super.key, required this.logoScale});

  final Animation<double> logoScale;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      children: [
        ScaleTransition(
          scale: logoScale,
          child: Container(
            width: 92,
            height: 92,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppColors.black.withValues(alpha: 0.12),
                  blurRadius: 18,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Image.asset(
              Assets.assetsImagesPageBridgeBrandLogo,
              fit: BoxFit.contain,
            ),
          ),
        ),
        const SizedBox(height: 20),
        Text(
          AppConstants.appName,
          style: textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.w700,
            color: AppColors.spaceBlack,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Capture ideas fast and sync them to your '
          'Notion workspace in seconds.',
          textAlign: TextAlign.center,
          style: textTheme.bodyMedium?.copyWith(
            color: AppColors.darkGrey,
            height: 1.4,
          ),
        ),
      ],
    );
  }
}
