import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quicknotion/config/routes/on_generate_routes.dart';
import 'package:quicknotion/config/themes/app_text_style.dart';
import 'package:quicknotion/core/helpers/custom_show_snack_bar.dart';
import 'package:quicknotion/core/utls/custom_loading_indecator.dart';
import 'package:quicknotion/feature/database_view/presentation/controllers/add_token_cubit/add_token_cubit.dart';
import 'package:quicknotion/feature/database_view/presentation/widgets/submit_button.dart';
import 'package:quicknotion/feature/database_view/presentation/widgets/token_text_field.dart';

class TokenFormBody extends StatefulWidget {
  TokenFormBody({super.key, required this.context});
  final BuildContext context;

  @override
  State<TokenFormBody> createState() => _TokenFormBodyState();
}

class _TokenFormBodyState extends State<TokenFormBody> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  AutovalidateMode autovalidateMode = AutovalidateMode.disabled;
  String token = "";

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    return BlocConsumer<AddTokenCubit, AddTokenState>(
      listener: (context, state) {
        if (state is AddTokenSuccess) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            AppRoutes.homeView(context);
          });
        }
      },
      builder: (context, state) {
        if (state is AddTokenLoading) {
          return CustomLoadingIndecator();
        } else if (state is AddTokenFailure) {
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
                  color: colorScheme.onBackground,
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
