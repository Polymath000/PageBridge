import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quicknotion/config/themes/app_colors.dart';
import 'package:quicknotion/config/themes/app_text_style.dart';
import 'package:quicknotion/feature/databases/domain/entities/property_entity.dart';
import 'package:quicknotion/feature/databases/presentation/widgets/property_type.dart';

class PropertyWidget extends StatelessWidget {
  const PropertyWidget({super.key, required this.property, this.onChanged});
  final PropertyEntity property;
  final ValueChanged<dynamic>? onChanged;

  @override
  Widget build(BuildContext context) {
    return property.type == "title"
        ? TextFormField(
            onChanged: onChanged,
            maxLines: 2,
            decoration: InputDecoration(
              hintText: 'New Page',
              hintStyle: AppTextStyles.titleLarge!.copyWith(
                color: AppColors.grey,
                fontSize: 22.sp,
              ),
              border: InputBorder.none,
            ),

            style: AppTextStyles.titleLarge!.copyWith(color: AppColors.black),
          )
        : SizedBox(
            width: MediaQuery.sizeOf(context).width,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: MediaQuery.sizeOf(context).width * 0.32,
                  child: Row(
                    children: [
                      Icon(property.icon, size: 16.sp, color: AppColors.grey),
                      SizedBox(
                        width: MediaQuery.sizeOf(context).width * 0.23,
                        child: Text(
                          property.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.titleMedium!.copyWith(
                            color: const Color.fromARGB(255, 127, 128, 130),
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
          );
  }
}
