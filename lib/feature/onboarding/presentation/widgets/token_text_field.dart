import 'package:flutter/material.dart';
import 'package:quicknotion/config/themes/app_colors.dart';

class TokenTextField extends StatelessWidget {
  const TokenTextField({super.key});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'this field is required';
        }
        return null;
      },
      decoration: InputDecoration(
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
        labelText: 'Token',
        labelStyle: TextStyle(color: AppColors.black),
        hintText: 'e.g., wi12h3h13....',
        focusedBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(12)),
          borderSide: BorderSide(color: AppColors.darkGrey, width: 2),
        ),
      ),
    );
  }
}
