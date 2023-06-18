import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_naver_login/flutter_naver_login.dart';
import 'package:flutter_web_auth/flutter_web_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:moa_app/repositories/token_repository.dart';
import 'package:moa_app/utils/api.dart';
import 'package:moa_app/utils/config.dart';
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

    late String? token;
    if (kIsWeb) {

      // Kakao web authentication
      var respAuth = await FlutterWebAuth.authenticate(
        url: Uri.https('kauth.kakao.com','oauth/authorize', {
          'client_id': Config().kakaoClientId,
          'redirect_uri': Config().socialRedirectUrl,
          'response_type': 'code',
          'state': const Uuid().v4()
        }).toString(),
        callbackUrlScheme: 'moaapp',
      );

      // Handling Authentication Exception
      String? authCode = Uri.parse(respAuth).queryParameters['code'];
      if (authCode == null){
        String resp = Uri.parse(respAuth).toString();
        throw 'Fail authentication with kakao\n- $resp';
      }

      // Request Token
      var respToken = await Dio().post(
        'https://kauth.kakao.com/oauth/token',
        data: {
          'grant_type': 'authorization_code',
          'client_id': Config().kakaoClientId,
          'redirect_uri': Config().socialRedirectUrl,
          'code': authCode,
        },
        options: Options(
          headers: {
            HttpHeaders.contentTypeHeader: 'application/x-www-form-urlencoded;charset=utf-8'
          },
        ),
      );

      token = respToken.data['access_token'];

    } else {
      var isInstalled = await isKakaoTalkInstalled();
      OAuthToken oauthToken = isInstalled
          ? await UserApi.instance.loginWithKakaoTalk()
          : await UserApi.instance.loginWithKakaoAccount();
      token = oauthToken.accessToken;
    }

    if (token != null){
      var response = await Dio().get(
        'https://kapi.kakao.com/v2/user/me',
        options: Options(
          headers: {
            HttpHeaders.authorizationHeader: 'Bearer $token'
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
              'oauth-token': token,
            },
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
  Future<void> naverLogin() async {
    late NaverAccessToken token;
    late NaverLoginResult user;
    if (kIsWeb) {
      // Web NAVER social login

      // Present the dialog to the user
      var resultAuth = await FlutterWebAuth.authenticate(
        url: Uri.https('nid.naver.com','oauth2.0/authorize', {
          'client_id': Config().naverClientId,
          'redirect_uri': Config().socialRedirectUrl,
          'response_type': 'code',
          'state': const Uuid().v4()
        }).toString(),
        callbackUrlScheme: 'moaapp',
      );
      // Extract code from resulting url
      // result = http://localhost:8080/sign-in?code=dXi4LtnBGvkWwupyr7&state=test
      var code = Uri.parse(resultAuth).queryParameters['code'];

      var resToken = await Dio().get(
          '${Config().moaDjangoUrl}/proxy_auth/naver_token',
          queryParameters: {
            'client_id': Config().naverClientId,
            'client_secret': Config().naverClientSecret,
            'grant_type': 'authorization_code',
            'code': code,
            'state': const Uuid().v4(),
          },
      );

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
      webAuthenticationOptions: kIsWeb? WebAuthenticationOptions(
        clientId: 'asd',
        redirectUri: Uri.parse(Config().socialRedirectUrl)
      ) : null
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
