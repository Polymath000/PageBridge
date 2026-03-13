import 'package:flutter/material.dart';
import 'package:quicknotion/config/themes/app_colors.dart';

class OnboardingHeader extends StatelessWidget {
  final ValueNotifier<int> pageIndex;
  final VoidCallback onSkip;

  const OnboardingHeader({super.key, required this.pageIndex, required this.onSkip});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final foreground = isDark ? AppColors.white : AppColors.spaceBlack;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          ValueListenableBuilder<int>(
            valueListenable: pageIndex,
            builder: (context, value, _) {
              if (value != 0) return const SizedBox(height: 40);
              return TextButton(
                onPressed: onSkip,
                style: TextButton.styleFrom(foregroundColor: foreground),
                child: const Text('Skip'),
              );
            },
          ),
        ],
      ),
    );
  }
}
