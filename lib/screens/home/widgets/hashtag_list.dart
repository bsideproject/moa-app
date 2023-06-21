import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:moa_app/constants/color_constants.dart';
import 'package:moa_app/constants/font_constants.dart';
import 'package:moa_app/models/hashtag_model.dart';
import 'package:moa_app/screens/home/widgets/hashtag_button.dart';

class HashtagList extends HookWidget {
  const HashtagList({
    super.key,
    required this.hashtag,
    required this.onPressed,
  });
  final HashtagModel hashtag;
  final Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.moaOpacity30),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            hashtag.title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              fontFamily: FontConstants.pretendard,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            hashtag.description,
            style: const TextStyle(
              fontSize: 14,
              fontFamily: FontConstants.pretendard,
              color: AppColors.moaDescription,
            ),
          ),
          const SizedBox(height: 15),
          Row(
            children: [
              ...hashtag.tags.map((tag) {
                if (tag != null) {
                  return Container(
                    margin: const EdgeInsets.only(right: 5),
                    child: HashtagButton(
                      onPress: onPressed,
                      text: tag,
                    ),
                  );
                }
                return const SizedBox();
              }).toList(),
            ],
          )
        ],
      ),
    );
  }
}
