import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TitleProperty extends StatelessWidget {
  const TitleProperty({super.key, required this.onChanged});

  final ValueChanged<dynamic>? onChanged;

  @override
  Widget build(BuildContext context) {
    final textColor = Theme.of(context).colorScheme.onSurface;

    return TextField(
      onChanged: onChanged,
      maxLines: 2,
      decoration: InputDecoration(
        hintText: 'New Page',
        labelStyle: Theme.of(context).textTheme.titleLarge!.copyWith(
          color: textColor,
          fontSize: 22.sp,
        ),
        hintStyle: Theme.of(context).textTheme.titleLarge!.copyWith(
          color: textColor,
          fontSize: 22.sp,
        ),
        border: InputBorder.none,
      ),
      style: Theme.of(context).textTheme.titleLarge!.copyWith(
        color: textColor,
        fontSize: 22.sp,
      ),
    );
  }
}
