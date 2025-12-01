import 'package:flutter/material.dart';
import 'package:quicknotion/config/themes/app_colors.dart';
import 'package:quicknotion/config/themes/app_text_style.dart';
import 'package:quicknotion/feature/databases/domain/entities/database_entity.dart';

class PropertyWidget extends StatelessWidget {
  const PropertyWidget({super.key, required this.property});
  final PropertyEntity property;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(property.icon, size: 16),
        SizedBox(width: 6),
        SizedBox(
          width: MediaQuery.sizeOf(context).width * 0.25,
          child: Text(
            property.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.titleMedium!.copyWith(color: AppColors.black),
          ),
        ),
        SizedBox(width: 6),
        SizedBox(
          width: MediaQuery.sizeOf(context).width * 0.5,
          child: TextField(
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: "Empty",
              hintStyle: AppTextStyles.titleMedium!.copyWith(
                color: AppColors.grey,
              ),
            ),
            maxLines: 1,
            style: AppTextStyles.titleMedium!.copyWith(
              color: AppColors.darkGrey,
            ),
          ),
        ),
      ],
    );
  }
}
