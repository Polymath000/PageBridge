import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:pagebridge/core/theme/app_colors.dart';

class AuthTermsCheckbox extends StatelessWidget {
  const AuthTermsCheckbox({
    super.key,
    required this.acceptedTerms,
    required this.isLoading,
    required this.onChanged,
    required this.termsTapRecognizer,
    required this.privacyTapRecognizer,
  });

  final bool acceptedTerms;
  final bool isLoading;
  final ValueChanged<bool?> onChanged;
  final TapGestureRecognizer termsTapRecognizer;
  final TapGestureRecognizer privacyTapRecognizer;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final termsTextStyle =
        textTheme.bodySmall?.copyWith(color: AppColors.darkGrey, height: 1.4) ??
        const TextStyle(fontSize: 12, color: AppColors.darkGrey, height: 1.4);
    final termsLinkStyle = termsTextStyle.copyWith(
      color: AppColors.black,
      fontWeight: FontWeight.w600,
      decoration: TextDecoration.underline,
    );

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Checkbox(value: acceptedTerms, onChanged: isLoading ? null : onChanged),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text.rich(
              TextSpan(
                style: termsTextStyle,
                children: [
                  const TextSpan(text: 'I agree to the '),
                  TextSpan(
                    text: 'Terms & Conditions',
                    style: termsLinkStyle,
                    recognizer: termsTapRecognizer,
                  ),
                  const TextSpan(text: ' and '),
                  TextSpan(
                    text: 'Privacy Policy',
                    style: termsLinkStyle,
                    recognizer: privacyTapRecognizer,
                  ),
                  const TextSpan(text: '.'),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
