import 'package:flutter/material.dart';
import 'package:quicknotion/config/themes/app_colors.dart';

class CustomCheckBox extends StatefulWidget {
  const CustomCheckBox({super.key, this.onChanged, this.value});
  final ValueChanged<dynamic>? onChanged;
  final bool? value;
  @override
  State<CustomCheckBox> createState() => _CustomCheckBoxState();
}

class _CustomCheckBoxState extends State<CustomCheckBox> {
  bool isButtonPressed = false;

  @override
  void initState() {
    super.initState();
    isButtonPressed = widget.value ?? false;
  }

  @override
  void didUpdateWidget(covariant CustomCheckBox oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != null && widget.value != oldWidget.value) {
      isButtonPressed = widget.value!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14.0),
      child: Align(
        alignment: Alignment.centerLeft,
        child: GestureDetector(
          onTap: () {
            setState(() {
              isButtonPressed = !isButtonPressed;
            });
            widget.onChanged?.call(isButtonPressed);
          },
          child: Icon(
            isButtonPressed ? Icons.check_box : Icons.check_box_outline_blank,
            color: isButtonPressed ? AppColors.darkBlue : AppColors.grey,
            size: 24,
            fontWeight: FontWeight.w100,
            weight: 1,
          ),
        ),
      ),
    );
  }
}
