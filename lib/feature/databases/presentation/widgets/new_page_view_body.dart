import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pagebridge/config/routes/on_generate_routes.dart';
import 'package:pagebridge/core/helpers/custom_button.dart';
import 'package:pagebridge/core/helpers/custom_confirm_dialog.dart';
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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: TextFormField(
              maxLines: null,
              minLines: 3,
              decoration: InputDecoration(
                labelText: 'Page Content (Optional)',
                hintText: 'Start writing your page content here...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
              ),
              onChanged: (value) {
                context.read<NewPageCubit>().setContent(value);
              },
            ),
          ),
          const SizedBox(height: 16),
          CustomButton(
            onPressed: () async {
              final cubit = context.read<NewPageCubit>();
              final hasData = cubit.newPageProperties.any(
                (p) => p.value != null && p.value.toString().isNotEmpty,
              ) || (cubit.pageContent != null && cubit.pageContent!.trim().isNotEmpty);

              if (!hasData) {
                final confirmed = await showAppConfirmDialog(
                  context: context,
                  title: 'Empty Page',
                  message:
                      'Are you sure you want to add a new empty page?',
                );
                if (!confirmed || !context.mounted) return;
              }

              final url = await cubit.createNewPage(
                databaseId: database.id,
              );
              if (url != null && context.mounted) {
                AppRoutes.pop(context, url);
              }
            },
          ),
        ],
      ),
    );
  }
}

