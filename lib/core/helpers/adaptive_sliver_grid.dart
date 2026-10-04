import 'package:flutter/widgets.dart';
import 'package:pagebridge/core/responsive/window_size.dart';

/// Lazily lays items out in rows of 1/2/3 cells based on the width actually
/// available to the sliver (so a navigation rail is taken into account).
///
/// Cells keep their intrinsic height, so cards never overflow when the
/// user enlarges the system font (unlike a fixed `mainAxisExtent` grid).
class AdaptiveSliverGrid extends StatelessWidget {
  const AdaptiveSliverGrid({
    super.key,
    required this.itemCount,
    required this.itemBuilder,
    this.spacing = 8,
  });

  final int itemCount;
  final IndexedWidgetBuilder itemBuilder;
  final double spacing;

  @override
  Widget build(BuildContext context) {
    return SliverLayoutBuilder(
      builder: (context, constraints) {
        final columns = WindowSize.fromWidth(
          constraints.crossAxisExtent,
        ).columns;
        return SliverList.builder(
          itemCount: (itemCount / columns).ceil(),
          itemBuilder: (context, row) => columns == 1
              ? itemBuilder(context, row)
              : _buildRow(context, row, columns),
        );
      },
    );
  }

  Widget _buildRow(BuildContext context, int row, int columns) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: spacing,
      children: List.generate(columns, (column) {
        final index = row * columns + column;
        return Expanded(
          child: index < itemCount
              ? itemBuilder(context, index)
              : const SizedBox.shrink(),
        );
      }),
    );
  }
}
