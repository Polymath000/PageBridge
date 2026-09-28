import 'package:flutter/material.dart';
import 'package:pagebridge/config/themes/app_icons.dart';

class CustomBackArrow extends StatelessWidget {
  const CustomBackArrow({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      visualDensity: VisualDensity.comfortable,
      icon: Icon(AppIcons.arrowBack, size: 20),
      onPressed: () => Navigator.pop(context),
    );
  }
}
