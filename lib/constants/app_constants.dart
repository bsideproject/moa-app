import 'package:flutter/material.dart';
import 'package:moa_app/constants/color_constants.dart';

class AppConstants {
  static const String replaceableText = 'file://';
  static const List<String> imageExtensions = ['jpg', 'png', 'jpeg', 'gif'];

  static const appName = 'moa_app';

  static const mobileMaxWith = 850;
  static const tableMaxWith = 1100;

  static const imageLogo = 'res/images/logo.png';
}

class Breakpoints {
  static const sm = 640.0;
  static const md = 768.0;
  static const lg = 1024.0;
  static const xl = 1280.0;
  static const xxl = 1536.0;
}

List<Color> folderColors = [
  AppColors.folderColorFAE3CB,
  AppColors.folderColorFFD4D7,
  AppColors.folderColorD7E5FC,
  AppColors.folderColorECD8F3,
];
