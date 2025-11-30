import 'package:flutter/material.dart';
import 'package:quicknotion/core/database/cache/secure_storage.dart';
import 'package:quicknotion/core/utls/setup_service_locator_getit.dart';
import 'package:quicknotion/main_app.dart';

void main() {
  SecureStorage.init();
  setUpServiceLocator();
  runApp(QuickNotionApp());
}
