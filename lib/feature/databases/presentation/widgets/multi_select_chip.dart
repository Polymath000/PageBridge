import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pagebridge/core/theme/app_colors.dart';
import 'package:pagebridge/core/utls/get_color.dart';
import 'package:pagebridge/feature/databases/domain/entities/property_entity.dart';

class MultiSelectChip extends StatelessWidget {
  const MultiSelectChip({super.key, required this.option});

  final SelectOptionEntity? option;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: option != null ? getColor(option!.color) : AppColors.grey300,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        option?.name ?? "Unknown",
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
          color: AppColors.white, // White looks best on colored chips
          fontSize: 14.sp,
        ),
      ),
    );
  }
}
