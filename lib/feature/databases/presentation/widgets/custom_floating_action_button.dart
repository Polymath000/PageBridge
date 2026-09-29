import 'package:flutter/material.dart';
import 'package:pagebridge/config/themes/app_icons.dart';
import 'package:pagebridge/core/theme/app_colors.dart';

class CustomFloatingActionButton extends StatelessWidget {
  const CustomFloatingActionButton({
    super.key,
    required this.onPressed,
  });

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 70.0),
      child: FloatingActionButton(
        onPressed: onPressed,
        backgroundColor: AppColors.darkGrey,
        foregroundColor: AppColors.topaz,
        tooltip: 'scroll up',
        child: Icon(AppIcons.arrowUp),
      ),
    );
  }
}
