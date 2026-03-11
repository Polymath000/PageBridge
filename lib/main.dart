import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quicknotion/core/database/cache/secure_storage.dart';
import 'package:quicknotion/core/services/shared_preferences_singleton.dart';
import 'package:quicknotion/core/utls/setup_service_locator_getit.dart';
import 'package:quicknotion/feature/databases/presentation/controllers/theme_mode_cubit/theme_mode_cubit.dart';
import 'package:quicknotion/main_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SecureStorage.init();
  await SharedPreferencesSingleton.init();
  setUpServiceLocator();

  runApp(
    BlocProvider(
      create: (context) => ThemeModeCubit(),

      child: QuickNotionApp(),
    ),
  );
}
