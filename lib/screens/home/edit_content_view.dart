import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:moa_app/constants/color_constants.dart';
import 'package:moa_app/constants/file_constants.dart';
import 'package:moa_app/constants/font_constants.dart';
import 'package:moa_app/models/content_model.dart';
import 'package:moa_app/widgets/button.dart';
import 'package:moa_app/widgets/edit_text.dart';
import 'package:moa_app/widgets/image.dart';

class EditContentView extends HookWidget {
  const EditContentView(
      {super.key, required this.content, required this.isEditMode});
  final ContentModel content;
  final ValueNotifier<bool> isEditMode;

  @override
  Widget build(BuildContext context) {
    var titleController = useTextEditingController(text: content.contentName);
    var memoController = useTextEditingController(text: content.contentMemo);

    void saveEditContent() {
      // todo 컨텐츠 수정
      isEditMode.value = false;
    }

    void showEditHashtagModal() {
      // todo 해시태그 수정
    }

    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.9,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AspectRatio(
            aspectRatio: 1,
            child: Container(
              margin: const EdgeInsets.only(top: 20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: AppColors.grayBackground,
                  width: 0.5,
                ),
              ),
              child: ImageOnNetwork(
                imageURL: content.contentImageUrl,
              ),
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            '제목',
            style: H4TextStyle(),
          ),
          const SizedBox(height: 5),
          EditText(
            controller: titleController,
            maxLength: 30,
            onChanged: (value) {},
            hintText: '1~30자로 입력할 수 있어요.',
          ),
          const SizedBox(height: 30),
          const Text(
            '메모',
            style: H4TextStyle(),
          ),
          const SizedBox(height: 5),
          EditText(
            controller: memoController,
            maxLength: 30,
            onChanged: (value) {},
            hintText: '메모를 입력하세요.',
          ),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              ...content.contentHashTag.map(
                (e) => Container(
                  margin: const EdgeInsets.only(top: 30),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: AppColors.contentHashtagBackground,
                  ),
                  child: Text(
                    '#${e.hashTag}',
                    style: const TextStyle(
                      color: AppColors.subTitle,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      fontFamily: FontConstants.pretendard,
                    ),
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 30),
                child: CircleIconButton(
                  width: 35,
                  height: 35,
                  backgroundColor: AppColors.primaryColor,
                  onPressed: showEditHashtagModal,
                  icon: Image(
                    width: 16,
                    height: 16,
                    color: AppColors.whiteColor,
                    image: Assets.pencil,
                  ),
                ),
              )
            ],
          ),
          const SizedBox(height: 40),
          Button(
            backgroundColor: AppColors.primaryColor,
            text: '변경 내용 저장',
            onPress: saveEditContent,
          ),
        ],
      ),
    );
  }
}
