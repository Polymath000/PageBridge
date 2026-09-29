import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pagebridge/config/extensions/string_extension.dart';
import 'package:pagebridge/config/routes/on_generate_routes.dart';
import 'package:pagebridge/core/services/shared_preferences_singleton.dart';
import 'package:pagebridge/core/theme/app_theme.dart';
import 'package:pagebridge/config/themes/app_text_style.dart';
import 'package:pagebridge/feature/settings/presentation/controllers/theme_mode_cubit/theme_mode_cubit.dart';

class PageBridgeApp extends StatelessWidget {
  const PageBridgeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, child) {
        return BlocBuilder<ThemeModeCubit, ThemeModeState>(
          builder: (context, state) {
            ThemeMode mode = ThemeMode.system;
            if (state is ThemeModeDark) {
              mode = ThemeMode.dark;
            } else if (state is ThemeModeLight) {
              mode = ThemeMode.light;
            } else {
              final stored = SharedPreferencesSingleton.getString('themeMode');
              mode = stored?.toEnum(ThemeMode.values) ?? ThemeMode.system;
            }

            return MaterialApp(
              onGenerateRoute: AppRoutes.onGenerateRoute,
              initialRoute: AppRoutes.splash,
              theme: AppTheme.lightTheme,
              darkTheme: AppTheme.darkTheme,
              themeMode: mode,
              debugShowCheckedModeBanner: false,
              builder: (context, child) {
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
