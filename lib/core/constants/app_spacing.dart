import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Spacing tokens. Uses `.r` so values stay consistent across orientations.
abstract final class AppSpacing {
  static double get xxs => 2.r;
  static double get xs => 4.r;
  static double get s => 8.r;
  static double get m => 12.r;
  static double get l => 16.r;
  static double get xl => 24.r;
  static double get xxl => 32.r;
}
