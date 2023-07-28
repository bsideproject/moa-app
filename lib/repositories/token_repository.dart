import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:moa_app/utils/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class ITokenRepository {
  Future<void> setToken({required String token});
  Future<void> removeToken();
  Future<Object?> getToken();
}

class TokenRepository implements ITokenRepository {
  const TokenRepository._();
  static TokenRepository instance = const TokenRepository._();

  static const storage = FlutterSecureStorage();
  static const String key = 'SecuredAuthToken';

  static final Future<SharedPreferences> _prefs =
      SharedPreferences.getInstance();

  @override
  Future<void> setToken({required String token}) async {
    try {
      SharedPreferences prefs = await _prefs;
      await prefs.setString('token', token);
      if (!kIsWeb) {
        await storage.write(key: key, value: token);
      }
    } catch (e) {
      logger.d(e);
    }
  }

  @override
  Future<void> removeToken() async {
    try {
      SharedPreferences prefs = await _prefs;
      await prefs.remove('token');
      if (!kIsWeb) {
        await storage.delete(key: key);
      }
    } catch (e) {
      logger.d(e);
    }
  }

  @override
  Future<Object?> getToken() async {
    try {
      SharedPreferences prefs = await _prefs;
      var token = prefs.getString('token');
      if (token == null) {
        FlutterSecureStorage storage = const FlutterSecureStorage();
        await storage.deleteAll();

        return null;
      }

      if (!kIsWeb) {
        var token = await storage.read(key: key);
        return token;
      }
      return token;

      // todo refresh token 구현
    } catch (e) {
      logger.d(e);
    }
    return null;
  }
}
