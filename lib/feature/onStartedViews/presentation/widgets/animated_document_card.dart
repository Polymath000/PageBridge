import 'package:flutter/material.dart';
import 'package:pagebridge/core/theme/app_colors.dart';

class AnimatedDocumentCard extends StatelessWidget {
  const AnimatedDocumentCard({
    super.key,
    required this.slideAnimation,
    required this.backgroundColor,
    required this.icon,
    required this.rotationAngle,
    required this.startOffsetX,
    required this.finalOffsetX,
  });

  final Animation<double> slideAnimation;
  final Color backgroundColor;
  final IconData? icon;
  final double rotationAngle;
  final double startOffsetX;
  final double finalOffsetX;

  @override
  Widget build(BuildContext context) {
    final borderColor = backgroundColor == AppColors.white
        ? AppColors.lightBorder
        : backgroundColor;
    final iconColor = backgroundColor == AppColors.white
        ? AppColors.black87
        : AppColors.white;

    return AnimatedBuilder(
      animation: slideAnimation,
      builder: (context, child) {
        final currentOffsetX =
            startOffsetX + (finalOffsetX - startOffsetX) * slideAnimation.value;
        final currentOpacity = slideAnimation.value.clamp(0.0, 1.0);

        return Opacity(
          opacity: currentOpacity,
          child: Transform.translate(
            offset: Offset(currentOffsetX, 0),
            child: Transform.rotate(
              angle: rotationAngle,
              child: Container(
                width: 100,
                height: 140,
                decoration: BoxDecoration(
                  color: backgroundColor,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: borderColor, width: 1),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.black.withValues(alpha: 0.1),
                      blurRadius: 20,
                      offset: const Offset(5, 10),
                    ),
                  ],
                ),
                child: Center(child: Icon(icon, size: 40, color: iconColor)),
              ),
            ),
          ),
        );
      },
    );
  }
}
