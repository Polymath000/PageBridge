import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:pagebridge/core/theme/app_colors.dart';
import 'package:pagebridge/feature/auth/presentation/widgets/auth_header.dart';
import 'package:pagebridge/feature/auth/presentation/widgets/auth_submit_button.dart';
import 'package:pagebridge/feature/auth/presentation/widgets/auth_terms_checkbox.dart';

class AuthCardForm extends StatelessWidget {
  const AuthCardForm({
    super.key,
    required this.logoScale,
    required this.acceptedTerms,
    required this.isLoading,
    required this.termsTapRecognizer,
    required this.privacyTapRecognizer,
    required this.onTermsChanged,
    required this.onSubmit,
  });

  final Animation<double> logoScale;
  final bool acceptedTerms;
  final bool isLoading;
  final TapGestureRecognizer termsTapRecognizer;
  final TapGestureRecognizer privacyTapRecognizer;
  final ValueChanged<bool?> onTermsChanged;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.white.withValues(alpha: 0.88),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.white.withValues(alpha: 0.6)),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.2),
            blurRadius: 28,
            offset: const Offset(0, 16),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AuthHeader(logoScale: logoScale),
            const SizedBox(height: 24),
            AuthTermsCheckbox(
              acceptedTerms: acceptedTerms,
              isLoading: isLoading,
              onChanged: onTermsChanged,
              termsTapRecognizer: termsTapRecognizer,
              privacyTapRecognizer: privacyTapRecognizer,
            ),
            const SizedBox(height: 16),
            AuthSubmitButton(
              isLoading: isLoading,
              acceptedTerms: acceptedTerms,
              onSubmit: onSubmit,
            ),
            const SizedBox(height: 12),
            Text(
              'Secure OAuth sign-in.',
              textAlign: TextAlign.center,
              style: Theme.of(
                context,
              ).textTheme.labelMedium?.copyWith(color: AppColors.textGray),
            ),
          ],
        ),
      ),
    );
  }
}
