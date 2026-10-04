import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';

class AppRefreshIndicator extends StatelessWidget {
  const AppRefreshIndicator({
    super.key,
    required this.onRefresh,
    required this.child,
    this.edgeOffset = 0,
  });

  final Future<void> Function() onRefresh;
  final Widget child;
  final double edgeOffset;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return CustomMaterialIndicator(
      onRefresh: onRefresh,
      edgeOffset: edgeOffset,
      backgroundColor: colorScheme.surface,
      indicatorBuilder: (context, controller) {
        return _GlassSpinner(controller: controller, colorScheme: colorScheme);
      },
      child: child,
    );
  }
}

class _GlassSpinner extends StatelessWidget {
  const _GlassSpinner({required this.controller, required this.colorScheme});

  final IndicatorController controller;
  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: Container(
          decoration: BoxDecoration(
            color: colorScheme.surface.withValues(alpha: 0.4),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: colorScheme.outlineVariant.withValues(alpha: 0.2),
            ),
          ),
          padding: const EdgeInsets.all(6),
          child: CircularProgressIndicator(
            color: colorScheme.primary,
            strokeWidth: 2.5,
            value: controller.state.isLoading
                ? null
                : math.min(controller.value, 1.0),
          ),
        ),
      ),
    );
  }
}
