import 'package:flutter/material.dart';
import 'package:quicknotion/config/routes/on_generate_routes.dart';
import 'package:quicknotion/config/themes/app_colors.dart';
import 'package:quicknotion/core/constants/constants.dart';
import 'package:quicknotion/core/database/cache/secure_storage.dart';
import 'package:quicknotion/core/utls/app_images.dart';
import 'package:quicknotion/core/utls/custom_loading_indecator.dart';

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
    if (token != null) {
      AppRoutes.homeView(context, data: {});
    } else {
      AppRoutes.tokenView(context);
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
                image: AssetImage(Assets.assetsImagesQuickNotionLogo),
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
