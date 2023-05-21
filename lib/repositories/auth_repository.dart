import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_naver_login/flutter_naver_login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:moa_app/models/user_model.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

abstract class IAuthRepository {
  Future<UserModel?> googleLogin();
  Future<UserModel?> kakaoLogin();
  Future<UserModel?> naverLogin();
  Future<UserModel?> appleLogin();
  Future<void> googleLogout();
  Future<void> kakaoLogout();
  Future<void> naverLogout();
  Future<void> appleLogout();
}

class AuthRepository implements IAuthRepository {
  const AuthRepository._();
  static AuthRepository instance = const AuthRepository._();

  static final _googleSignIn = GoogleSignIn();

  @override
  Future<UserModel?> googleLogin() async {
    try {
      var user = await _googleSignIn.signIn();

      if (user == null) {
        return null;
      }

      return UserModel(
        id: user.id,
        email: user.email,
      );
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> googleLogout() async {
    await _googleSignIn.disconnect();
  }

  @override
  Future<UserModel?> kakaoLogin() async {
    try {
      var isInstalled = await isKakaoTalkInstalled();

      var token = isInstalled
          ? await UserApi.instance.loginWithKakaoTalk()
          : await UserApi.instance.loginWithKakaoAccount();

      var dio = Dio();

      var response = await dio.get(
        'https://kapi.kakao.com/v2/user/me',
        options: Options(
          headers: {
            HttpHeaders.authorizationHeader: 'Bearer ${token.accessToken}'
          },
        ),
      );

      if (response.data != null) {
        return UserModel.fromJson({
          'id': response.data['id'].toString(),
          'email': response.data['kakao_account']['email'],
        });
      }
      return null;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> kakaoLogout() async {
    await UserApi.instance.logout();
  }

  @override
  Future<UserModel?> naverLogin() async {
    try {
      var user = await FlutterNaverLogin.logIn();
      var res = await FlutterNaverLogin.currentAccessToken;

      if (user.status != NaverLoginStatus.loggedIn) {
        return null;
      }

      if (res.accessToken.isNotEmpty) {
        return UserModel(
          id: user.account.id,
          email: user.account.email,
        );
      }
      return null;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> naverLogout() async {
    await FlutterNaverLogin.logOut();
  }

  @override
  Future<UserModel?> appleLogin() async {
    try {
      var credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      if (credential.identityToken != null &&
          credential.userIdentifier != null) {
        return UserModel(
          id: credential.userIdentifier!,
          email: credential.email ?? '',
        );
      }
      return null;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> appleLogout() async {}
}
