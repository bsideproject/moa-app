import 'package:flutter/material.dart';

import 'package:moa_app/constants/color_constants.dart';

class H1TextStyle extends TextStyle {
  const H1TextStyle()
      : super(
          fontSize: 22,
          height: 1.2,
          fontWeight: FontConstants.fontWeightBold,
          fontFamily: FontConstants.pretendard,
          color: AppColors.blackColor,
        );
}

class H2TextStyle extends TextStyle {
  const H2TextStyle()
      : super(
          fontSize: 20,
          fontWeight: FontConstants.fontWeightBold,
          fontFamily: FontConstants.pretendard,
        );
}

class H3TextStyle extends TextStyle {
  const H3TextStyle()
      : super(
          fontSize: 18,
          fontWeight: FontConstants.fontWeightBold,
          fontFamily: FontConstants.pretendard,
        );
}

class H4TextStyle extends TextStyle {
  const H4TextStyle()
      : super(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          fontFamily: FontConstants.pretendard,
        );
}

class H5TextStyle extends TextStyle {
  const H5TextStyle()
      : super(
          fontSize: 14,
          fontWeight: FontConstants.fontWeightBold,
          fontFamily: FontConstants.pretendard,
        );
}

class Body1TextStyle extends TextStyle {
  const Body1TextStyle()
      : super(
          fontSize: 14,
          fontWeight: FontConstants.fontWeightMedium,
          fontFamily: FontConstants.pretendard,
        );
}

class Body2TextStyle extends TextStyle {
  const Body2TextStyle()
      : super(
          fontSize: 19,
          fontWeight: FontConstants.fontWeightNormal,
          fontFamily: FontConstants.pretendard,
        );
}

class Hash1TextStyle extends TextStyle {
  const Hash1TextStyle()
      : super(
          fontSize: 16,
          fontWeight: FontConstants.fontWeightNormal,
          fontFamily: FontConstants.pretendard,
        );
}

class Hash2TextStyle extends TextStyle {
  const Hash2TextStyle()
      : super(
          fontSize: 10,
          fontWeight: FontConstants.fontWeightNormal,
          fontFamily: FontConstants.pretendard,
        );
}

class InputLabelTextStyle extends TextStyle {
  const InputLabelTextStyle()
      : super(
          fontSize: 14,
          fontWeight: FontConstants.fontWeightBold,
          fontFamily: FontConstants.pretendard,
          color: AppColors.blackColor,
        );
}

class FontConstants {
  //Font Weight
  static const String pretendard = 'Pretendard';

  static const FontWeight fontWeightBold = FontWeight.bold;
  static const FontWeight fontWeightNormal = FontWeight.normal;
  static const FontWeight fontWeightMedium = FontWeight.w500;
}
