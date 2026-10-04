import 'package:flutter/widgets.dart';
import 'package:pagebridge/core/responsive/window_size.dart';

/// Builds a different layout per window size, based on local constraints.
class ResponsiveLayout extends StatelessWidget {
  const ResponsiveLayout({
    super.key,
    required this.compact,
    this.medium,
    this.expanded,
  });

  final WidgetBuilder compact;
  final WidgetBuilder? medium;
  final WidgetBuilder? expanded;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final builder = switch (WindowSize.fromWidth(constraints.maxWidth)) {
          WindowSize.compact => compact,
          WindowSize.medium => medium ?? compact,
          WindowSize.expanded => expanded ?? medium ?? compact,
        };
        return builder(context);
      },
    );
  }
}
