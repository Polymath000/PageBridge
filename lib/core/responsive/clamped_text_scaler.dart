import 'package:flutter/widgets.dart';

/// Respects the OS text size setting but bounds it so layouts stay intact.
class ClampedTextScaler extends StatelessWidget {
  const ClampedTextScaler({super.key, required this.child});

  final Widget child;
  static const double minScale = 0.85;
  static const double maxScale = 1.3;

  @override
  Widget build(BuildContext context) {
    return MediaQuery.withClampedTextScaling(
      minScaleFactor: minScale,
      maxScaleFactor: maxScale,
      child: child,
    );
  }
}
