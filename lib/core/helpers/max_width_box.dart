import 'package:flutter/widgets.dart';

/// Centers [child] and prevents it from growing wider than [maxWidth].
class MaxWidthBox extends StatelessWidget {
  const MaxWidthBox({super.key, required this.maxWidth, required this.child});

  final double maxWidth;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: child,
      ),
    );
  }
}
