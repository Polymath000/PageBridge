import 'package:flutter/material.dart';
import 'package:quicknotion/config/routes/on_generate_routes.dart';
import 'package:quicknotion/config/themes/app_text_style.dart';
import 'package:quicknotion/config/themes/theme_config.dart' show ThemeConfig;
import 'package:quicknotion/feature/database_view/presentation/views/token_view.dart';

import 'config/themes/app_colors.dart';

class QuickNotionApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      onGenerateRoute: onGenerateRoute,
      initialRoute: TokenView.routeName,
      theme: const ThemeConfig().light,
      darkTheme: const ThemeConfig().dark,
      debugShowCheckedModeBanner: false,
      builder: (final context, final child) {
        AppColors.init(context);
        AppTextStyles.init(context);
        return child!;
      },
    );
  }
}
