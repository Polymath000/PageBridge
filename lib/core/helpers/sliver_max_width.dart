import 'dart:math';

import 'package:flutter/widgets.dart';

/// Keeps a sliver's content centered and no wider than [maxWidth],
/// while preserving lazy building of the wrapped [sliver].
class SliverMaxWidth extends StatelessWidget {
  const SliverMaxWidth({
    super.key,
    required this.maxWidth,
    required this.sliver,
    this.padding = EdgeInsets.zero,
  });

  final double maxWidth;
  final Widget sliver;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return SliverLayoutBuilder(
      builder: (context, constraints) {
        final extra = max(0.0, (constraints.crossAxisExtent - maxWidth) / 2);
        return SliverPadding(
          padding: padding + EdgeInsets.symmetric(horizontal: extra),
          sliver: sliver,
        );
      },
    );
  }
}
