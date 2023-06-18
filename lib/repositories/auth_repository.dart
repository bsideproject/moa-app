import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_naver_login/flutter_naver_login.dart';
import 'package:flutter_web_auth/flutter_web_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:moa_app/repositories/token_repository.dart';
import 'package:moa_app/utils/api.dart';
import 'package:moa_app/utils/logger.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:uuid/uuid.dart';

abstract class IAuthRepository {
  Future<void> googleLogin();
  Future<void> kakaoLogin();
  Future<void> naverLogin();
  Future<void> appleLogin();
}

class AuthRepository implements IAuthRepository {
  const AuthRepository._();
  static AuthRepository instance = const AuthRepository._();

  @override
  Future<void> googleLogin() async {
    late GoogleSignInAccount? user;
    var googleSignIn = GoogleSignIn();

    if (kIsWeb) {
      user = await googleSignIn.signInSilently();
      user ??= await googleSignIn.signIn();
    } else {
      user = await googleSignIn.signIn();
    }

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

      if (res.data['access_token'].isNotEmpty) {
        await TokenRepository.instance
            .setToken(token: res.data['access_token']);
      }
    }
  }

  @override
  Future<void> kakaoLogin() async {
    late OAuthToken token;
    if (kIsWeb) {
      token = await UserApi.instance.loginWithKakaoAccount();
    } else {
      var isInstalled = await isKakaoTalkInstalled();

      token = isInstalled
          ? await UserApi.instance.loginWithKakaoTalk()
          : await UserApi.instance.loginWithKakaoAccount();
    }
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
          headers: {
            'oauth-token': token.accessToken,
          },
        ),
      );

      if (res.data['access_token'].isNotEmpty) {
        await TokenRepository.instance
            .setToken(token: res.data['access_token']);
      }
    }
  }

  @override
  Future<void> naverLogin() async {
    late NaverAccessToken token;
    late NaverLoginResult user;
    if (kIsWeb) {
      // Web NAVER social login


      // Present the dialog to the user
      var resultAuth = await FlutterWebAuth.authenticate(
        url: Uri.https('nid.naver.com','oauth2.0/authorize', {
          'client_id': 'K10uUCEMBAnAY0ZtJMeo',
          // TODO: 배포 시, 도메인 설정 해줘야 함
          'redirect_uri': 'http://localhost:8080/sign-in',
          'response_type': 'code',
          'state': const Uuid().v4()
        }).toString(),
        callbackUrlScheme: 'moaapp',
      );
      // Extract code from resulting url
      // result = http://localhost:8080/sign-in?code=dXi4LtnBGvkWwupyr7&state=test
      var code = Uri.parse(resultAuth).queryParameters['code'];



      logger.d(code);
      var resToken = await Dio().get(
          'http://moa.gomj.kr:6001/proxy_auth/naver_token',
          queryParameters: {
            // TODO: 이거 숨겨야 함
            'client_id': 'K10uUCEMBAnAY0ZtJMeo',
            'client_secret': 'qtCW1qORKI',
            'grant_type': 'authorization_code',
            'code': code,
            'state': const Uuid().v4(),
          },
      );

      logger.d(resToken.data);

      if (resToken.statusCode==200) {
        var res = await dio.post(
          '/api/v1/user/oauth',
          data: {
            'platform': 'naver',
            'id': resToken.data['id'],
            'email': resToken.data['email'],
          },
          options: Options(
            headers: {'oauth-token': resToken.data['access_token']},
          ),
        );

        if (res.data['access_token'].isNotEmpty) {
          await TokenRepository.instance
              .setToken(token: res.data['access_token']);
        }
      }

    } else {
      // Non web Naver login option
      user = await FlutterNaverLogin.logIn();
      token = await FlutterNaverLogin.currentAccessToken;
      if (user.status != NaverLoginStatus.loggedIn) {
        return;
      }

      if (token.accessToken.isNotEmpty) {
        var res = await dio.post(
          '/api/v1/user/oauth',
          data: {
            'platform': 'naver',
            'id': user.account.id,
            'email': user.account.email,
          },
          options: Options(
            headers: {'oauth-token': token.accessToken},
          ),
        );

        if (res.data['access_token'].isNotEmpty) {
          await TokenRepository.instance
              .setToken(token: res.data['access_token']);
        }
      }
    }
  }

  @override
  Future<void> appleLogin() async {
    var credential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
    );

    if (credential.identityToken != null && credential.userIdentifier != null) {
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

      if (res.data['access_token'].isNotEmpty) {
        await TokenRepository.instance
            .setToken(token: res.data['access_token']);
      }
    }
  }
}
