import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:pagebridge/core/database/cache/secure_storage.dart';
import 'package:pagebridge/core/services/shared_preferences_singleton.dart';
import 'package:pagebridge/core/utls/setup_service_locator_getit.dart';
import 'package:pagebridge/feature/databases/presentation/controllers/theme_mode_cubit/theme_mode_cubit.dart';
import 'package:pagebridge/main_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SecureStorage.init();
  await SharedPreferencesSingleton.init();
  setUpServiceLocator();
  await dotenv.load(fileName: ".env");
  runApp(
    BlocProvider(create: (context) => ThemeModeCubit(), child: PageBridgeApp()),
  );
}
