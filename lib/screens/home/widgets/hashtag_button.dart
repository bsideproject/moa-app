import 'package:flutter/material.dart';
import 'package:moa_app/constants/color_constants.dart';
import 'package:moa_app/constants/font_constants.dart';

class HashtagButton extends StatelessWidget {
  const HashtagButton({
    super.key,
    this.onPress,
    required this.text,
    this.width,
    this.height,
    this.style,
    this.padding,
  });
  final Function()? onPress;
  final String text;
  final double? width;
  final double? height;
  final TextStyle? style;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: AppColors.moaSecondary,
        borderRadius: BorderRadius.circular(50),
      ),
      padding:
          padding ?? const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      child: Text(
        text,
        style: style ??
            const TextStyle(
              color: AppColors.blackColor,
              fontSize: 10,
              fontWeight: FontWeight.w700,
              fontFamily: FontConstants.pretendard,
            ),
      ),
    );
  }
}
