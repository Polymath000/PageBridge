import 'package:flutter/material.dart';
import 'package:quicknotion/config/themes/app_colors.dart';
import 'package:quicknotion/config/themes/app_text_style.dart';
import 'package:quicknotion/core/helpers/custom_button.dart';
import 'package:quicknotion/core/utls/app_icons.dart';
import 'package:quicknotion/feature/databases/domain/entities/database_entity.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quicknotion/feature/databases/presentation/controllers/new_page_cubit/new_page_cubit.dart';
import 'package:quicknotion/feature/databases/presentation/widgets/property_widget.dart';

class NewPageViewBody extends StatelessWidget {
  const NewPageViewBody({super.key, required this.database});
  final DatabaseEntity database;
  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Icon(AppIcons.angleRight),
            ),
          ),
          SizedBox(height: 8),
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
          ...database.properties.map(
            (e) => PropertyWidget(
              property: e,
              onChanged: (value) {
                context.read<NewPageCubit>().addProperty(
                  key: e.name,
                  value: value,
                  type: e.type,
                );
              },
            ),
          ),
          CustomButton(
            onPressed: () {
              context.read<NewPageCubit>().createNewPage(
                databaseId: database.id,
              );
            },
          ),
        ],
      ),
    );
  }
}
