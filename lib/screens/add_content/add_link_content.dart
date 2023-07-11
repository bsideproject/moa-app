import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:moa_app/constants/color_constants.dart';
import 'package:moa_app/constants/file_constants.dart';
import 'package:moa_app/constants/font_constants.dart';
import 'package:moa_app/utils/general.dart';
import 'package:moa_app/widgets/app_bar.dart';
import 'package:moa_app/widgets/button.dart';
import 'package:moa_app/widgets/edit_text.dart';
import 'package:moa_app/widgets/moa_widgets/edit_content.dart';
import 'package:moa_app/widgets/moa_widgets/error_text.dart';
import 'package:moa_app/widgets/moa_widgets/hashtag_box.dart';

class AddLinkContent extends HookWidget {
  const AddLinkContent({super.key});

  @override
  Widget build(BuildContext context) {
    var title = useState('');
    var link = useState('');
    var memo = useState('');
    var updatedHashtag = useState('');

    var tagList = useState(<String>['#자취레시피', '#꿀팁', '#카고바지', '#해시태그']);

    var titleError = useState('');
    var linkError = useState('');

    void completeAddContent() {
      if (link.value.isEmpty ||
          title.value.isEmpty ||
          title.value.length > 30) {
        if (title.value.isEmpty) {
          linkError.value = '링크를 입력해주세요.';
        }

        return;
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

    void onChangedLink(String value) {
      if (value.isNotEmpty || value.length < 30) {
        linkError.value = '';
      }
      if (value.length > 30) {
        linkError.value = '1~30자로 입력할 수 있어요.';
      }
      link.value = value;
    }

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
                  const Text(
                    '링크',
                    style: H4TextStyle(),
                  ),
                  const SizedBox(height: 5),
                  EditFormText(
                    onChanged: onChangedLink,
                    hintText: '링크를 입력하세요.',
                  ),
                  ErrorText(
                    errorText: linkError.value,
                    errorValidate: linkError.value.isNotEmpty,
                  ),
                  Row(
                    children: [
                      const Spacer(),
                      Text(
                        '${link.value.length}/30',
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
                    '대표 이미지',
                    style: H4TextStyle(),
                  ),
                  const SizedBox(height: 5),
                  SizedBox(
                    width: double.infinity,
                    height: 85,
                    child: ListView.builder(
                      itemCount: 5,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 7),
                          child: Ink(
                            width: 85,
                            height: 85,
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.all(
                                Radius.circular(15),
                              ),
                              color: AppColors.textInputBackground,
                              image:
                                  DecorationImage(image: Assets.moaBannerImg),
                            ),
                            child: InkWell(
                              onTap: () {},
                              borderRadius: const BorderRadius.all(
                                Radius.circular(15),
                              ),
                              child: Center(
                                child: Image(
                                  width: 15,
                                  height: 15,
                                  image: Assets.circlePlus,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
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
                          hashtagName: tag,
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
