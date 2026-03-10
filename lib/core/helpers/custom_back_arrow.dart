import 'package:flutter/material.dart';

class CustomBackArrow extends StatelessWidget {
  const CustomBackArrow({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      visualDensity: VisualDensity.comfortable,
      icon: const Icon(Icons.arrow_back_ios_new, size: 20),
      onPressed: () => Navigator.pop(context),
    );
  }
}
