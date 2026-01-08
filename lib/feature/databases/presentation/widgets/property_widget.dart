import 'package:flutter/material.dart';
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
    return SizedBox(
      width: MediaQuery.sizeOf(context).width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            width: MediaQuery.sizeOf(context).width * 0.32,
            child: Row(
              children: [
                Icon(property.icon, size: 16, color: AppColors.grey),
                SizedBox(width: 8),
                SizedBox(
                  width: MediaQuery.sizeOf(context).width * 0.23,
                  child: Text(
                    property.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.titleMedium!.copyWith(
                      color: const Color.fromARGB(255, 127, 128, 130),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 8),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: PropertyType(property: property, onChanged: onChanged),
          ),
        ],
      ),
    );
  }
}
