import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pagebridge/config/extensions/string_extension.dart';
import 'package:pagebridge/config/routes/on_generate_routes.dart';
import 'package:pagebridge/config/themes/app_text_style.dart';
import 'package:pagebridge/config/themes/theme_config.dart' show ThemeConfig;
import 'package:pagebridge/core/services/shared_preferences_singleton.dart';
import 'package:pagebridge/feature/onStartedViews/presentation/views/splash_view.dart';

import 'config/themes/app_colors.dart';

class PageBridgeApp extends StatelessWidget {
  const PageBridgeApp({super.key});

  @override
  Widget build(BuildContext context) {
    final stored = SharedPreferencesSingleton.getString('themeMode');
    final mode = stored?.toEnum(ThemeMode.values) ?? ThemeMode.system;
    final isDark =
        mode == ThemeMode.dark ||
        (mode == ThemeMode.system &&
            WidgetsBinding.instance.platformDispatcher.platformBrightness ==
                Brightness.dark);
    final themeConfig = const ThemeConfig();
    final initTheme =
        (isDark ? themeConfig.dark : themeConfig.light) ??
        (isDark ? ThemeData.dark() : ThemeData.light());
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, child) {
        return ThemeProvider(
          initTheme: initTheme,
          builder: (context, theme) {
            return MaterialApp(
              color: AppColors.transparent,
              onGenerateRoute: onGenerateRoute,
              initialRoute: SplashView.routeName,
              theme: theme,
              debugShowCheckedModeBanner: false,
              builder: (context, child) {
                AppColors.init(context);
                AppTextStyles.init(context);
                return ThemeSwitchingArea(child: child ?? const SizedBox());
              },
            );
          },
        );
      },
    );
  }
}
