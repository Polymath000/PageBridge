import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quicknotion/config/themes/app_colors.dart';
import 'package:quicknotion/config/themes/app_text_style.dart';
import 'package:quicknotion/core/constants/borders.dart';
import 'package:quicknotion/feature/databases/presentation/controllers/add_token_cubit/add_token_cubit.dart';

class SubmitButton extends StatefulWidget {
  SubmitButton({
    super.key,
    required this.formKey,
    required this.autovalidateMode,
    required this.token,
  });
  String token;
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
            BlocProvider.of<AddTokenCubit>(
              context,
            ).addToken(token: widget.token);
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
