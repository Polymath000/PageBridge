import 'package:flutter/material.dart';

import 'package:pagebridge/config/themes/app_colors.dart';
import 'package:pagebridge/config/themes/app_text_style.dart';

Future<bool> showAppConfirmDialog({
  required final BuildContext context,
  required final String title,
  required final String message,
  final String confirmText = 'Yes',
  final String cancelText = 'No',
}) async {
  final bool? result = await showDialog<bool>(
    context: context,
    barrierDismissible: false,
    builder: (_) {
      return AppConfirmDialog(
        title: title,
        message: message,
        confirmText: confirmText,
        cancelText: cancelText,
      );
    },
  );

  return result ?? false;
}

class AppConfirmDialog extends StatelessWidget {
  final String title;
  final String message;
  final String confirmText;
  final String cancelText;

  const AppConfirmDialog({
    super.key,
    required this.title,
    required this.message,
    required this.confirmText,
    required this.cancelText,
  });

  @override
  Widget build(BuildContext context) {
    final TextStyle titleStyle =
        (AppTextStyles.titleMedium ?? const TextStyle()).copyWith(
      color: AppColors.onSurface,
      fontWeight: FontWeight.w600,
    );
    final TextStyle messageStyle =
        (AppTextStyles.bodyMedium ?? const TextStyle()).copyWith(
      color: AppColors.onSurfaceVariant,
    );

    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 24),
      backgroundColor: AppColors.surfaceContainerHigh,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(title, style: titleStyle, textAlign: TextAlign.center),
            const SizedBox(height: 10),
            Text(message, style: messageStyle, textAlign: TextAlign.center),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.onSurface,
                      side: BorderSide(color: AppColors.outline),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(cancelText),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: FilledButton(
                    onPressed: () => Navigator.of(context).pop(true),
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: AppColors.onPrimary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(confirmText),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
