import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  SecureStorage();
  late FlutterSecureStorage storage;
  init() async {
    storage = FlutterSecureStorage();
  }

  Future<void> writeData({required String key, required String value}) async {
    await storage.write(key: key, value: value);
  }

  Future<String?> readData({required String key}) async {
    final token = await storage.read(key: key);
    return token;
  }

  Future<void> deleteData({required String key}) async {
    await storage.delete(key: key);
  }

  Future<void> deleteAllData() async {
    await storage.deleteAll();
  }
}
