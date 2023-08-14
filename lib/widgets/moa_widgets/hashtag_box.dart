import 'package:flutter/material.dart';
import 'package:moa_app/constants/color_constants.dart';
import 'package:moa_app/constants/file_constants.dart';
import 'package:moa_app/constants/font_constants.dart';

class HashtagBox extends StatelessWidget {
  const HashtagBox({
    super.key,
    required this.hashtag,
    required this.selected,
    required this.onSelected,
    this.isEditIcon = false,
  });
  final String hashtag;
  final bool selected;
  final ValueChanged<bool> onSelected;
  final bool isEditIcon;

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      backgroundColor: AppColors.hashtagBackground,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      selectedColor: AppColors.primaryColor,
      labelStyle: TextStyle(
        color: selected
            ? AppColors.whiteColor
            : AppColors.blackColor.withOpacity(0.3),
        fontSize: 16,
        fontWeight: FontWeight.w600,
        fontFamily: FontConstants.pretendard,
      ),
      label: Text('#$hashtag'),
      avatar: isEditIcon
          ? Image(width: 16, height: 16, image: Assets.pencil)
          : null,
      selected: selected,
      onSelected: onSelected,
    );
  }
}
