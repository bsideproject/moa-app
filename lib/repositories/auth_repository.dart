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
  AuthDto.fail(): isSuccess=false;

  AuthDto.success({
    required String this.id,
    required String this.email,
    required String this.token,
    required String this.platform,
  }): isSuccess=true;

  String? id;
  String? email;
  String? token;
  String? platform;
  final bool isSuccess;

}


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
    var googleSignIn = GoogleSignIn(
        signInOption: SignInOption.standard,
        clientId: Config().googleClientId,

    );

    if (kIsWeb) {
      // TODO: signIn 이 WEB에서 처음에 안되서 다시 로그인 시도 해야 로그인 되는 현상이 있음
      // 이거 문제가 뭔지 모르겠음...
      user = await googleSignIn.signInSilently();
      user ??= await googleSignIn.signIn();
    } else {
      user = await googleSignIn.signIn();
    }

    if (user == null) { return ; }

    var token = await user.authentication;

    AuthDto authDto = token.idToken != null ?
      AuthDto.success(
        platform: 'google',
        id: user.id,
        email: user.email,
        token: token.idToken!,):
      AuthDto.fail();

      await _loginAndSetTokenWith(authDto);
  }

  @override
  Future<void> kakaoLogin() async {

    AuthDto authDto = kIsWeb ?
      await _kakaoLoginWeb():
      await _kakaoLoginMobile();

    if (authDto.isSuccess){
      await _loginAndSetTokenWith(authDto);
    }
  }

  Future<AuthDto> _kakaoLoginWeb() async {

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
          HttpHeaders.contentTypeHeader:
          'application/x-www-form-urlencoded;charset=utf-8'
        },
      ),
    );

    if (respToken.statusCode != 200) {
      return AuthDto.fail();
    }

    return await _kakaoRequestUserInfo(
        token: respToken.data['access_token']
    );
  }

  Future<AuthDto> _kakaoLoginMobile() async {

    var isInstalled = await isKakaoTalkInstalled();

    OAuthToken oauthToken = isInstalled
        ? await UserApi.instance.loginWithKakaoTalk()
        : await UserApi.instance.loginWithKakaoAccount();

    return await _kakaoRequestUserInfo(
        token: oauthToken.accessToken
    );
  }

  Future<AuthDto> _kakaoRequestUserInfo({
    required String token }) async {

    var response = await Dio().get(
      'https://kapi.kakao.com/v2/user/me',
      options: Options(
        headers: {
          HttpHeaders.authorizationHeader: 'Bearer $token'
        },
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
  Future<void> naverLogin() async {
    AuthDto authDto = kIsWeb ?
      await _naverLoginWeb():
      await _naverLoginMobile();

    await _loginAndSetTokenWith(authDto);
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
    var code = Uri
        .parse(resultAuth)
        .queryParameters['code'];

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
        token: resToken.data['access_token'],
        platform: 'naver',
    );
  }

  Future<AuthDto> _naverLoginMobile() async {
    late NaverAccessToken token;
    late NaverLoginResult user;

    // Non web Naver login option
    user = await FlutterNaverLogin.logIn();
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
  Future<void> appleLogin() async {
    var credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
        // TODO: Apple login은 clientId가 없어 아직 테스트 못해봄
        webAuthenticationOptions: kIsWeb ? WebAuthenticationOptions(
            clientId: Config().appleClientId,
            redirectUri: Uri.parse(Config().socialRedirectUrl)
        ) : null
    );

    if (credential.identityToken != null && credential.userIdentifier != null) {
      await _loginAndSetTokenWith(AuthDto.success(
        id: credential.userIdentifier!,
        email: credential.email!,
        token: credential.identityToken!,
        platform: 'apple',
      ));
    }
  }

  Future<void> _loginAndSetTokenWith(AuthDto authDto) async {
    if(!authDto.isSuccess) {
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
      throw 'Login failed with moa-spring with ${res.statusCode} cdoe';
    }

    await TokenRepository.instance
        .setToken(token: res.data['access_token']);

    // 로그인 성공
    logger.d(
        'login success\n'
        'platform: ${authDto.platform}\n'
        'id      : ${authDto.id}\n'
        'email   : ${authDto.email}\n'
        'token   : ${authDto.token}\n'
    );
  }


}
