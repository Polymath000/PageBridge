import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pagebridge/core/theme/app_colors.dart';
import 'package:pagebridge/config/themes/app_text_style.dart';
import 'package:pagebridge/core/utls/get_icon_depends_on_property_type.dart';
import 'package:pagebridge/feature/databases/domain/entities/property_entity.dart';
import 'package:pagebridge/feature/databases/presentation/widgets/property_type.dart';
import 'package:pagebridge/feature/databases/presentation/widgets/title_property.dart';

class PropertyWidget extends StatelessWidget {
  const PropertyWidget({super.key, required this.property, this.onChanged});
  final PropertyEntity property;
  final ValueChanged<dynamic>? onChanged;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                getIconDependsOnPropertyType(property.type),
                size: 14.sp,
                color: AppColors.grey,
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: Text(
                  property.name.toUpperCase(),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.titleMedium!.copyWith(
                    color: AppColors.grey,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.1,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: isDark ? AppColors.propertyCardDark : AppColors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                width: 1,
              ),
            ),
            child: property.type == "title"
                ? TitleProperty(onChanged: onChanged)
                : PropertyType(property: property, onChanged: onChanged),
          ),
        ],
      ),
    );
  }
}
