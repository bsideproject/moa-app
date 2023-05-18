import 'package:flutter_naver_login/flutter_naver_login.dart';

class NaverSignInApi {

  static Future<NaverLoginResult> login () => FlutterNaverLogin.logIn();
  // {
  //    status: NaverLoginStatus.loggedIn,
  //    account: {
  //      nickname: Paul_Kim,
  //      id: W1kAI5gVd4TKxoXl7qpXq3y8og-tH6QYVT6ufBIIJEU,
  //      name: 김명석,
  //      email: 1rlaaudtjr@jr.naver.com,
  //      gender: M,
  //      age: 30-39,
  //      birthday: 01-15,
  //      birthyear: 1993,
  //      profileImage: https://phinf.pstatic.net/contact/20180102_256/15148578169016oBO4_JPEG/image.jpg,
  //      mobile: 010-2819-1202,
  //      mobileE164:
  //    },
  //    errorMessage: ,
  //    accessToken: {
  //      accessToken: ,
  //      refreshToken: ,
  //      expiresAt: ,
  //      tokenType:
  //     }
  //   }
  static Future logout() => FlutterNaverLogin.logOut();

}

