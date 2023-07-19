import 'package:flutter/material.dart';
import 'package:moa_app/constants/color_constants.dart';
import 'package:moa_app/constants/font_constants.dart';
import 'package:moa_app/models/hashtag_model.dart';

class HashtagBox extends StatelessWidget {
  const HashtagBox({super.key, required this.hashtag});
  final HashtagModel hashtag;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        color: AppColors.primaryColor,
      ),
      child: Text(
        hashtag.hashTag,
        style: const TextStyle(
          color: AppColors.whiteColor,
          fontSize: 16,
          fontWeight: FontWeight.w600,
          fontFamily: FontConstants.pretendard,
        ),
      ),
    );
  }
}
