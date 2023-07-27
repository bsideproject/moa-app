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
    required this.onPressContent,
    required this.onPressHashtag,
  });
  final ContentModel content;
  final Function() onPressContent;
  final Function(String) onPressHashtag;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
      ),
      child: InkWell(
        splashColor: Colors.transparent,
        borderRadius: BorderRadius.circular(10),
        onTap: onPressContent,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.moaOpacity30),
                  borderRadius: BorderRadius.circular(10),
                  image: DecorationImage(
                    image: NetworkImage(content.contentImageUrl),
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
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
            const SizedBox(height: 15),
            Row(
              children: [
                ...content.contentHashTag.map((tag) {
                  return Container(
                    margin: const EdgeInsets.only(right: 5),
                    child: HashtagButton(
                      onPress: () => onPressHashtag(tag.hashTag),
                      text: tag.hashTag,
                    ),
                  );
                }).toList(),
              ],
            )
          ],
        ),
      ),
    );
  }
}
