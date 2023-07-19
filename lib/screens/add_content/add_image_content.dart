import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:moa_app/constants/color_constants.dart';
import 'package:moa_app/constants/file_constants.dart';
import 'package:moa_app/constants/font_constants.dart';
import 'package:moa_app/models/content_model.dart';
import 'package:moa_app/models/hashtag_model.dart';
import 'package:moa_app/repositories/content_repository.dart';
import 'package:moa_app/utils/general.dart';
import 'package:moa_app/widgets/app_bar.dart';
import 'package:moa_app/widgets/button.dart';
import 'package:moa_app/widgets/edit_text.dart';
import 'package:moa_app/widgets/moa_widgets/edit_content.dart';
import 'package:moa_app/widgets/moa_widgets/error_text.dart';
import 'package:moa_app/widgets/moa_widgets/hashtag_box.dart';
import 'package:moa_app/widgets/snackbar.dart';

class AddImageContent extends HookWidget {
  const AddImageContent({super.key, required this.folderId});
  final String folderId;

  @override
  Widget build(BuildContext context) {
    var picker = ImagePicker();
    var imageFile = useState<XFile?>(null);

    void pickImage(ImageSource source) async {
      var pickedFile = await picker.pickImage(source: source);
      imageFile.value = pickedFile;
    }

    var title = useState('');
    var memo = useState('');
    var updatedHashtag = useState('');

    var tagList = useState<List<HashtagModel>>(
        [HashtagModel(tagId: 'tagId', hashTag: 'hashTag', count: 21)]);

    var imageError = useState('');
    var titleError = useState('');

    void completeAddContent() async {
      if (imageFile.value == null ||
          title.value.isEmpty ||
          title.value.length > 30) {
        if (imageFile.value == null) {
          imageError.value = '이미지를 선택해주세요.';
        }

        if (title.value.isEmpty) {
          titleError.value = '제목을 입력해주세요.';
        }

        return;
      }

      try {
        await ContentRepository.instance.addContent(
          contentType: ContentType.image,
          content: ContentModel(
            contentId: folderId,
            name: title.value,
            memo: memo.value,
            hashTags: tagList.value,
            imageUrl: imageFile.value.toString(),
          ),
        );

        if (context.mounted) {
          context.go('/');
        }
      } catch (e) {
        snackbar.alert(
            context, kDebugMode ? e.toString() : '오류가 발생했어요 다시 시도해주세요.');
      }
    }

    void onChangedTitle(String value) {
      if (value.isNotEmpty || value.length < 30) {
        titleError.value = '';
      }
      if (value.length > 30) {
        titleError.value = '1~30자로 입력할 수 있어요.';
      }
      title.value = value;
    }

    useEffect(() {
      if (imageFile.value != null) {
        imageError.value = '';
      }
      return null;
    }, [imageFile.value]);

    void showAddHashtagModal() {
      General.instance.showBottomSheet(
        context: context,
        child: EditContent(
          title: '해시태그 추가',
          buttonText: '추가하기',
          onPressed: () {
            // todo hashtag 중복 체크후 중복이면 에러메세지
            // if 중복이면
            return '이미 가지고 있는 해시태그예요!';
            // 중복 아니면
            // return '';
            // tagList.value.add('tag')
          },
          updatedContentName: updatedHashtag,
          contentName: '해시태그를 입력하세요.',
        ),
        isContainer: false,
      );
    }

    return Scaffold(
      appBar: const AppBarBack(
        isBottomBorderDisplayed: false,
        title: '취향 모으기',
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: 135,
                    child: Material(
                      color: AppColors.textInputBackground,
                      borderRadius: BorderRadius.circular(15),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(15),
                        onTap: () => pickImage(ImageSource.gallery),
                        child: imageFile.value != null
                            ? Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image:
                                        FileImage(File(imageFile.value!.path)),
                                  ),
                                ),
                              )
                            : Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image(
                                    width: 16,
                                    height: 16,
                                    image: Assets.circlePlus,
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    '대표 이미지 추가하기',
                                    style: const InputLabelTextStyle().merge(
                                      TextStyle(
                                        color: AppColors.blackColor
                                            .withOpacity(0.3),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                      ),
                    ),
                  ),
                  ErrorText(
                      errorText: imageError.value,
                      errorValidate: imageError.value.isNotEmpty),
                  const SizedBox(height: 25),
                  const Text(
                    '제목',
                    style: H4TextStyle(),
                  ),
                  const SizedBox(height: 5),
                  EditFormText(
                    onChanged: onChangedTitle,
                    hintText: '1~30자로 입력할 수 있어요.',
                  ),
                  ErrorText(
                    errorText: titleError.value,
                    errorValidate: titleError.value.isNotEmpty,
                  ),
                  Row(
                    children: [
                      const Spacer(),
                      Text(
                        '${title.value.length}/30',
                        style: TextStyle(
                            color: title.value.length > 30
                                ? AppColors.danger
                                : AppColors.blackColor.withOpacity(0.3),
                            fontSize: 12,
                            fontFamily: FontConstants.pretendard),
                      ),
                    ],
                  ),
                  const SizedBox(height: 25),
                  const Text(
                    '태그',
                    style: H4TextStyle(),
                  ),
                  const SizedBox(height: 5),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: [
                      ...tagList.value.map((tag) {
                        return HashtagBox(
                          hashtag: tag,
                        );
                      }).toList(),
                      SizedBox(
                        width: 35,
                        height: 35,
                        child: CircleIconButton(
                          backgroundColor: AppColors.primaryColor,
                          onPressed: showAddHashtagModal,
                          icon: const Icon(
                            Icons.add,
                          ),
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
                        maxLines: 4,
                        height: 135,
                        hintText: '메모를 입력하세요.',
                        borderRadius: BorderRadius.circular(15),
                        onChanged: (value) {
                          memo.value = value;
                        },
                        backgroundColor: AppColors.textInputBackground,
                      ),
                      Positioned(
                        right: 20,
                        bottom: 20,
                        child: Text(
                          '0/100',
                          style: const Hash1TextStyle().merge(TextStyle(
                            fontSize: 12,
                            color: AppColors.blackColor.withOpacity(0.3),
                          )),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            width: MediaQuery.of(context).size.width,
            child: Button(
              // loading: loading.value,
              // disabled: disableSubmit.value,
              onPress: completeAddContent,
              backgroundColor: AppColors.primaryColor,
              text: '완료',
              height: 52 + MediaQuery.of(context).padding.bottom,
              borderRadius: 0,
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).padding.bottom),
            ),
          )
        ],
      ),
    );
  }
}
