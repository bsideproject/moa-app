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

class AuthDto {
  // 임시로Moa back-end 로 보내기 위한 데이터를 관리하는 객체
  // 성공, 실패에 대한 응답을 담고 있다.
  AuthDto.fail() : isSuccess = false;

  AuthDto.success({
    required String this.id,
    required String this.email,
    required String this.token,
    required String this.platform,
  }) : isSuccess = true;

  String? id;
  String? email;
  String? token;
  String? platform;
  final bool isSuccess;
}

abstract class IAuthRepository {
  Future<String?> googleLogin();
  Future<String?> kakaoLogin();
  Future<String?> naverLogin();
  Future<String?> appleLogin();
}

class AuthRepository implements IAuthRepository {
  const AuthRepository._();
  static AuthRepository instance = const AuthRepository._();

  @override
  Future<String?> googleLogin() async {
    late GoogleSignInAccount? user;
    if (kIsWeb) {
      var googleSignIn = GoogleSignIn(
        signInOption: SignInOption.standard,
        clientId: Config().googleClientId,
      );
      // !! https 에서만 googleSignIn.signIn(); 가능
      // https://stackoverflow.com/questions/75514725/flutter-error-code-xmlhttprequest-error
      var isSignedIn = await googleSignIn.isSignedIn();
      if (isSignedIn) {
        user = await googleSignIn.signInSilently();
      } else {
        user = await googleSignIn.signIn();
      }
    } else {
      var googleSignIn = GoogleSignIn();
      user = await googleSignIn.signIn();
    }

    if (user == null) {
      return null;
    }

    var token = await user.authentication;

    AuthDto authDto = token.idToken != null
        ? AuthDto.success(
            platform: 'google',
            id: user.id,
            email: user.email,
            token: token.idToken!,
          )
        : AuthDto.fail();

    return await _loginAndSetTokenWith(authDto);
  }

  @override
  Future<String?> kakaoLogin() async {
    AuthDto authDto =
        kIsWeb ? await _kakaoLoginWeb() : await _kakaoLoginMobile();

    if (authDto.isSuccess) {
      return await _loginAndSetTokenWith(authDto);
    }
    return null;
  }

  Future<AuthDto> _kakaoLoginWeb() async {
    // Kakao web authentication
    var respAuth = await FlutterWebAuth.authenticate(
      url: Uri.https('kauth.kakao.com', 'oauth/authorize', {
        'client_id': Config().kakaoClientId,
        'redirect_uri': Config().socialRedirectUrl,
        'response_type': 'code',
        'state': const Uuid().v4()
      }).toString(),
      callbackUrlScheme: 'moaapp',
    );

    // Handling Authentication Exception
    String? authCode = Uri.parse(respAuth).queryParameters['code'];
    if (authCode == null) {
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
          HttpHeaders.contentTypeHeader:
              'application/x-www-form-urlencoded;charset=utf-8'
        },
      ),
    );

    if (respToken.statusCode != 200) {
      return AuthDto.fail();
    }

    return await _kakaoRequestUserInfo(token: respToken.data['refresh_token']);
  }

  Future<AuthDto> _kakaoLoginMobile() async {
    var isInstalled = await isKakaoTalkInstalled();

    OAuthToken oauthToken = isInstalled
        ? await UserApi.instance.loginWithKakaoTalk()
        : await UserApi.instance.loginWithKakaoAccount();

    return await _kakaoRequestUserInfo(token: oauthToken.accessToken);
  }

  Future<AuthDto> _kakaoRequestUserInfo({required String token}) async {
    var response = await Dio().get(
      'https://kapi.kakao.com/v2/user/me',
      options: Options(
        headers: {HttpHeaders.authorizationHeader: 'Bearer $token'},
      ),
    );

    if (response.data.isNotEmpty) {
      return AuthDto.success(
        id: response.data['id'].toString(),
        email: response.data['kakao_account']['email'],
        token: token,
        platform: 'kakao',
      );
    }
    return AuthDto.fail();
  }

  @override
  Future<String?> naverLogin() async {
    AuthDto authDto =
        kIsWeb ? await _naverLoginWeb() : await _naverLoginMobile();

    return await _loginAndSetTokenWith(authDto);
  }

  Future<AuthDto> _naverLoginWeb() async {
    // Present the dialog to the user
    var resultAuth = await FlutterWebAuth.authenticate(
      url: Uri.https('nid.naver.com', 'oauth2.0/authorize', {
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

    if (resToken.statusCode != 200) {
      return AuthDto.fail();
    }

    return AuthDto.success(
      id: resToken.data['id'],
      email: resToken.data['email'],
      token: resToken.data['refresh_token'],
      platform: 'naver',
    );
  }

  Future<AuthDto> _naverLoginMobile() async {
    late NaverAccessToken token;
    late NaverLoginResult user;

    // Non web Naver login option
    user = await FlutterNaverLogin.logIn().timeout(
      const Duration(seconds: 8),
      onTimeout: () => throw '로그인 시간이 초과되었습니다. 다시 시도해주세요.',
    );

    token = await FlutterNaverLogin.currentAccessToken;
    if (user.status != NaverLoginStatus.loggedIn) {
      return AuthDto.fail();
    }

    return AuthDto.success(
      id: user.account.id,
      email: user.account.email,
      token: token.accessToken,
      platform: 'naver',
    );
  }

  @override
  Future<String?> appleLogin() async {
    var credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
        // TODO, redirect_url 이 localhost면 로그인 안됨
        // https://developer.apple.com/documentation/sign_in_with_apple/sign_in_with_apple_js/incorporating_sign_in_with_apple_into_other_platforms
        webAuthenticationOptions: kIsWeb
            ? WebAuthenticationOptions(
                clientId: Config().appleClientId,
                redirectUri: Uri.parse(Config().socialRedirectUrl),
              )
            : null);

    if (credential.identityToken != null && credential.userIdentifier != null) {
      return await _loginAndSetTokenWith(AuthDto.success(
        id: credential.userIdentifier!,
        email: credential.email ?? '',
        token: credential.identityToken!,
        platform: 'apple',
      ));
    }
    return null;
  }

  Future<String> _loginAndSetTokenWith(AuthDto authDto) async {
    if (!authDto.isSuccess) {
      throw 'Login failed with oauth provider';
    }

    var res = await dio.post(
      '/api/v1/user/oauth',
      data: {
        'platform': authDto.platform,
        'id': authDto.id,
        'email': authDto.email,
      },
      options: Options(
        headers: {'oauth-token': authDto.token},
      ),
    );

    if (res.statusCode != 200) {
      throw 'Login failed with moa-spring with ${res.statusCode} code';
    }

    await TokenRepository.instance.setToken(token: res.data['refresh_token']);

    // 로그인 성공
    logger.d('login success\n'
        'platform: ${authDto.platform}\n'
        'id      : ${authDto.id}\n'
        'email   : ${authDto.email}\n'
        'token   : ${authDto.token}\n');
    return res.data['refresh_token'];
  }
}
