import 'package:flutter/material.dart';
import 'package:pagebridge/core/constants/constants.dart';
import 'package:pagebridge/core/theme/app_colors.dart';

class AppTitleAndLoader extends StatelessWidget {
  const AppTitleAndLoader({
    super.key,
    required this.opacityAnimation,
    required this.slideAnimationController,
    required this.textColor,
  });

  final Animation<double> opacityAnimation;
  final AnimationController slideAnimationController;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    final slideUpAnimation =
        Tween<Offset>(begin: const Offset(0, 0.5), end: Offset.zero).animate(
          CurvedAnimation(
            parent: slideAnimationController,
            curve: const Interval(0.6, 1.0, curve: Curves.easeOutCubic),
          ),
        );

    return Positioned(
      bottom: 100,
      left: 0,
      right: 0,
      child: FadeTransition(
        opacity: opacityAnimation,
        child: SlideTransition(
          position: slideUpAnimation,
          child: Column(
            children: [
              Text(
                AppConstants.appName,
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Connecting your documents seamlessly.',
                style: TextStyle(
                  fontSize: 14,
                  color: textColor.withValues(alpha: 0.6),
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 40),
              const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  color: AppColors.blueAccent,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
