import 'package:flutter/material.dart';
import 'package:quicknotion/config/themes/app_text_style.dart';
import 'package:quicknotion/feature/database_view/presentation/widgets/submit_button.dart';
import 'package:quicknotion/feature/database_view/presentation/widgets/token_text_field.dart';

class TokenViewBody extends StatelessWidget {
  TokenViewBody({super.key});
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  AutovalidateMode autovalidateMode = AutovalidateMode.disabled;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Form(
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
              TokenTextField(),
              const SizedBox(height: 24),
              SubmitButton(
                formKey: formKey,
                autovalidateMode: autovalidateMode,
              ),
              const Spacer(flex: 2),
            ],
          ),
        ),
      ),
    );
  }
}
