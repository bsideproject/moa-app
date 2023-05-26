import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:moa_app/utils/logger.dart';


class TokenRepository {
  const TokenRepository._();
  static TokenRepository instance = const TokenRepository._();

  static const storage = FlutterSecureStorage();

  static const String key = 'SecuredAuthToken';

  Future<void> setToken({required String token}) async {
    try {
      await storage.write(key:key, value:token);
    } catch (e) {
      logger.d(e);
    }
  }

  Future<void> removeToken() async {
    try {
      await storage.delete(key: key);
    } catch (e) {
      logger.d(e);
    }
  }

  Future<Object?> getToken() async {
    return await storage.read(key: key);
  }
}
