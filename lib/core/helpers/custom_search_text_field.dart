import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quicknotion/config/themes/app_colors.dart';

class CustomSearchTextField extends StatefulWidget {
  const CustomSearchTextField({
    super.key,
    required this.searchController,
    required this.getPages,
    required this.hintText,
  });

  final TextEditingController searchController;
  final Future<void> Function() getPages;
  final String hintText;

  @override
  State<CustomSearchTextField> createState() => _CustomSearchTextFieldState();
}

class _CustomSearchTextFieldState extends State<CustomSearchTextField> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final Color fillColor = isDark
        ? AppColors.white.withOpacity(0.05)
        : AppColors.lightGray;

    final Color iconColor = isDark ? AppColors.grey : AppColors.darkGrey;
    final Color textColor = isDark ? AppColors.white : AppColors.black;

    return ValueListenableBuilder<TextEditingValue>(
      valueListenable: widget.searchController,
      builder: (context, value, child) {
        return TextField(
          controller: widget.searchController,
          onChanged: (value) => widget.getPages(),
          style: TextStyle(color: textColor, fontSize: 16.sp),
          decoration: InputDecoration(
            hintText: widget.hintText,
            hintStyle: TextStyle(color: iconColor.withOpacity(0.7)),
            filled: true,
            fillColor: fillColor,
            prefixIcon: Icon(Icons.search, color: iconColor),
            suffixIcon: value.text.isNotEmpty
                ? IconButton(
                    icon: Icon(Icons.clear, color: iconColor),
                    onPressed: () {
                      widget.searchController.clear();
                      widget.getPages();
                    },
                  )
                : null,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide(
                color: isDark
                    ? AppColors.white.withValues(alpha: 0.4)
                    : AppColors.black.withValues(alpha: 0.4),
                width: 0.9,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide(
                color: isDark
                    ? AppColors.blue.withValues(alpha: 0.3)
                    : AppColors.blue.withValues(alpha: 0.6),
                width: 1.5,
              ),
            ),
            contentPadding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 16.w),
          ),
        );
      },
    );
  }
}
