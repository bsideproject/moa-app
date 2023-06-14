import 'package:flutter/material.dart';

import 'package:moa_app/constants/color_constants.dart';

class TitleTextStyle extends TextStyle {
  const TitleTextStyle()
      : super(
          fontSize: 22,
          height: 1.2,
          fontWeight: FontConstants.fontWeightBold,
          fontFamily: FontConstants.pretendard,
          color: AppColors.blackColor,
        );
}

class SubTitleTextStyle extends TextStyle {
  const SubTitleTextStyle()
      : super(
          fontSize: 16,
          fontWeight: FontConstants.fontWeightNormal,
          fontFamily: FontConstants.pretendard,
        );
}

class FolderTitleTextStyle extends TextStyle {
  const FolderTitleTextStyle()
      : super(
          fontSize: 16,
          fontWeight: FontConstants.fontWeightBold,
          fontFamily: FontConstants.pretendard,
        );
}

class FolderSubTitleTextStyle extends TextStyle {
  const FolderSubTitleTextStyle()
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
