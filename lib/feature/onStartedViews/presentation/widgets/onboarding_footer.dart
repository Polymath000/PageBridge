import 'package:flutter/material.dart';
import 'package:quicknotion/config/themes/app_colors.dart';
import 'package:quicknotion/feature/onStartedViews/presentation/widgets/page_indicator.dart';

class OnboardingFooter extends StatelessWidget {
  final ValueNotifier<int> pageIndex;
  final int pagesCount;
  final VoidCallback onPrimaryAction;
  final String Function() primaryLabelBuilder;

  const OnboardingFooter({
    super.key,
    required this.pageIndex,
    required this.pagesCount,
    required this.onPrimaryAction,
    required this.primaryLabelBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
      child: Column(
        children: [
          PageIndicator(pageIndex: pageIndex, pagesCount: pagesCount),
          const SizedBox(height: 18),
          SizedBox(
            width: double.infinity,
            child: ValueListenableBuilder<int>(
              valueListenable: pageIndex,
              builder: (context, _, __) {
                final label = primaryLabelBuilder();
                return ElevatedButton(
                  onPressed: onPrimaryAction,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    backgroundColor: AppColors.white,
                    foregroundColor: AppColors.spaceBlack,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 180),
                    child: Text(label, key: ValueKey(label)),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
