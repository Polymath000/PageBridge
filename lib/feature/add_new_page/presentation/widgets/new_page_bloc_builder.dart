import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:pagebridge/core/helpers/custom_show_snack_bar.dart';
import 'package:pagebridge/core/utls/custom_loading_indecator.dart';
import 'package:pagebridge/core/theme/app_colors.dart';
import 'package:pagebridge/feature/add_new_page/presentation/controllers/new_page_cubit/new_page_cubit.dart';
import 'package:pagebridge/feature/add_new_page/presentation/widgets/new_page_view_body.dart';
import 'package:pagebridge/feature/add_new_page/presentation/widgets/new_page_app_bar.dart';
import 'package:pagebridge/feature/add_new_page/presentation/widgets/new_page_fab.dart';
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
          backgroundColor: AppColors.transparent,
          appBar: newPageAppBar(context: context, title: widget.database.title),
          floatingActionButton: NewPageFab(databaseId: widget.database.id),
          body: Stack(
            children: [
              const CustomAnimationBackground(isAnimated: false),
              SafeArea(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.only(
                      bottom: 80.0,
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
