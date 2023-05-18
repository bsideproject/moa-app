
import 'dart:convert';
import 'dart:io';
import 'package:flutter_naver_login/flutter_naver_login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:moa_app/models/user_model.dart';


abstract class IAuthRepository {
  Future<UserModel?> login();
  Future<void> logout();
}

class GoogleAuthRepository implements IAuthRepository {

  // Singleton
  const GoogleAuthRepository._();
  static GoogleAuthRepository instance = const GoogleAuthRepository._();

  // Authentication API Instance
  static final _googleSignIn = GoogleSignIn();

  @override
  Future<UserModel?> login() async {

    var user = await _googleSignIn.signIn();

    if(user == null) { return null; }

    return UserModel(
      id:user.id,
      email: user.email,
      password: 'Secret',
    );
  }

  @override
  Future<void> logout() async {
    await _googleSignIn.disconnect();
  }

}

class KakaoAuthRepository implements IAuthRepository {
  // Singleton
  const KakaoAuthRepository._();
  static KakaoAuthRepository instance = const KakaoAuthRepository._();

  @override
  Future<UserModel?> login() async {
    try {
      var isInstalled = await isKakaoTalkInstalled();

      var token = isInstalled
          ? await UserApi.instance.loginWithKakaoTalk()
          : await UserApi.instance.loginWithKakaoAccount();


      var url = Uri.https('kapi.kakao.com', '/v2/user/me');

      var response = await http.get(
        url,
        headers: {
          HttpHeaders.authorizationHeader: 'Bearer ${token.accessToken}'
        },
      );

      var user = json.decode(response.body);

      return UserModel(
        id:user.id,
        email: user.kakao_account.email,
        password: 'Secret',
      );
    } catch (error) {
      return null;
    }
  }

  @override
  Future<void> logout() async {
  }
}


class NaverAuthRepository implements IAuthRepository {
  // Singleton
  const NaverAuthRepository._();
  static NaverAuthRepository instance = const NaverAuthRepository._();


  @override
  Future<UserModel?> login() async {
    NaverLoginResult user = await FlutterNaverLogin.logIn();
    if(user.status != NaverLoginStatus.loggedIn){
      return null;
    }
    return UserModel(
      id:user.account.id,
      email: user.account.email,
      password: 'Secret',
    );
  }

  @override
  Future<void> logout() async {
    await FlutterNaverLogin.logOut();
  }
}


class AppleAuthRepository implements IAuthRepository {
  // Singleton
  const AppleAuthRepository._();
  static AppleAuthRepository instance = const AppleAuthRepository._();

  // Authentication API Instance

  @override
  Future<UserModel?> login() async {
    return null;
  }

  @override
  Future<void> logout() async {
  }
}