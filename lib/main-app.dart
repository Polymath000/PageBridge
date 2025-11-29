import 'package:flutter/material.dart';
import 'package:quicknotion/config/routes/on_generate_routes.dart';
import 'package:quicknotion/config/themes/app_text_style.dart';
import 'package:quicknotion/config/themes/theme_config.dart' show ThemeConfig;
import 'package:quicknotion/core/constants/constants.dart';
import 'package:quicknotion/core/database/cache/secure_storage.dart';
import 'package:quicknotion/feature/database_view/presentation/views/home_view.dart';
import 'package:quicknotion/feature/database_view/presentation/views/token_view.dart';

import 'config/themes/app_colors.dart';

class QuickNotionApp extends StatefulWidget {
  const QuickNotionApp({super.key});

  @override
  State<QuickNotionApp> createState() => _QuickNotionAppState();
}

class _QuickNotionAppState extends State<QuickNotionApp> {
  late final Future<bool> _hasTokenFuture;

  @override
  void initState() {
    super.initState();
    _hasTokenFuture = SecureStorage.checkData(key: tokenKey);
    print(SecureStorage.readData(key: tokenKey));
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _hasTokenFuture,
      builder: (context, snapshot) {
        // if (!snapshot.hasData) {
        //   return const MaterialApp(
        //     home: Scaffold(body: Center(child: CircularProgressIndicator())),
        //   );
        // }
        String initialRoute = TokenView.routeName;
        if (snapshot.hasError) {
          initialRoute = TokenView.routeName;
        } else {
          final bool hasToken = snapshot.data ?? false;
          initialRoute = hasToken ? HomeView.routeName : TokenView.routeName;
        }

        return MaterialApp(
          onGenerateRoute: onGenerateRoute,
          initialRoute: initialRoute,
          theme: const ThemeConfig().light,
          darkTheme: const ThemeConfig().dark,
          debugShowCheckedModeBanner: false,
          builder: (final context, final child) {
            AppColors.init(context);
            AppTextStyles.init(context);
            return child ?? const SizedBox();
          },
        );
      },
    );
  }
}
