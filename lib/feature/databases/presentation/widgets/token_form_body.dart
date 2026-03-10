import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quicknotion/config/routes/on_generate_routes.dart';
import 'package:quicknotion/config/themes/app_colors.dart';
import 'package:quicknotion/config/themes/app_text_style.dart';
import 'package:quicknotion/core/helpers/custom_show_snack_bar.dart';
import 'package:quicknotion/core/utls/custom_loading_indecator.dart';
import 'package:quicknotion/feature/databases/presentation/controllers/return_databases_cubit/return_databases_cubit.dart';
import 'package:quicknotion/feature/databases/presentation/widgets/submit_button.dart';
import 'package:quicknotion/feature/databases/presentation/widgets/token_text_field.dart';

class TokenFormBody extends StatefulWidget {
  const TokenFormBody({super.key});

  @override
  State<TokenFormBody> createState() => _TokenFormBodyState();
}

class _TokenFormBodyState extends State<TokenFormBody> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  AutovalidateMode autovalidateMode = AutovalidateMode.disabled;
  String token = "";
  Map<String, dynamic> data = {};
  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    return BlocConsumer<DatabasesCubit, DatabasesState>(
      listener: (context, state) {
        if (state is DatabasesSuccess) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            data["databases"] = state.databases;
            data["hasMore"] = state.hasMore;
            data["nextCursor"] = state.nextCursor;
            AppRoutes.homeView(context, data: data);
            customShowSnackBar(
              message: "Welcome 😊",
              context: context,
              backgroundColor: AppColors.green,
            );
          });
        }
      },
      builder: (context, state) {
        if (state is DatabasesLoading) {
          return CustomLoadingIndecator();
        } else if (state is DatabasesFailure) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            customShowSnackBar(message: state.message, context: context);
          });
        }
        return Form(
          key: formKey,
          autovalidateMode: autovalidateMode,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Spacer(flex: 1),
              Text(
                'Enter the Token',
                style: AppTextStyles.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).brightness == Brightness.light
                      ? colorScheme.onSurface
                      : AppColors.white,
                ),
              ),
              const SizedBox(height: 24),
              TokenTextField(
                onChanged: (value) {
                  setState(() {
                    token = value;
                  });
                },
              ),
              const SizedBox(height: 24),
              SubmitButton(
                formKey: formKey,
                autovalidateMode: autovalidateMode,
                token: token,
              ),
              const Spacer(flex: 2),
            ],
          ),
        );
      },
    );
  }
}
