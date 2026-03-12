import 'package:flutter/material.dart';
import 'package:quicknotion/config/themes/app_colors.dart';

class BackgroundAuth extends StatelessWidget {
  const BackgroundAuth({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: ColoredBox(color: AppColors.amber),
    );
  }
}
