import 'package:flutter/material.dart';
import 'package:pagebridge/config/routes/on_generate_routes.dart';
import 'package:pagebridge/core/constants/constants.dart';
import 'package:pagebridge/core/database/cache/secure_storage.dart';
import 'package:pagebridge/core/services/shared_preferences_singleton.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pagebridge/core/theme/app_colors.dart';
import 'package:pagebridge/feature/on_started_views/presentation/widgets/animated_document_card.dart';
import 'package:pagebridge/feature/on_started_views/presentation/widgets/app_title_and_loader.dart';
import 'package:pagebridge/feature/on_started_views/presentation/widgets/glowing_link_indicator.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});
  static const routeName = "splash";

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView>
    with SingleTickerProviderStateMixin {
  String? token;
  late AnimationController _animationController;
  late Animation<double> _slideAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _checkAuthenticationStatus();
  }

  void _initializeAnimations() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _slideAnimation = CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.0, 0.6, curve: Curves.easeOutCubic),
    );

    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.5, 0.8, curve: Curves.elasticOut),
      ),
    );

    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.7, 1.0, curve: Curves.easeIn),
      ),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _checkAuthenticationStatus() async {
    await Future.delayed(const Duration(milliseconds: 2500));
    if (!mounted) return;

    token = await SecureStorage.readData(key: AppConstants.tokenKey);
    final hasSeenOnboarding =
        SharedPreferencesSingleton.getBool(AppConstants.onboardingSeenKey) ??
        false;

    if (token != null) {
      // ignore: use_build_context_synchronously
      Navigator.pushNamedAndRemoveUntil(context, AppRoutes.home, (_) => false);
    } else if (!hasSeenOnboarding) {
      // ignore: use_build_context_synchronously
      Navigator.pushNamedAndRemoveUntil(
        context,
        AppRoutes.onboarding,
        (_) => false,
      );
    } else {
      // ignore: use_build_context_synchronously
      Navigator.pushNamedAndRemoveUntil(context, AppRoutes.auth, (_) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    const backgroundColor = AppColors.darkBackground;
    const textColor = AppColors.white;
    const localDocumentColor = AppColors.white; // Light card
    const notionDocumentColor = AppColors.darkGrey; // Dark card

    return Scaffold(
      backgroundColor: backgroundColor,
      body: Stack(
        fit: StackFit.expand,
        children: [
          Center(
            child: Stack(
              alignment: Alignment.center,
              children: [
                AnimatedDocumentCard(
                  slideAnimation: _slideAnimation,
                  backgroundColor: localDocumentColor,
                  icon: FontAwesomeIcons.fileLines.data,
                  rotationAngle: -0.15,
                  startOffsetX: -150.0,
                  finalOffsetX: -30.0,
                ),
                AnimatedDocumentCard(
                  slideAnimation: _slideAnimation,
                  backgroundColor: notionDocumentColor,
                  icon: FontAwesomeIcons.n.data,
                  rotationAngle: 0.1,
                  startOffsetX: 150.0,
                  finalOffsetX: 25.0,
                ),
                GlowingLinkIndicator(scaleAnimation: _scaleAnimation),
              ],
            ),
          ),
          AppTitleAndLoader(
            opacityAnimation: _opacityAnimation,
            slideAnimationController: _animationController,
            textColor: textColor,
          ),
        ],
      ),
    );
  }
}
