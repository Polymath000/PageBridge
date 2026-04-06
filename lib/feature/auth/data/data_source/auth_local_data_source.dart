import 'package:pagebridge/core/constants/constants.dart';
import 'package:pagebridge/core/database/cache/secure_storage.dart';

abstract class AuthLocalDataSource {
  Future<void> saveToken(String token);
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  const AuthLocalDataSourceImpl();

  @override
  Future<void> saveToken(String token) async {
    await SecureStorage.writeData(key: tokenKey, value: token);
  }
}
