import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pagebridge/core/helpers/custom_confirm_dialog.dart';
import 'package:pagebridge/config/themes/app_icons.dart';
import 'package:pagebridge/feature/add_new_page/presentation/controllers/new_page_cubit/new_page_cubit.dart';

class NewPageFab extends StatelessWidget {
  const NewPageFab({super.key, required this.databaseId});

  final String databaseId;

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: () async {
        final cubit = context.read<NewPageCubit>();

        if (!cubit.hasData) {
          final confirmed = await showAppConfirmDialog(
            context: context,
            title: 'Empty Page',
            message: 'Are you sure you want to add a new empty page?',
          );
          if (!confirmed || !context.mounted) return;
        }

        final url = await cubit.createNewPage(databaseId: databaseId);
        if (url != null && context.mounted) {
          Navigator.pop(context, url);
        }
      },
      icon: Icon(AppIcons.checkRounded),
      label: const Text(
        "Save Page",
        style: TextStyle(fontWeight: FontWeight.w700),
      ),
    );
  }
}
