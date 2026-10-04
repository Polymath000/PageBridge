import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pagebridge/core/responsive/window_size.dart';

extension ResponsiveContext on BuildContext {
  WindowSize get windowSize =>
      WindowSize.fromWidth(MediaQuery.sizeOf(this).width);

  bool get isCompact => windowSize.isCompact;

  double get screenPadding => windowSize.screenPadding.r;
}
