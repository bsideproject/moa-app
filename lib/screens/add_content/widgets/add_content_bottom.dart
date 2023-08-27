import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:moa_app/constants/color_constants.dart';
import 'package:moa_app/constants/font_constants.dart';
import 'package:moa_app/screens/add_content/add_image_content.dart';
import 'package:moa_app/widgets/button.dart';
import 'package:moa_app/widgets/edit_text.dart';
import 'package:moa_app/widgets/moa_widgets/error_text.dart';
import 'package:moa_app/widgets/moa_widgets/hashtag_box.dart';

class AddContentBottom extends HookWidget {
  const AddContentBottom({
    super.key,
    required this.onChangedTitle,
    required this.titleError,
    required this.title,
    required this.selectedTagList,
    required this.hashtagController,
    required this.onChangedHashtag,
    required this.addHashtag,
    required this.tagError,
    required this.onChangedMemo,
    required this.memo,
    this.padding,
    this.titleController,
    this.memoController,
  });
  final ValueChanged<String> onChangedTitle;
  final ValueNotifier<String> titleError;
  final ValueNotifier<String> title;
  final ValueNotifier<List<SelectedTagModel>> selectedTagList;
  final TextEditingController hashtagController;
  final ValueChanged<String> onChangedHashtag;
  final VoidCallback addHashtag;
  final ValueNotifier<String> tagError;
  final ValueChanged<String> onChangedMemo;
  final ValueNotifier<String> memo;
  final EdgeInsetsGeometry? padding;
  final TextEditingController? titleController;
  final TextEditingController? memoController;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? const EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 25),
          const Text(
            '제목',
            style: H4TextStyle(),
          ),
          const SizedBox(height: 5),
          EditText(
            controller: titleController,
            maxLength: 30,
            onChanged: onChangedTitle,
            hintText: '1~30자로 입력할 수 있어요.',
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ErrorText(
                errorText: titleError.value,
                errorValidate: titleError.value.isNotEmpty,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  '${title.value.characters.length}/30',
                  style: TextStyle(
                      color: title.value.characters.length >= 30
                          ? AppColors.danger
                          : AppColors.blackColor.withOpacity(0.3),
                      fontSize: 12,
                      fontFamily: FontConstants.pretendard),
                ),
              ),
            ],
          ),
          const SizedBox(height: 25),
          Row(
            children: [
              const Text(
                '태그',
                style: H4TextStyle(),
              ),
              const SizedBox(width: 8),
              Text(
                '태그를 선택해주세요.',
                style: const Body1TextStyle()
                    .merge(const TextStyle(color: AppColors.subTitle)),
              )
            ],
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 10,
            children: [
              ...selectedTagList.value.map((tag) {
                return HashtagBox(
                  selected: tag.isSelected,
                  hashtag: tag.name,
                  onSelected: (value) {
                    selectedTagList.value = selectedTagList.value.map((e) {
                      if (e.name == tag.name) {
                        return SelectedTagModel(
                          name: e.name,
                          isSelected: value,
                        );
                      }
                      return e;
                    }).toList();
                    tagError.value = '';
                  },
                );
              }).toList(),
            ],
          ),
          const SizedBox(height: 10),
          EditText(
            maxLength: 7,
            controller: hashtagController,
            hintText: '태그를 입력하세요.',
            onChanged: onChangedHashtag,
            suffixIcon: Container(
              margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
              width: 35,
              height: 35,
              child: CircleIconButton(
                backgroundColor: AppColors.primaryColor,
                onPressed: addHashtag,
                icon: const Icon(Icons.add),
              ),
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ErrorText(
                errorText: tagError.value,
                errorValidate: tagError.value.isNotEmpty,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  '${hashtagController.text.characters.length}/7',
                  style: TextStyle(
                      color: hashtagController.text.characters.length >= 7
                          ? AppColors.danger
                          : AppColors.blackColor.withOpacity(0.3),
                      fontSize: 12,
                      fontFamily: FontConstants.pretendard),
                ),
              ),
            ],
          ),
          const SizedBox(height: 25),
          const Text(
            '메모',
            style: H4TextStyle(),
          ),
          const SizedBox(height: 5),
          Stack(
            children: [
              EditText(
                controller: memoController,
                maxLines: 4,
                maxLength: 100,
                height: 135,
                hintText: '메모를 입력하세요.',
                borderRadius: BorderRadius.circular(15),
                onChanged: onChangedMemo,
                backgroundColor: AppColors.textInputBackground,
              ),
              Positioned(
                right: 20,
                bottom: 20,
                child: Text(
                  '${memo.value.characters.length}/100',
                  style: TextStyle(
                    color: memo.value.characters.length >= 100
                        ? AppColors.danger
                        : AppColors.blackColor.withOpacity(0.3),
                    fontSize: 12,
                    fontFamily: FontConstants.pretendard,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
