import 'package:flutter/material.dart';
import 'package:moa_app/constants/color_constants.dart';
import 'package:moa_app/constants/font_constants.dart';

class HashtagBox extends StatelessWidget {
  const HashtagBox(
      {super.key, required this.hashtag, required this.isSelected});
  final String hashtag;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return Ink(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        color:
            isSelected ? AppColors.primaryColor : AppColors.hashtagBackground,
      ),
      child: Text(
        hashtag,
        style: TextStyle(
          color: isSelected
              ? AppColors.whiteColor
              : AppColors.blackColor.withOpacity(0.3),
          fontSize: 16,
          fontWeight: FontWeight.w600,
          fontFamily: FontConstants.pretendard,
        ),
      ),
    );
  }
}
