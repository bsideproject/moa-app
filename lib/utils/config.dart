import 'package:moa_app/utils/tools.dart';

class Config {
  factory Config() {
    return _singleton;
  }

  Config._internal();
  static final Config _singleton = Config._internal();

  // Social Login Secret Keys
  // 1. 구글
  String get googleClientId => env('GOOGLE_CLIENT_ID');
  String get googleClientSecret => env('GOOGLE_CLIENT_SECRET');
  // 2. 카카오
  String get nativeAppKey => env('NATIVE_APP_KEY');
  String get javaScriptAppKey => env('JAVASCRIPT_APP_KEY');
  String get kakaoClientId => env('KAKAO_CLIENT_ID');
  // 3. 네이버
  String get naverClientId => env('NAVER_CLIENT_ID');
  String get naverClientSecret => env('NAVER_CLIENT_SECRET');
  // 4. 애플
  String get appleClientId => env('APPLE_CLIENT_ID');
  // 5. FCM
  String get webFcmKey => env('WEB_FCM_KEY');
  // 웹 로그인 시, Redirect 할 URL
  String get socialRedirectUrl => env('SOCIAL_REDIRECT_URL');

  // Front URL
  String get frontUrl => env('FRONT_URL');
  // Backends URL
  // Moa-Spring
  String get baseUrl => env('BASE_URL');
  // Moa-Django
  String get moaDjangoUrl => env('MOA_DJANGO_URL');
}
