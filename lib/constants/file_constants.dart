import 'package:flutter/material.dart' show AssetImage;

class Assets {
  const Assets._();

  static const _icPath = 'assets/icons';
  static const _imgPath = 'assets/images';

  static AssetImage logo = const AssetImage('$_icPath/logo.png');
  static AssetImage dooboolab = const AssetImage('$_imgPath/dooboolab.png');
  static AssetImage dooboolabLogo = const AssetImage('$_imgPath/logo.png');
  static AssetImage kakao = const AssetImage('$_imgPath/kakao.png');
  static AssetImage naver = const AssetImage('$_imgPath/naver.png');
  static AssetImage google = const AssetImage('$_imgPath/google.png');
  static AssetImage apple = const AssetImage('$_imgPath/apple.png');
}

class Svgs {
  const Svgs._();

  // static const _svgPath = 'assets/svgs';
}
