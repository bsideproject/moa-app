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
      if (kIsWeb) {
        SharedPreferences prefs = await _prefs;
        await prefs.setString('token', token);
        return;
      }
      await storage.write(key: key, value: token);
    } catch (e) {
      logger.d(e);
    }
  }

  @override
  Future<void> removeToken() async {
    try {
      if (kIsWeb) {
        SharedPreferences prefs = await _prefs;
        await prefs.remove('token');
        return;
      }
      await storage.delete(key: key);
    } catch (e) {
      logger.d(e);
    }
  }

  @override
  Future<Object?> getToken() async {
    try {
      if (kIsWeb) {
        SharedPreferences prefs = await _prefs;
        var token = prefs.getString('token');
        return token;
      }
      var token = await storage.read(key: key);
      return token;

      // todo refresh token 구현
      // var testAdminToken =
      //     'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJhZG1pbkBnbWFpbC5jb20iLCJpZCI6IjUyNThkYzA3LWMxMDItNDg0NC04Yzk1LWM3ODY4YWYzY2M2YiIsImV4cCI6MzE1NTY5MDY3NDE4NDI3MiwiaWF0IjoxNjg3NzQzOTUzfQ.rZtKeIymBoDd9Z2iLMEuQrTUeCmgZyKwlYU5imxVdpo';
      // return testAdminToken;
    } catch (e) {
      logger.d(e);
    }
    return null;
  }
}
