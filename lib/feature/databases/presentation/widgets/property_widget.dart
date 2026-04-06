import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pagebridge/config/themes/app_colors.dart';
import 'package:pagebridge/config/themes/app_text_style.dart';
import 'package:pagebridge/core/helpers/custom_back_arrow.dart';
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
    if (property.type == "title") {
      return SizedBox(
        width: MediaQuery.sizeOf(context).width,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CustomBackArrow(),
            Expanded(child: TitleProperty(onChanged: onChanged)),
          ],
        ),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.only(left: 20.0),
        child: SizedBox(
          width: MediaQuery.sizeOf(context).width,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: MediaQuery.sizeOf(context).width * 0.32,
                child: Row(
                  children: [
                    Icon(
                      getIconDependsOnPropertyType(property.type),
                      size: 16.sp,
                      color: AppColors.grey,
                    ),
                    SizedBox(width: 8),
                    SizedBox(
                      width: MediaQuery.sizeOf(context).width * 0.23,
                      child: Text(
                        property.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.titleMedium!.copyWith(
                          color: AppColors.grey,
                          fontSize: 16.sp,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              PropertyType(property: property, onChanged: onChanged),
            ],
          ),
        ),
      );
    }
  }
}
