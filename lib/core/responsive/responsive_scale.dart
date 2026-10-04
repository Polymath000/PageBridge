import 'dart:math';
import 'dart:ui' show Size;

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pagebridge/core/constants/breakpoints.dart';

/// Picks a ScreenUtil design size per device class and orientation so the
/// scale factor stays close to 1 on phones and tablets alike.
abstract final class ResponsiveScale {
  static const Size phoneDesign = Size(360, 690);
  static const Size tabletDesign = Size(768, 1024);
  static const double minFontScale = 0.9;
  static const double maxFontScale = 1.2;

  static Size designSizeFor(Size screen) {
    final isTablet = screen.shortestSide >= AppBreakpoints.medium;
    final base = isTablet ? tabletDesign : phoneDesign;
    final isLandscape = screen.width > screen.height;
    return isLandscape ? base.flipped : base;
  }

  static double clampFontScale(double scale) =>
      scale.clamp(minFontScale, maxFontScale);

  static double fontResolver(num fontSize, ScreenUtil util) =>
      fontSize * clampFontScale(min(util.scaleWidth, util.scaleHeight));
}
