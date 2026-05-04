import 'package:pagebridge/core/constants/constants.dart';
import 'package:pagebridge/core/database/cache/secure_storage.dart';
import 'package:pagebridge/core/services/shared_preferences_singleton.dart';

import 'package:pagebridge/feature/auth/domain/entities/auth_token_entity.dart';

abstract class AuthLocalDataSource {
  Future<void> saveToken(AuthTokenEntity token);
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  const AuthLocalDataSourceImpl();

  @override
  Future<void> saveToken(AuthTokenEntity token) async {
    await SecureStorage.writeData(key: tokenKey, value: token.accessToken);
    if (token.workspaceName != null) {
      await SharedPreferencesSingleton.setString('workspaceName', token.workspaceName!);
    }
    if (token.workspaceIcon != null) {
      await SharedPreferencesSingleton.setString('workspaceIcon', token.workspaceIcon!);
    }
    if (token.ownerName != null) {
      await SharedPreferencesSingleton.setString('ownerName', token.ownerName!);
    }
    if (token.ownerAvatarUrl != null) {
      await SharedPreferencesSingleton.setString('ownerAvatarUrl', token.ownerAvatarUrl!);
    }
  }
}
