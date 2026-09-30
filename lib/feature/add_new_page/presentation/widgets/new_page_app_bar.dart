import 'package:flutter/material.dart';
import 'package:pagebridge/core/helpers/custom_back_arrow.dart';
import 'package:pagebridge/core/theme/app_colors.dart';

PreferredSizeWidget newPageAppBar({
  required BuildContext context,
  required String title,
}) {
  return AppBar(
    backgroundColor: AppColors.transparent,
    elevation: 0,
    leading: const Padding(
      padding: EdgeInsets.all(8.0),
      child: CustomBackArrow(),
    ),
    title: Text(
      title.toUpperCase(),
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        letterSpacing: 1.2,
      ).copyWith(color: Theme.of(context).colorScheme.onSurface),
    ),
  );
}
