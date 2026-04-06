import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:pagebridge/config/routes/on_generate_routes.dart';
import 'package:pagebridge/config/themes/app_colors.dart';
import 'package:pagebridge/core/helpers/custom_show_snack_bar.dart';
import 'package:pagebridge/core/utls/app_images.dart';
import 'package:url_launcher/url_launcher.dart';

import '../controllers/auth_cubit/auth_cubit.dart';
import 'custom_animation_background.dart';

class AuthBody extends StatefulWidget {
  const AuthBody({super.key});

  @override
  State<AuthBody> createState() => _AuthBodyState();
}

class _AuthBodyState extends State<AuthBody>
    with SingleTickerProviderStateMixin {
  static final Uri _termsUrl = Uri.parse(
    dotenv.env["TERMS_AND_CONDITIONS_WEB"] ?? "",
  );
  late final AnimationController _controller;
  late final Animation<double> _fade;
  late final Animation<Offset> _slide;
  late final Animation<double> _logoScale;
  late final TapGestureRecognizer _termsTapRecognizer;
  late final TapGestureRecognizer _privacyTapRecognizer;
  bool _acceptedTerms = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _fade = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
    _slide = Tween<Offset>(
      begin: const Offset(0, 0.08),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));
    _logoScale = Tween<double>(
      begin: 0.85,
      end: 1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));
    _termsTapRecognizer = TapGestureRecognizer()..onTap = _openTerms;
    _privacyTapRecognizer = TapGestureRecognizer()..onTap = _openTerms;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _controller.forward();
    });
  }

  Future<void> _openTerms() async {
    try {
      final didLaunch = await launchUrl(
        _termsUrl,
        mode: LaunchMode.externalApplication,
      );
      if (!didLaunch && mounted) {
        customShowSnackBar(
          message: 'Could not open the Terms & Privacy page.',
          context: context,
        );
      }
    } catch (_) {
      if (mounted) {
        customShowSnackBar(
          message: 'Could not open the Terms & Privacy page.',
          context: context,
        );
      }
    }
  }

  @override
  void dispose() {
    _termsTapRecognizer.dispose();
    _privacyTapRecognizer.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthFailure) {
          customShowSnackBar(message: state.message, context: context);
        } else if (state is AuthSuccess) {
          AppRoutes.homeView(context);
        }
      },
      builder: (context, state) {
        final isLoading = state is AuthLoading;
        final textTheme = Theme.of(context).textTheme;
        final termsTextStyle =
            textTheme.bodySmall?.copyWith(
              color: AppColors.darkGrey,
              height: 1.4,
            ) ??
            const TextStyle(
              fontSize: 12,
              color: AppColors.darkGrey,
              height: 1.4,
            );
        final termsLinkStyle = termsTextStyle.copyWith(
          color: AppColors.black,
          fontWeight: FontWeight.w600,
          decoration: TextDecoration.underline,
        );
        return Stack(
          children: [
            const CustomAnimationBackground(),
            SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 32,
                  ),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 420),
                    child: FadeTransition(
                      opacity: _fade,
                      child: SlideTransition(
                        position: _slide,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            color: AppColors.white.withValues(alpha: 0.88),
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(
                              color: AppColors.white.withValues(alpha: 0.6),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.black.withValues(alpha: 0.2),
                                blurRadius: 28,
                                offset: const Offset(0, 16),
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 28,
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                ScaleTransition(
                                  scale: _logoScale,
                                  child: Container(
                                    width: 92,
                                    height: 92,
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: AppColors.white,
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                          color: AppColors.black.withValues(
                                            alpha: 0.12,
                                          ),
                                          blurRadius: 18,
                                          offset: const Offset(0, 10),
                                        ),
                                      ],
                                    ),
                                    child: Image.asset(
                                      Assets.assetsImagesPageBridgeBrandLogo,
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 20),
                                Text(
                                  'PageBridge',
                                  style: textTheme.headlineMedium?.copyWith(
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.spaceBlack,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Capture ideas fast and sync them to your '
                                  'Notion workspace in seconds.',
                                  textAlign: TextAlign.center,
                                  style: textTheme.bodyMedium?.copyWith(
                                    color: AppColors.darkGrey,
                                    height: 1.4,
                                  ),
                                ),
                                const SizedBox(height: 24),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Checkbox(
                                      value: _acceptedTerms,
                                      onChanged: isLoading
                                          ? null
                                          : (value) {
                                              setState(() {
                                                _acceptedTerms = value ?? false;
                                              });
                                            },
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.only(top: 8),
                                        child: Text.rich(
                                          TextSpan(
                                            style: termsTextStyle,
                                            children: [
                                              const TextSpan(
                                                text: 'I agree to the ',
                                              ),
                                              TextSpan(
                                                text: 'Terms & Conditions',
                                                style: termsLinkStyle,
                                                recognizer: _termsTapRecognizer,
                                              ),
                                              const TextSpan(text: ' and '),
                                              TextSpan(
                                                text: 'Privacy Policy',
                                                style: termsLinkStyle,
                                                recognizer:
                                                    _privacyTapRecognizer,
                                              ),
                                              const TextSpan(text: '.'),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    onPressed: isLoading
                                        ? null
                                        : _acceptedTerms
                                        ? () =>
                                              context.read<AuthCubit>().signIn()
                                        : null,
                                    style: ElevatedButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 14,
                                      ),
                                      backgroundColor: AppColors.spaceBlack,
                                      foregroundColor: AppColors.white,
                                      disabledBackgroundColor:
                                          AppColors.darkGrey,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(14),
                                      ),
                                    ),
                                    child: AnimatedSwitcher(
                                      duration: const Duration(
                                        milliseconds: 250,
                                      ),
                                      child: isLoading
                                          ? const Row(
                                              key: ValueKey('loading'),
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                SizedBox(
                                                  width: 18,
                                                  height: 18,
                                                  child: CircularProgressIndicator(
                                                    strokeWidth: 2,
                                                    valueColor:
                                                        AlwaysStoppedAnimation<
                                                          Color
                                                        >(Colors.white),
                                                  ),
                                                ),
                                                SizedBox(width: 12),
                                                Text('Connecting...'),
                                              ],
                                            )
                                          : const Text(
                                              'Continue with Notion',
                                              key: ValueKey('idle'),
                                            ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  'Secure OAuth sign-in.',
                                  textAlign: TextAlign.center,
                                  style: textTheme.labelMedium?.copyWith(
                                    color: AppColors.textGray,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
