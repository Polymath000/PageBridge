import 'package:pagebridge/core/constants/breakpoints.dart';

/// Material 3 window size classes, resolved from the available width.
enum WindowSize {
  compact(columns: 1, contentMaxWidth: double.infinity, screenPadding: 12),
  medium(columns: 2, contentMaxWidth: 960, screenPadding: 24),
  expanded(columns: 3, contentMaxWidth: 1240, screenPadding: 32);

  const WindowSize({
    required this.columns,
    required this.contentMaxWidth,
    required this.screenPadding,
  });

  final int columns;
  final double contentMaxWidth;
  final double screenPadding;

  static WindowSize fromWidth(double width) => switch (width) {
    < AppBreakpoints.medium => compact,
    < AppBreakpoints.expanded => medium,
    _ => expanded,
  };

  bool get isCompact => this == compact;
}
