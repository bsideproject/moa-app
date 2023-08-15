import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:moa_app/constants/color_constants.dart';
import 'package:moa_app/constants/file_constants.dart';
import 'package:moa_app/constants/font_constants.dart';

class EmptyImage extends HookWidget {
  const EmptyImage({super.key, this.aspectRatio});
  final double? aspectRatio;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: aspectRatio ?? 1,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: AppColors.hashtagBackground,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image(
              fit: BoxFit.contain,
              width: 70,
              height: 70,
              image: Assets.moaWalking,
            ),
            const SizedBox(height: 5),
            Text(
              '이미지가 없는 컨텐츠예요!',
              style: const Body1TextStyle().merge(
                const TextStyle(color: AppColors.subTitle),
              ),
            )
          ],
        ),
      ),
    );
  }
}
