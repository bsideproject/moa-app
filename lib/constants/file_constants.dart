import 'package:flutter/material.dart' show AssetImage;

class Assets {
  const Assets._();

  static const _icPath = 'assets/icons';
  static const _imgPath = 'assets/images';

  static AssetImage logo = const AssetImage('$_icPath/logo.png');
  static AssetImage home = const AssetImage('$_icPath/home.png');
  static AssetImage setting = const AssetImage('$_icPath/setting.png');
  static AssetImage folderIcon = const AssetImage('$_icPath/folderIcon.png');
  static AssetImage hashtag = const AssetImage('$_icPath/hashtag.png');

  static AssetImage kakao = const AssetImage('$_imgPath/kakao.png');
  static AssetImage naver = const AssetImage('$_imgPath/naver.png');
  static AssetImage google = const AssetImage('$_imgPath/google.png');
  static AssetImage apple = const AssetImage('$_imgPath/apple.png');
  static AssetImage folder = const AssetImage('$_imgPath/folder.png');
  static AssetImage moaBannerImg =
      const AssetImage('$_imgPath/moaBannerImg.png');
  static AssetImage moaSwitchImg =
      const AssetImage('$_imgPath/moaSwitchImg.png');
  static AssetImage moaCommentImg =
      const AssetImage('$_imgPath/moaCommentImg.png');
}

class Svgs {
  const Svgs._();

  // static const _svgPath = 'assets/svgs';
}
