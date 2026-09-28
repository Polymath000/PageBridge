import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:pagebridge/config/routes/on_generate_routes.dart';
import 'package:pagebridge/core/helpers/custom_show_snack_bar.dart';
import 'package:pagebridge/feature/auth/presentation/widgets/auth_card_form.dart';
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
          Navigator.pushNamedAndRemoveUntil(
            context,
            AppRoutes.home,
            (_) => false,
          );
        }
      },
      builder: (context, state) {
        final isLoading = state is AuthLoading;

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
                        child: AuthCardForm(
                          logoScale: _logoScale,
                          acceptedTerms: _acceptedTerms,
                          isLoading: isLoading,
                          termsTapRecognizer: _termsTapRecognizer,
                          privacyTapRecognizer: _privacyTapRecognizer,
                          onTermsChanged: (value) {
                            setState(() {
                              _acceptedTerms = value ?? false;
                            });
                          },
                          onSubmit: () => context.read<AuthCubit>().signIn(),
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
