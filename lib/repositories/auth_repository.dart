import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_naver_login/flutter_naver_login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:moa_app/repositories/token_repository.dart';
import 'package:moa_app/utils/api.dart';
import 'package:moa_app/utils/logger.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

abstract class IAuthRepository {
  Future<bool?> googleLogin();
  Future<bool?> kakaoLogin();
  Future<bool?> naverLogin();
  Future<bool?> appleLogin();
}

class AuthRepository implements IAuthRepository {
  const AuthRepository._();
  static AuthRepository instance = const AuthRepository._();

  @override
  Future<bool?> googleLogin() async {
    var googleSignIn = GoogleSignIn();
    try {
      var user = await googleSignIn.signIn();

      if (user != null) {
        var token = await user.authentication;
        var res = await dio.post(
          '/api/v1/user/oauth',
          data: {
            'platform': 'google',
            'id': user.id,
            'email': user.email,
          },
          options: Options(
            headers: {'oauth-token': token.idToken},
          ),
        );

        if (res.data['token'].isNotEmpty) {
          await TokenRepository.instance.setToken(token: res.data['token']);
          return true;
        }
      }

      return false;
    } catch (e) {
      logger.d(e);
    }
    return null;
  }

  @override
  Future<bool?> kakaoLogin() async {
    try {
      var isInstalled = await isKakaoTalkInstalled();

      var token = isInstalled
          ? await UserApi.instance.loginWithKakaoTalk()
          : await UserApi.instance.loginWithKakaoAccount();
      Dio kakaoDio = Dio();

      var response = await kakaoDio.get(
        'https://kapi.kakao.com/v2/user/me',
        options: Options(
          headers: {
            HttpHeaders.authorizationHeader: 'Bearer ${token.accessToken}'
          },
        ),
      );

      if (response.data.isNotEmpty) {
        var res = await dio.post(
          '/api/v1/user/oauth',
          data: {
            'platform': 'kakao',
            'id': response.data['id'],
            'email': response.data['kakao_account']['email'],
          },
          options: Options(
            headers: {'oauth-token': token.accessToken},
          ),
        );

        if (res.data['token'].isNotEmpty) {
          await TokenRepository.instance.setToken(token: res.data['token']);
          return true;
        }
      }
      return false;
    } catch (e) {
      logger.d(e);
    }
    return null;
  }

  @override
  Future<bool?> naverLogin() async {
    try {
      var user = await FlutterNaverLogin.logIn();
      var response = await FlutterNaverLogin.currentAccessToken;

      if (user.status != NaverLoginStatus.loggedIn) {
        return false;
      }

      if (response.accessToken.isNotEmpty) {
        var res = await dio.post(
          '/api/v1/user/oauth',
          data: {
            'platform': 'naver',
            'id': user.account.id,
            'email': user.account.email,
          },
          options: Options(
            headers: {'oauth-token': response.accessToken},
          ),
        );

        if (res.data['token'].isNotEmpty) {
          await TokenRepository.instance.setToken(token: res.data['token']);
          return true;
        }
      }
      return false;
    } catch (e) {
      logger.d(e);
    }
    return null;
  }

  @override
  Future<bool?> appleLogin() async {
    try {
      var credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      if (credential.identityToken != null &&
          credential.userIdentifier != null) {
        var res = await dio.post(
          '/api/v1/user/oauth',
          data: {
            'platform': 'apple',
            'id': credential.userIdentifier,
            'email': credential.email,
          },
          options: Options(
            headers: {'oauth-token': credential.identityToken},
          ),
        );

        if (res.data['token'].isNotEmpty) {
          await TokenRepository.instance.setToken(token: res.data['token']);
          return true;
        }
      }
      return false;
    } catch (e) {
      logger.d(e);
    }
    return null;
  }
}
