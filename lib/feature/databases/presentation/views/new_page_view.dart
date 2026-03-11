import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:quicknotion/core/helpers/custom_show_snack_bar.dart';
import 'package:quicknotion/core/utls/custom_loading_indecator.dart';
import 'package:quicknotion/core/utls/setup_service_locator_getit.dart';
import 'package:quicknotion/feature/databases/data/repos/create_new_page_repo_impl.dart';
import 'package:quicknotion/feature/databases/data/repos/return_pages_repo_impl.dart';
import 'package:quicknotion/feature/databases/domain/entities/database_entity.dart';
import 'package:quicknotion/feature/databases/presentation/controllers/new_page_cubit/new_page_cubit.dart';
import 'package:quicknotion/feature/databases/presentation/controllers/return_pages_cubit/return_pages_cubit.dart';
import 'package:quicknotion/feature/databases/presentation/widgets/new_page_view_body.dart';

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
              ReturnPagesCubit(repoImpl: getit.get<ReturnPagesRepoImpl>()),
        ),
        BlocProvider(
          create: (context) => NewPageCubit(
            createNewPageRepoImpl: getit.get<CreateNewPageRepoImpl>(),
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
          body: SafeArea(
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
        ),
      ),
    );
  }
}
