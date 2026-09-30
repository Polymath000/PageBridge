import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:pagebridge/core/helpers/custom_confirm_dialog.dart';
import 'package:pagebridge/core/helpers/custom_show_snack_bar.dart';
import 'package:pagebridge/core/utls/custom_loading_indecator.dart';
import 'package:pagebridge/core/helpers/custom_back_arrow.dart';
import 'package:pagebridge/feature/add_new_page/presentation/controllers/new_page_cubit/new_page_cubit.dart';
import 'package:pagebridge/feature/add_new_page/presentation/widgets/new_page_view_body.dart';
import 'package:pagebridge/feature/auth/presentation/widgets/custom_animation_background.dart';
import 'package:pagebridge/feature/databases/domain/entities/database_entity.dart';

class NewPageBlocBuilder extends StatefulWidget {
  const NewPageBlocBuilder({super.key, required this.database});

  final DatabaseEntity database;

  @override
  State<NewPageBlocBuilder> createState() => _NewPageBlocBuilderState();
}

class _NewPageBlocBuilderState extends State<NewPageBlocBuilder> {
  @override
  Widget build(BuildContext context) {
    final newPageLoading =
        context.watch<NewPageCubit>().state is NewPageLoading;

    return BlocListener<NewPageCubit, NewPageState>(
      listener: (context, state) {
        if (state is NewPageFailure) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            customShowSnackBar(message: state.message, context: context);
          });
        }
      },
      child: ModalProgressHUD(
        inAsyncCall: newPageLoading,
        progressIndicator: const CustomLoadingIndecator(),
        child: Scaffold(
          extendBodyBehindAppBar: true,
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: const Padding(
              padding: EdgeInsets.all(8.0),
              child: CustomBackArrow(),
            ),
            title: Text(
              widget.database.title.toUpperCase(),
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ),
          floatingActionButton: FloatingActionButton.extended(
            backgroundColor: Theme.of(context).colorScheme.primary.withValues(alpha: 0.15),
            foregroundColor: Theme.of(context).colorScheme.primary,
            elevation: 0,
            highlightElevation: 0,
            onPressed: () async {
              final cubit = context.read<NewPageCubit>();
              final hasData =
                  cubit.newPageProperties.any(
                    (p) => p.value != null && p.value.toString().isNotEmpty,
                  ) ||
                  (cubit.pageContent != null &&
                      cubit.pageContent!.trim().isNotEmpty);

              if (!hasData) {
                final confirmed = await showAppConfirmDialog(
                  context: context,
                  title: 'Empty Page',
                  message: 'Are you sure you want to add a new empty page?',
                );
                if (!confirmed || !context.mounted) return;
              }

              final url = await cubit.createNewPage(databaseId: widget.database.id);
              if (url != null && context.mounted) {
                Navigator.pop(context, url);
              }
            },
            icon: const Icon(Icons.check_rounded),
            label: const Text(
              "Save Page",
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
          ),
          body: Stack(
            children: [
              const CustomAnimationBackground(isAnimated: false),
              SafeArea(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.only(
                      bottom: 80.0, // extra padding so FAB doesn't cover text
                      left: 0,
                      right: 20,
                    ),
                    child: NewPageViewBody(database: widget.database),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
