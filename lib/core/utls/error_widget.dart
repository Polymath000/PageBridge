import 'package:flutter/material.dart';
import 'package:pagebridge/config/themes/app_colors.dart';
import 'package:pagebridge/config/themes/app_text_style.dart';
import 'package:pagebridge/config/themes/app_icons.dart';

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

class CustomErrorWidgetRelationType extends StatelessWidget {
  const CustomErrorWidgetRelationType({super.key, required this.errorMessage});
  final String errorMessage;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 13.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 30,
            width: MediaQuery.sizeOf(context).width * 0.55,
            child: Text(
              errorMessage,
              maxLines: 1,
              overflow: TextOverflow.visible,
              textAlign: TextAlign.start,
              style: AppTextStyles.titleLarge!.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.lightRed,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
