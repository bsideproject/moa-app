import 'package:flutter/foundation.dart';


class MyPlatform {
  factory MyPlatform() {
    return _singleton;
  }

  MyPlatform._internal();
  static final MyPlatform _singleton = MyPlatform._internal();

  bool get isAndroid => defaultTargetPlatform == TargetPlatform.android;
  bool get isIos     => defaultTargetPlatform == TargetPlatform.iOS;
  bool get isLinux   => defaultTargetPlatform == TargetPlatform.linux;
  bool get isMacOS   => defaultTargetPlatform == TargetPlatform.macOS;
  bool get isWindows => defaultTargetPlatform == TargetPlatform.windows;

  bool get isWeb     => kIsWeb;
  bool get isDesktop => isWindows || isMacOS;
  bool get isMobile  => isAndroid || isIos;
}
