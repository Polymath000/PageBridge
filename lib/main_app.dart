import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quicknotion/config/routes/on_generate_routes.dart';
import 'package:quicknotion/config/themes/app_text_style.dart';
import 'package:quicknotion/config/themes/theme_config.dart' show ThemeConfig;
import 'package:quicknotion/feature/onboarding&splash/presentation/views/splash_view.dart';

import 'config/themes/app_colors.dart';

class QuickNotionApp extends StatelessWidget {
  const QuickNotionApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      // Use builder only if you need to use library outside ScreenUtilInit context
      builder: (_, child) {
        return MaterialApp(
          onGenerateRoute: onGenerateRoute,
          initialRoute: SplashView.routeName,
          theme: const ThemeConfig().light,
          // darkTheme: const ThemeConfig().dark,
          debugShowCheckedModeBanner: false,
          builder: (context, child) {
            AppColors.init(context);
            AppTextStyles.init(context);
            return child ?? const SizedBox();
          },
        );
      },
    );
  }
}
