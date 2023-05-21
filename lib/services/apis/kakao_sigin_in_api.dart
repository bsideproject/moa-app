import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';

class KakaoSignInApi {

  static Future<dynamic> login() async {
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

      var profileInfo = json.decode(response.body);

      return profileInfo;
    } catch (error) {
      return null;
    }

    // {
    //    id: 2794665790,
    //    connected_at: 2023-05-17T15:40:12Z,
    //    properties: {
    //      nickname: Paul.Kim,
    //      profile_image: http://k.kakaocdn.net/dn/xGZq0/btsdYhaIFE1/wOiVsdewZMlv2xqddgv581/img_640x640.jpg,
    //      thumbnail_image: http://k.kakaocdn.net/dn/xGZq0/btsdYhaIFE1/wOiVsdewZMlv2xqddgv581/img_110x110.jpg
    //    },
    //    kakao_account: {
    //      profile_nickname_needs_agreement: false,
    //      profile_image_needs_agreement: false,
    //      profile: {
    //        nickname: Paul.Kim,
    //        thumbnail_image_url: http://k.kakaocdn.net/dn/xGZq0/btsdYhaIFE1/wOiVsdewZMlv2xqddgv581/img_110x110.jpg,
    //        profile_image_url: http://k.kakaocdn.net/dn/xGZq0/btsdYhaIFE1/wOiVsdewZMlv2xqddgv581/img_640x640.jpg,
    //        is_default_image: false
    //      },
    //      has_email: true,
    //      email_needs_agreement: false,
    //      is_email_valid: true,
    //      is_email_verified: true,
    //      email: mskimrox@gmail.com,
    //      has_gender: true,
    //      gender_needs_agreement: false,
    //      gender: male
    //    }
    //  }
  }

  static Future logout() => UserApi.instance.logout();

}

