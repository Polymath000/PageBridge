import 'package:flutter/material.dart';
import 'package:pagebridge/config/themes/app_text_style.dart';
import 'package:pagebridge/config/themes/theme_config.dart';

/// A friendly empty-state widget distinct from error states.
///
/// Displays an icon, a title, and an optional subtitle to guide
/// the user when a list has no items.
class CustomEmptyState extends StatelessWidget {
  const CustomEmptyState({
    super.key,
    required this.title,
    this.subtitle,
    this.icon = Icons.inbox_outlined,
  });

  final String title;
  final String? subtitle;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final modernSlate = Theme.of(context).extension<ModernSlateColors>()!;
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 48),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 56, color: modernSlate.secondaryText),
            const SizedBox(height: 16),
            Text(
              title,
              textAlign: TextAlign.center,
              style: AppTextStyles.titleLarge?.copyWith(
                color: modernSlate.primaryText,
                fontWeight: FontWeight.w600,
              ),
            ),
            if (subtitle != null) ...[
              const SizedBox(height: 8),
              Text(
                subtitle!,
                textAlign: TextAlign.center,
                style: AppTextStyles.titleMedium?.copyWith(
                  color: modernSlate.secondaryText,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
