import 'package:flutter/material.dart';
import 'package:pagebridge/config/themes/app_colors.dart';

class PageIndicator extends StatelessWidget {
  final ValueNotifier<int> pageIndex;
  final int pagesCount;

  const PageIndicator({
    super.key,
    required this.pageIndex,
    required this.pagesCount,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final activeColor = isDark ? AppColors.white : AppColors.spaceBlack;
    final inactiveColor = activeColor.withValues(alpha: isDark ? 0.45 : 0.3);
    return ValueListenableBuilder<int>(
      valueListenable: pageIndex,
      builder: (context, value, _) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(pagesCount, (index) {
            final isActive = index == value;
            return AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.symmetric(horizontal: 4),
              height: 6,
              width: isActive ? 22 : 8,
              decoration: BoxDecoration(
                color: isActive ? activeColor : inactiveColor,
                borderRadius: BorderRadius.circular(99),
              ),
            );
          }),
        );
      },
    );
  }
}
