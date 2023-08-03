import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:moa_app/constants/color_constants.dart';
import 'package:moa_app/constants/font_constants.dart';
import 'package:moa_app/models/content_model.dart';
import 'package:moa_app/screens/home/widgets/hashtag_button.dart';

class ContentCard extends HookWidget {
  const ContentCard({
    super.key,
    required this.content,
    required this.onPressHashtag,
  });
  final ContentModel content;
  final Function(String) onPressHashtag;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          Text(
            content.contentName,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              fontFamily: FontConstants.pretendard,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            content.contentMemo ?? '',
            style: const TextStyle(
              fontSize: 14,
              fontFamily: FontConstants.pretendard,
              color: AppColors.moaDescription,
            ),
          ),
          SizedBox(height: content.contentMemo == null ? 0 : 15),
          SizedBox(
            width: double.infinity,
            child: Wrap(
              spacing: 10,
              runSpacing: 10,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                ...content.contentHashTag.map((tag) {
                  return HashtagButton(
                    onPress: () => onPressHashtag(tag.hashTag),
                    text: tag.hashTag,
                  );
                }).toList(),
              ],
            ),
          )
        ],
      ),
    );
  }
}
