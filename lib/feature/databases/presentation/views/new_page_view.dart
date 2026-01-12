import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quicknotion/config/routes/on_generate_routes.dart';
import 'package:quicknotion/config/themes/app_colors.dart';
import 'package:quicknotion/core/helpers/custom_show_snack_bar.dart';
import 'package:quicknotion/core/utls/custom_loading_indecator.dart';
import 'package:quicknotion/core/utls/setup_service_locator_getit.dart';
import 'package:quicknotion/feature/databases/data/repos/create_new_page_repo_impl.dart';
import 'package:quicknotion/feature/databases/domain/entities/database_entity.dart';
import 'package:quicknotion/feature/databases/presentation/controllers/new_page_cubit/new_page_cubit.dart';
import 'package:quicknotion/feature/databases/presentation/widgets/new_page_view_body.dart';

class NewPageView extends StatelessWidget {
  const NewPageView({super.key, required this.database});
  final DatabaseEntity database;
  static const String routeName = 'new_page_view';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 16.0, left: 20, right: 20),
            child: BlocProvider(
              create: (context) => NewPageCubit(
                createNewPageRepoImpl: getit.get<CreateNewPageRepoImpl>(),
              ),
              child: BlocConsumer<NewPageCubit, NewPageState>(
                listener: (context, state) {
                  if (state is NewPageSuccess) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      AppRoutes.pop(context);
                      customShowSnackBar(
                        message: "The new page has been added successfully",
                        context: context,
                        backgroundColor: AppColors.green,
                      );
                    });
                  }
                },
                builder: (context, state) {
                  if (state is NewPageFailure) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      customShowSnackBar(
                        message: state.message,
                        context: context,
                      );
                    });
                  } else
                  // if (state is NewPageLoading)
                  {
                    return CustomLoadingIndecator();
                  }
                  return NewPageViewBody(database: database);
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
