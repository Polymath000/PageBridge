import 'package:flutter/material.dart';
import 'package:quicknotion/config/themes/app_colors.dart';

class OnboardingPage extends StatelessWidget {
  final String title;
  final String description;
  final Widget Function() visualBuilder;

  const OnboardingPage({super.key, 
    required this.title,
    required this.description,
    required this.visualBuilder,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Column(
            children: [
              visualBuilder(),
              const SizedBox(height: 24),
              Text(
                title,
                textAlign: TextAlign.center,
                style: textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: AppColors.white,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                description,
                textAlign: TextAlign.center,
                style: textTheme.bodyMedium?.copyWith(
                  color: AppColors.white.withValues(alpha: 0.75),
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
