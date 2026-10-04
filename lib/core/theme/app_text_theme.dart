import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Material 3 type scale expressed in `.sp`, shared by light and dark themes.
abstract final class AppTextTheme {
  static TextTheme build(Color color) => TextTheme(
    displayLarge: _style(57, color),
    displayMedium: _style(45, color),
    displaySmall: _style(36, color),
    headlineLarge: _style(32, color),
    headlineMedium: _style(28, color),
    headlineSmall: _style(24, color),
    titleLarge: _style(22, color),
    titleMedium: _style(16, color, FontWeight.w500),
    titleSmall: _style(14, color, FontWeight.w500),
    bodyLarge: _style(16, color),
    bodyMedium: _style(14, color),
    bodySmall: _style(12, color),
    labelLarge: _style(14, color, FontWeight.w500),
    labelMedium: _style(12, color, FontWeight.w500),
    labelSmall: _style(11, color, FontWeight.w500),
  );

  static TextStyle _style(double size, Color color, [FontWeight? weight]) =>
      TextStyle(fontSize: size.sp, color: color, fontWeight: weight);
}
