import 'package:flutter/material.dart';
import 'package:quicknotion/main-app.dart';
import 'package:quicknotion/core/database/cache/secure_storage.dart';

void main() {
  SecureStorage().init();
  runApp(QuickNotionApp());
}
