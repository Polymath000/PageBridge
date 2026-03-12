import 'package:flutter/material.dart';
import 'package:quicknotion/config/themes/app_colors.dart';
import 'package:quicknotion/feature/onStartedViews/presentation/widgets/preview_database_card.dart';
import 'package:quicknotion/feature/onStartedViews/presentation/widgets/preview_field.dart';

class WorkflowVisual extends StatelessWidget {
  const WorkflowVisual({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.white.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppColors.white.withValues(alpha: 0.18)),
      ),
      child: Column(
        children: [
          PreviewDatabaseCard(title: 'Ideas Database', icon: '💡'),
          const SizedBox(height: 14),
          PreviewField(
            label: 'Title',
            value: 'Launch plan',
            textTheme: textTheme,
          ),
          const SizedBox(height: 10),
          PreviewField(
            label: 'Status',
            value: 'In progress',
            textTheme: textTheme,
          ),
          const SizedBox(height: 10),
          PreviewField(label: 'Due', value: 'Apr 18', textTheme: textTheme),
        ],
      ),
    );
  }
}
