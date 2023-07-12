import 'package:flutter/material.dart';
import 'package:moa_app/constants/color_constants.dart';
import 'package:moa_app/constants/file_constants.dart';
import 'package:moa_app/constants/font_constants.dart';

class TypeHeader extends StatelessWidget {
  const TypeHeader(
      {super.key, required this.count, required this.onPressFilter});
  final int count;
  final Function() onPressFilter;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        RichText(
          text: TextSpan(
            style: const TextStyle(
              fontSize: 16,
              color: AppColors.blackColor,
              fontFamily: FontConstants.pretendard,
            ),
            children: [
              TextSpan(
                  text: '$count개',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  )),
              const TextSpan(
                text: '의 취향을 모았어요!',
              ),
            ],
          ),
        ),
        Material(
          child: InkWell(
            borderRadius: BorderRadius.circular(2),
            onTap: onPressFilter,
            child: Row(
              children: [
                const Text(
                  '최신순',
                  style: TextStyle(
                    fontSize: 14,
                    fontFamily: FontConstants.pretendard,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(width: 3),
                Image(
                  image: Assets.newestIcon,
                  width: 15,
                  height: 15,
                )
              ],
            ),
          ),
        )
      ],
    );
  }
}
