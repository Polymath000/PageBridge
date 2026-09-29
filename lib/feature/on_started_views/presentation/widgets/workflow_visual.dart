import 'package:flutter/material.dart';
import 'package:pagebridge/core/theme/app_colors.dart';
import 'package:pagebridge/feature/on_started_views/presentation/widgets/preview_database_card.dart';

class WorkflowVisual extends StatefulWidget {
  const WorkflowVisual({super.key});

  @override
  State<WorkflowVisual> createState() => _WorkflowVisualState();
}

class _WorkflowVisualState extends State<WorkflowVisual>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    // 3 second loop for the whole typing/saving sequence
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3500),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final foreground = Theme.of(context).colorScheme.onSurface;
    final fillColor = foreground.withValues(alpha: isDark ? 0.12 : 0.08);
    final borderColor = foreground.withValues(alpha: isDark ? 0.18 : 0.14);
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: fillColor,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: borderColor),
      ),
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          final time = _controller.value; // 0.0 to 1.0

          // Compute staggers
          final showCard = time > 0.05;
          final titleProgress = ((time - 0.1) / 0.15).clamp(0.0, 1.0);
          final statusProgress = ((time - 0.3) / 0.15).clamp(0.0, 1.0);
          final dueProgress = ((time - 0.5) / 0.15).clamp(0.0, 1.0);

          final showSaveButton = time > 0.7;
          final saveScale = showSaveButton ? 1.0 : 0.0;
          final buttonPulse = time > 0.75 && time < 0.9 ? 1.2 : 1.0;

          return Column(
            children: [
              AnimatedOpacity(
                duration: const Duration(milliseconds: 300),
                opacity: showCard ? 1.0 : 0.0,
                child: const PreviewDatabaseCard(
                  title: 'Ideas Database',
                  icon: '💡',
                ),
              ),
              const SizedBox(height: 14),
              _AnimatedGhostField(
                label: 'Title',
                value: 'Launch plan',
                progress: titleProgress,
                textTheme: textTheme,
              ),
              const SizedBox(height: 10),
              _AnimatedGhostField(
                label: 'Status',
                value: 'In progress',
                progress: statusProgress,
                textTheme: textTheme,
              ),
              const SizedBox(height: 10),
              _AnimatedGhostField(
                label: 'Due',
                value: 'Apr 18',
                progress: dueProgress,
                textTheme: textTheme,
              ),
              const SizedBox(height: 14),

              // The "Save" button that pops in
              AnimatedScale(
                scale: saveScale * buttonPulse,
                duration: const Duration(milliseconds: 200),
                curve: Curves.elasticOut,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: AppColors.blueAccent,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.blueAccent.withValues(alpha: 0.3),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      'Save to Notion',
                      style: textTheme.labelLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _AnimatedGhostField extends StatelessWidget {
  const _AnimatedGhostField({
    required this.label,
    required this.value,
    required this.progress,
    required this.textTheme,
  });

  final String label;
  final String value;
  final double progress;
  final TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final foreground = Theme.of(context).colorScheme.onSurface;
    final fillColor = foreground.withValues(alpha: isDark ? 0.08 : 0.06);
    final borderColor = foreground.withValues(alpha: isDark ? 0.14 : 0.12);
    final labelColor = isDark
        ? AppColors.white.withValues(alpha: 0.6)
        : AppColors.darkGrey;

    // Calculate how many characters of the value to show based on progress
    final charCount = (value.length * progress).round();
    final displayedValue = value.substring(0, charCount);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: fillColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        children: [
          Text(
            label,
            style: textTheme.labelMedium?.copyWith(color: labelColor),
          ),
          const Spacer(),
          Text(
            displayedValue,
            style: textTheme.labelLarge?.copyWith(
              color: foreground,
              fontWeight: FontWeight.w600,
            ),
          ),
          // Blinking cursor effect
          if (progress > 0.0 && progress < 1.0)
            Container(
              margin: const EdgeInsets.only(left: 2),
              width: 2,
              height: 14,
              color: AppColors.blueAccent,
            ),
        ],
      ),
    );
  }
}
