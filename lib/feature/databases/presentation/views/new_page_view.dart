import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:pagebridge/feature/auth/presentation/widgets/custom_animation_background.dart';
import 'package:pagebridge/core/helpers/custom_show_snack_bar.dart';
import 'package:pagebridge/core/utls/custom_loading_indecator.dart';
import 'package:pagebridge/core/utls/setup_service_locator_getit.dart';
import 'package:pagebridge/feature/databases/domain/repo/create_new_page_repo.dart';
import 'package:pagebridge/feature/databases/domain/repo/return_pages_repo.dart';
import 'package:pagebridge/feature/databases/domain/entities/database_entity.dart';
import 'package:pagebridge/feature/databases/presentation/controllers/new_page_cubit/new_page_cubit.dart';
import 'package:pagebridge/feature/databases/presentation/controllers/return_pages_cubit/return_pages_cubit.dart';
import 'package:pagebridge/feature/databases/presentation/widgets/new_page_view_body.dart';

class NewPageView extends StatelessWidget {
  const NewPageView({super.key, required this.database});
  final DatabaseEntity database;
  static const String routeName = 'new_page_view';

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
              ReturnPagesCubit(repo: getit.get<ReturnPagesRepo>()),
        ),
        BlocProvider(
          create: (context) => NewPageCubit(
            createNewPageRepo: getit.get<CreateNewPageRepo>(),
          ),
        ),
      ],
      child: NewPageBlocBuilder(database: database),
    );
  }
}

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
    final returnPagesLoading =
        context.watch<ReturnPagesCubit>().state is ReturnPagesLoading;
    return BlocListener<NewPageCubit, NewPageState>(
      listener: (context, state) {
        if (state is NewPageFailure) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            customShowSnackBar(message: state.message, context: context);
          });
        }
      },
      child: ModalProgressHUD(
        inAsyncCall: newPageLoading || returnPagesLoading,
        progressIndicator: CustomLoadingIndecator(),
        child: Scaffold(
          body: Stack(
            children: [
              const CustomAnimationBackground(),
              SafeArea(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.only(
                      bottom: 16.0,
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
