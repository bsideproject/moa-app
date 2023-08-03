import 'package:flutter/material.dart';
import 'package:moa_app/constants/color_constants.dart';
import 'package:moa_app/constants/font_constants.dart';

class HashtagButton extends StatelessWidget {
  const HashtagButton({super.key, this.onPress, required this.text});
  final Function()? onPress;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 22,
      decoration: BoxDecoration(
        color: AppColors.moaSecondary,
        borderRadius: BorderRadius.circular(50),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      child: Text(
        text,
        style: const TextStyle(
          color: AppColors.blackColor,
          fontSize: 10,
          fontWeight: FontWeight.w700,
          fontFamily: FontConstants.pretendard,
        ),
      ),
    );
    // return Button(
    //   height: 22,
    //   onPress: onPress,
    //   text: text,
    //   textStyle: const TextStyle(
    //     color: AppColors.blackColor,
    //     fontSize: 10,
    //     fontWeight: FontWeight.w700,
    //     fontFamily: FontConstants.pretendard,
    //   ),
    //   padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
    //   backgroundColor: AppColors.moaSecondary,
    //   borderRadius: 50,
    // );
  }
}
