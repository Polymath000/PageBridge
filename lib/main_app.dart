import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pagebridge/config/extensions/string_extension.dart';
import 'package:pagebridge/config/routes/on_generate_routes.dart';
import 'package:pagebridge/core/responsive/clamped_text_scaler.dart';
import 'package:pagebridge/core/responsive/responsive_scale.dart';
import 'package:pagebridge/core/services/shared_preferences_singleton.dart';
import 'package:pagebridge/core/theme/app_theme.dart';
import 'package:pagebridge/config/themes/app_text_style.dart';
import 'package:pagebridge/feature/settings/presentation/controllers/theme_mode_cubit/theme_mode_cubit.dart';

class PageBridgeApp extends StatelessWidget {
  const PageBridgeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MediaQuery.fromView(
      view: View.of(context),
      child: Builder(
        builder: (context) => ScreenUtilInit(
          designSize: ResponsiveScale.designSizeFor(MediaQuery.sizeOf(context)),
          minTextAdapt: true,
          fontSizeResolver: ResponsiveScale.fontResolver,
          builder: (_, _) =>
              _ThemedApp(light: AppTheme.light(), dark: AppTheme.dark()),
        ),
      ),
    );
  }
}

class _ThemedApp extends StatelessWidget {
  const _ThemedApp({required this.light, required this.dark});

  final ThemeData light;
  final ThemeData dark;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeModeCubit, ThemeModeState>(
      builder: (context, state) {
        return MaterialApp(
          onGenerateRoute: AppRoutes.onGenerateRoute,
          initialRoute: AppRoutes.splash,
          theme: light,
          darkTheme: dark,
          themeMode: _resolveMode(state),
          debugShowCheckedModeBanner: false,
          builder: (context, child) {
            AppTextStyles.init(context);
            return ClampedTextScaler(child: child ?? const SizedBox());
          },
        );
      },
    );
  }

  ThemeMode _resolveMode(ThemeModeState state) => switch (state) {
    ThemeModeDark() => ThemeMode.dark,
    ThemeModeLight() => ThemeMode.light,
    _ =>
      SharedPreferencesSingleton.getString(
            'themeMode',
          )?.toEnum(ThemeMode.values) ??
          ThemeMode.system,
  };
}
