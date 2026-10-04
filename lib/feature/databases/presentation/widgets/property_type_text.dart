import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PropertyTypeText extends StatelessWidget {
  const PropertyTypeText({super.key, this.onChanged});
  final ValueChanged<dynamic>? onChanged;

  @override
  Widget build(BuildContext context) {
    return TextField(
      maxLines: 1,
      enabled: true,
      onChanged: onChanged,
      decoration: InputDecoration(
        border: InputBorder.none,
        hintText: "Empty",
        hintStyle: Theme.of(context).textTheme.titleMedium?.copyWith(
          color: Theme.of(context).colorScheme.onSurfaceVariant,
          fontSize: 16.sp,
        ),
      ),
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
        color: Theme.of(context).colorScheme.onSurface,
        fontSize: 16.sp,
      ),
    );
  }
}
