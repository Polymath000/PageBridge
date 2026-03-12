import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:quicknotion/config/themes/app_colors.dart';

class CustomAnimationBackground extends StatefulWidget {
  const CustomAnimationBackground({super.key});

  @override
  State<CustomAnimationBackground> createState() =>
      _CustomAnimationBackgroundState();
}

class _CustomAnimationBackgroundState extends State<CustomAnimationBackground>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        final t = Curves.easeInOut.transform(_controller.value);
        final wave = t * math.pi * 2;
        return Stack(
          children: [
            const Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppColors.gunmetal,
                      AppColors.spaceBlack,
                      AppColors.darkerGrey,
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              top: -120 + (18 * math.sin(wave)),
              left: -80 + (24 * math.cos(wave)),
              child: const _GlowCircle(size: 260, color: AppColors.lightBlue),
            ),
            Positioned(
              bottom: -140 + (22 * math.cos(wave)),
              right: -90 + (28 * math.sin(wave)),
              child: const _GlowCircle(size: 300, color: AppColors.topaz),
            ),
            Positioned(
              top: 120 + (16 * math.cos(wave)),
              right: -40 + (18 * math.sin(wave)),
              child: const _GlowCircle(size: 180, color: AppColors.lightCyan),
            ),
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    center: Alignment(0, -0.3 + (0.05 * t)),
                    radius: 0.9,
                    colors: const [Color(0x33FFFFFF), Color(0x00000000)],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _GlowCircle extends StatelessWidget {
  final double size;
  final Color color;

  const _GlowCircle({required this.size, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [color.withValues(alpha: 0.45), color.withValues(alpha: 0)],
        ),
      ),
    );
  }
}
