import 'package:flutter/material.dart';
import 'package:quicknotion/config/themes/app_colors.dart';
import 'package:quicknotion/config/themes/app_text_style.dart';
import 'package:quicknotion/feature/databases/domain/entities/database_entity.dart';
import 'package:quicknotion/feature/databases/presentation/widgets/property_widget.dart';

class NewPageViewBody extends StatelessWidget {
  const NewPageViewBody({super.key, required this.database});
  final DatabaseEntity database;
  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        children: [
          TextFormField(
            maxLines: 2,
            decoration: InputDecoration(
              hintText: 'New Page',
              hintStyle: AppTextStyles.titleLarge!.copyWith(
                color: AppColors.grey,
              ),
              border: InputBorder.none,
            ),
            style: AppTextStyles.titleLarge!.copyWith(color: AppColors.black),
          ),
          ...List.generate(
            database.properties.length,
            (index) => PropertyWidget(property: database.properties[index]),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 32.0),
            child: ElevatedButton(
              style: ButtonStyle(
                padding: WidgetStatePropertyAll(
                  EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: MediaQuery.sizeOf(context).width * 0.15,
                  ),
                ),
                side: WidgetStatePropertyAll(
                  BorderSide(color: AppColors.lightBlue, width: 1),
                ),
                elevation: WidgetStatePropertyAll(2),
                shape: WidgetStatePropertyAll(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                backgroundColor: WidgetStateProperty.fromMap(
                  <WidgetStatesConstraint, Color?>{
                    WidgetState.pressed: AppColors.lightBlue,
                    WidgetState.hovered: Colors.lightBlue,
                    WidgetState.disabled: Colors.grey,
                    WidgetState.any: AppColors.darkBlue,
                  },
                ),
              ),
              onPressed: () {},
              child: Text(
                'Create New Page',
                style: AppTextStyles.titleMedium!.copyWith(
                  color: AppColors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
