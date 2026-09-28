import 'dart:async';
import 'dart:ui';
import 'package:pagebridge/config/themes/app_icons.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


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
    final colorScheme = theme.colorScheme;

    final Color iconColor = colorScheme.onSurfaceVariant.withValues(alpha: 0.6);
    final Color textColor = colorScheme.onSurface;

    return ValueListenableBuilder<TextEditingValue>(
      valueListenable: searchController,
      builder: (context, value, child) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(28.r),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
            child: Container(
              decoration: BoxDecoration(
                color: colorScheme.surface.withValues(alpha: 0.45),
                borderRadius: BorderRadius.circular(28.r),
                border: Border.all(
                  color: colorScheme.outlineVariant.withValues(alpha: 0.25),
                  width: 0.5,
                ),
              ),
              child: TextField(
                controller: searchController,
                onChanged: _onSearchChanged,
                style: TextStyle(color: textColor, fontSize: 15.sp),
                decoration: InputDecoration(
                  hintText: widget.hintText,
                  hintStyle: TextStyle(
                    color: iconColor,
                    fontWeight: FontWeight.w400,
                    fontSize: 14.sp,
                  ),
                  filled: false,
                  prefixIcon: Padding(
                    padding: const EdgeInsets.only(left: 14, right: 8),
                    child: Icon(AppIcons.materialSearch, color: iconColor, size: 20),
                  ),
                  prefixIconConstraints: const BoxConstraints(
                    minWidth: 40,
                    minHeight: 40,
                  ),
                  suffixIcon: value.text.isNotEmpty
                      ? IconButton(
                          icon: Icon(AppIcons.clear, color: iconColor, size: 18),
                          onPressed: () {
                            searchController.clear();
                            _debounce?.cancel();
                            widget.getPages?.call('');
                          },
                        )
                      : null,
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                    vertical: 14.h,
                    horizontal: 4.w,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
