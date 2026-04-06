import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pagebridge/config/routes/on_generate_routes.dart';
import 'package:pagebridge/core/helpers/custom_button.dart';
import 'package:pagebridge/feature/databases/domain/entities/database_entity.dart';
import 'package:pagebridge/feature/databases/presentation/controllers/new_page_cubit/new_page_cubit.dart';
import 'package:pagebridge/feature/databases/presentation/widgets/property_widget.dart';

class NewPageViewBody extends StatelessWidget {
  const NewPageViewBody({super.key, required this.database});
  final DatabaseEntity database;
  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        children: [
          SizedBox(height: 8),
          ...database.properties.reversed.map(
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
            onPressed: () async {
              final success = await context.read<NewPageCubit>().createNewPage(
                databaseId: database.id,
              );
              if (success && context.mounted) {
                AppRoutes.pop(context, true);
              }
            },
          ),
        ],
      ),
    );
  }
}
