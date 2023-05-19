import 'package:flutter/material.dart';

class TitleTextStyle extends TextStyle {
  const TitleTextStyle()
      : super(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        );
}

class NavigationTitleTextStyle extends TextStyle {
  const NavigationTitleTextStyle()
      : super(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        );
}

class SubTitleTextStyle extends TextStyle {
  const SubTitleTextStyle()
      : super(
          fontSize: 14,
        );
}

class InputLabelTextStyle extends TextStyle {
  const InputLabelTextStyle()
      : super(
          fontSize: 14,
          fontWeight: FontWeight.bold,
        );
}

class InputHintTextStyle extends TextStyle {
  const InputHintTextStyle()
      : super(
          fontSize: 14,
          fontWeight: FontWeight.bold,
        );
}

class FontSizeWeightConstants {
  //Font Size
  static const double fontSize14 = 14.0;
  static const double fontSize20 = 20.0;
  static const double fontSize24 = 24.0;

  //Font Weight
  static const FontWeight fontWeightBold = FontWeight.bold;
  static const FontWeight fontWeightNormal = FontWeight.normal;
  static const FontWeight fontWeight500 = FontWeight.w500;
}
