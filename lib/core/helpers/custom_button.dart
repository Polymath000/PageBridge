import 'package:flutter/material.dart';
import 'package:quicknotion/config/themes/app_colors.dart';
import 'package:quicknotion/config/themes/app_text_style.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 32.0),
      child: ElevatedButton(
        style: ButtonStyle(
          padding: WidgetStatePropertyAll(
            EdgeInsets.symmetric(
              vertical: 12,
              horizontal: MediaQuery.sizeOf(context).width * 0.15,
            ),
          ),
          side: WidgetStatePropertyAll(
            BorderSide(color: AppColors.lightBlue, width: 1),
          ),
          elevation: WidgetStatePropertyAll(2),
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          backgroundColor: WidgetStateProperty.fromMap(
            <WidgetStatesConstraint, Color?>{
              WidgetState.pressed: AppColors.lightBlue,
              WidgetState.hovered: Colors.lightBlue,
              WidgetState.disabled: Colors.grey,
              WidgetState.any: AppColors.darkBlue,
            },
          ),
        ),
        onPressed: () {},
        child: Text(
          'Create New Page',
          style: AppTextStyles.titleMedium!.copyWith(
            color: AppColors.white,
          ),
        ),
      ),
    );
  }
}
