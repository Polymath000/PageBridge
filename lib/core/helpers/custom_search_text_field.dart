import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pagebridge/config/themes/theme_config.dart';

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
  Timer? _debounce;

  static const _debounceDuration = Duration(milliseconds: 400);

  void _onSearchChanged(String value) {
    _debounce?.cancel();
    _debounce = Timer(_debounceDuration, () {
      widget.getPages?.call(value);
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
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
          onChanged: _onSearchChanged,
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
                      _debounce?.cancel();
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

