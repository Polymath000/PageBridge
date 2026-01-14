import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quicknotion/config/extensions/string_extension.dart';
import 'package:quicknotion/config/routes/on_generate_routes.dart';
import 'package:quicknotion/config/themes/app_text_style.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quicknotion/feature/databases/presentation/controllers/theme_mode_cubit/theme_mode_cubit.dart';
import 'package:quicknotion/config/themes/theme_config.dart' show ThemeConfig;
import 'package:quicknotion/core/services/shared_preferences_singleton.dart';
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
        return BlocBuilder<ThemeModeCubit, ThemeModeState>(
          builder: (context, state) {
            ThemeMode activeMode = ThemeMode.system;
            if (state is ThemeModeDark) {
              activeMode = ThemeMode.dark;
            } else if (state is ThemeModeLight) {
              activeMode = ThemeMode.light;
            } else {
              activeMode =
                  SharedPreferencesSingleton.getString(
                    'themeMode',
                  )?.toEnum(ThemeMode.values) ??
                  ThemeMode.system;
            }

            return MaterialApp(
              onGenerateRoute: onGenerateRoute,
              initialRoute: SplashView.routeName,
              theme: const ThemeConfig().light,
              darkTheme: const ThemeConfig().dark,
              themeMode: activeMode,
              debugShowCheckedModeBanner: false,
              builder: (context, child) {
                AppColors.init(context);
                AppTextStyles.init(context);
                return child ?? const SizedBox();
              },
            );
          },
        );
      },
    );
  }
}
