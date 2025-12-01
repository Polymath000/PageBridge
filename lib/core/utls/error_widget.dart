import 'package:flutter/material.dart';
import 'package:quicknotion/config/themes/app_colors.dart';
import 'package:quicknotion/config/themes/app_text_style.dart';
import 'package:quicknotion/core/utls/app_icons.dart';

class CustomErrorWidget extends StatelessWidget {
  const CustomErrorWidget({super.key, required this.errorMessage});
  final String errorMessage;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.sizeOf(context).height,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: [
            Spacer(flex: 1),
            Icon(AppIcons.errorIcon, color: AppColors.red, size: 32),
            SizedBox(height: 16),
            Text(
              errorMessage,
              textAlign: TextAlign.center,
              style: AppTextStyles.titleLarge!.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.lightRed,
              ),
            ),
            Spacer(flex: 2),
          ],
        ),
      ),
    );
  }
}
