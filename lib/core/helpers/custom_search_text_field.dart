import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quicknotion/config/themes/app_colors.dart';
import 'package:quicknotion/config/themes/theme_config.dart';

class CustomSearchTextField extends StatefulWidget {
  const CustomSearchTextField({
    super.key,
    required this.getPages,
    required this.hintText,
  });

  final void Function(String)? getPages;
  final String hintText;

  @override
  State<CustomSearchTextField> createState() => _CustomSearchTextFieldState();
}

class _CustomSearchTextFieldState extends State<CustomSearchTextField> {
  final TextEditingController searchController = TextEditingController();

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final modernSlate = theme.extension<ModernSlateColors>()!;

    final Color fillColor = modernSlate.searchBarFill;
    final Color iconColor = modernSlate.secondaryText;
    final Color textColor = modernSlate.primaryText;

    return ValueListenableBuilder<TextEditingValue>(
      valueListenable: searchController,
      builder: (context, value, child) {
        return TextField(
          controller: searchController,
          onChanged: (value) {
            widget.getPages?.call(value);
          },
          style: TextStyle(color: textColor, fontSize: 16.sp),
          decoration: InputDecoration(
            hintText: widget.hintText,
            hintStyle: TextStyle(color: iconColor),
            filled: true,
            fillColor: fillColor,
            prefixIcon: Icon(Icons.search, color: iconColor),
            suffixIcon: value.text.isNotEmpty
                ? IconButton(
                    icon: Icon(Icons.clear, color: iconColor),
                    onPressed: () {
                      searchController.clear();
                      widget.getPages?.call('');
                    },
                  )
                : null,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide(
                color: modernSlate.border,
                width: 0.9,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide(
                color: theme.colorScheme.primary,
                width: 1.5,
              ),
            ),
            contentPadding: EdgeInsets.symmetric(
              vertical: 14.h,
              horizontal: 16.w,
            ),
          ),
        );
      },
    );
  }
}
