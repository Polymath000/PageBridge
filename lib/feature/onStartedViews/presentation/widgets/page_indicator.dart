import 'package:flutter/material.dart';
import 'package:quicknotion/config/themes/app_colors.dart';

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
                color: isActive
                    ? AppColors.white
                    : AppColors.white.withValues(alpha: 0.4),
                borderRadius: BorderRadius.circular(99),
              ),
            );
          }),
        );
      },
    );
  }
}
