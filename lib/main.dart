import 'package:flutter/material.dart';
import 'package:quicknotion/core/helpers/setup_service_locator.dart';
import 'package:quicknotion/core/utls/setup_service_locator_getit.dart';
import 'package:quicknotion/main-app.dart';
import 'package:quicknotion/core/database/cache/secure_storage.dart';

void main() {
  SecureStorage().init();
  getIt.registerLazySingleton<SecureStorage>(() => SecureStorage());
  setUpServiceLocator();
  runApp(QuickNotionApp());
}
