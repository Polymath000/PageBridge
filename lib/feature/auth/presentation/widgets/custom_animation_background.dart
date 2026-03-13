import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:quicknotion/config/themes/app_colors.dart';

class CustomAnimationBackground extends StatefulWidget {
  final BackgroundMode mode;

  const CustomAnimationBackground({super.key})
      : mode = BackgroundMode.adaptive;

  const CustomAnimationBackground.light({super.key})
      : mode = BackgroundMode.light;

  const CustomAnimationBackground.dark({super.key}) : mode = BackgroundMode.dark;

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
    final palette = switch (widget.mode) {
      BackgroundMode.light => _BackgroundPalette.light,
      BackgroundMode.dark => _BackgroundPalette.dark,
      BackgroundMode.adaptive =>
        Theme.of(context).brightness == Brightness.dark
            ? _BackgroundPalette.dark
            : _BackgroundPalette.light,
    };
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        final t = Curves.easeInOut.transform(_controller.value);
        final wave = t * math.pi * 2;
        return Stack(
          children: [
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: palette.backgroundGradient,
                  ),
                ),
              ),
            ),
            Positioned(
              top: -120 + (18 * math.sin(wave)),
              left: -80 + (24 * math.cos(wave)),
              child: _GlowCircle(size: 260, color: palette.glowOne),
            ),
            Positioned(
              bottom: -140 + (22 * math.cos(wave)),
              right: -90 + (28 * math.sin(wave)),
              child: _GlowCircle(size: 300, color: palette.glowTwo),
            ),
            Positioned(
              top: 120 + (16 * math.cos(wave)),
              right: -40 + (18 * math.sin(wave)),
              child: _GlowCircle(size: 180, color: palette.glowThree),
            ),
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    center: Alignment(0, -0.3 + (0.05 * t)),
                    radius: 0.9,
                    colors: palette.overlayGradient,
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

enum BackgroundMode { dark, light, adaptive }

class _BackgroundPalette {
  final List<Color> backgroundGradient;
  final List<Color> overlayGradient;
  final Color glowOne;
  final Color glowTwo;
  final Color glowThree;

  const _BackgroundPalette({
    required this.backgroundGradient,
    required this.overlayGradient,
    required this.glowOne,
    required this.glowTwo,
    required this.glowThree,
  });

  static const _BackgroundPalette dark = _BackgroundPalette(
    backgroundGradient: [
      AppColors.gunmetal,
      AppColors.spaceBlack,
      AppColors.darkerGrey,
    ],
    overlayGradient: [Color(0x33FFFFFF), Color(0x00000000)],
    glowOne: AppColors.lightBlue,
    glowTwo: AppColors.topaz,
    glowThree: AppColors.lightCyan,
  );

  static const _BackgroundPalette light = _BackgroundPalette(
    backgroundGradient: [
      AppColors.lightSurface,
      AppColors.lightGray,
      AppColors.mediumGray,
    ],
    overlayGradient: [Color(0x14000000), Color(0x00000000)],
    glowOne: AppColors.lightBlue,
    glowTwo: AppColors.topaz,
    glowThree: AppColors.lightCyan,
  );
}
