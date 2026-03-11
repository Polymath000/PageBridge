import 'package:flutter/material.dart';
import 'package:quicknotion/config/themes/app_colors.dart';

class TokenTextField extends StatefulWidget {
  const TokenTextField({super.key, required this.onChanged});
  final void Function(String)? onChanged;

  @override
  State<TokenTextField> createState() => _TokenTextFieldState();
}

class _TokenTextFieldState extends State<TokenTextField> {
  bool isSecure = true;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: isSecure,
      obscuringCharacter: "*",
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'this field is required';
        }
        return null;
      },
      onChanged: widget.onChanged,
      decoration: InputDecoration(
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
        labelText: 'Token',
        labelStyle: TextStyle(
          color: Theme.of(context).brightness == Brightness.light
              ? AppColors.black
              : AppColors.white,
        ),
        hintText: 'e.g., wi12h3h13....',
        focusedBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(12)),
          borderSide: BorderSide(color: AppColors.darkGrey, width: 2),
        ),
        suffixIcon: IconButton(
          icon: Icon(isSecure ? Icons.visibility_off : Icons.visibility),
          onPressed: () {
            setState(() {
              isSecure = !isSecure;
            });
          },
        ),
      ),
    );
  }
}
