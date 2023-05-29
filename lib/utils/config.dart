import 'package:moa_app/utils/tools.dart';

class Config {
  factory Config() {
    return _singleton;
  }

  Config._internal();
  static final Config _singleton = Config._internal();

  String get nativeAppKey => env('NATIVE_APP_KEY');
  String get javaScriptAppKey => env('JAVASCRIPT_APP_KEY');
  String get baseUrl => env('BASE_URL');
  String get webFcmKey => env('WEB_FCM_KEY');
}
