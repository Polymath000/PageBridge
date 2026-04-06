import 'package:flutter/material.dart';
import 'package:pagebridge/config/routes/on_generate_routes.dart';
import 'package:pagebridge/config/themes/app_colors.dart';
import 'package:pagebridge/core/constants/constants.dart';
import 'package:pagebridge/core/database/cache/secure_storage.dart';
import 'package:pagebridge/core/services/shared_preferences_singleton.dart';
import 'package:pagebridge/core/utls/app_images.dart';
import 'package:pagebridge/core/utls/custom_loading_indecator.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});
  static const routeName = "splash";

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  String? token;
  @override
  void initState() {
    _checkAuthentication();
    super.initState();
  }

  void _checkAuthentication() async {
    await Future.delayed(const Duration(seconds: 1));
    if (!mounted) return;
    token = await SecureStorage.readData(key: tokenKey);
    final seenOnboarding =
        SharedPreferencesSingleton.getBool(onboardingSeenKey) ?? false;
    if (token != null) {
      // ignore: use_build_context_synchronously
      AppRoutes.homeView(context);
    } else if (!seenOnboarding) {
      // ignore: use_build_context_synchronously
      AppRoutes.onboardingView(context);
    } else {
      // ignore: use_build_context_synchronously
      AppRoutes.authView(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xffDDE1E7),
              Color(0xffC7CBD1),
              AppColors.mediumGray,
            ],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image(
                image: AssetImage(Assets.assetsImagesPageBridgeLogo),
                height: 200,
              ),
              const SizedBox(height: 40),

              CustomLoadingIndecator(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
