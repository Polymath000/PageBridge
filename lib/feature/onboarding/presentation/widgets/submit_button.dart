import 'package:flutter/material.dart';
import 'package:quicknotion/config/themes/app_colors.dart';
import 'package:quicknotion/config/themes/app_text_style.dart';
import 'package:quicknotion/core/constants/borders.dart';

class SubmitButton extends StatefulWidget {
  SubmitButton({
    super.key,
    required this.formKey,
    required this.autovalidateMode,
  });
  GlobalKey<FormState> formKey;
  AutovalidateMode autovalidateMode;
  @override
  State<SubmitButton> createState() => _SubmitButtonState();
}

class _SubmitButtonState extends State<SubmitButton> {
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: ElevatedButton(
        onPressed: () {
          if (widget.formKey.currentState!.validate()) {
            widget.formKey.currentState!.save();
            widget.autovalidateMode = AutovalidateMode.disabled;
          } else {
            setState(() {
              widget.autovalidateMode = AutovalidateMode.always;
            });
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.green,
          foregroundColor: AppColors.darkGrey,
          padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: AppBorders.xxxs),
          textStyle: AppTextStyles.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        child: const Text('Submit'),
      ),
    );
  }
}
