import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:moa_app/constants/color_constants.dart';
import 'package:moa_app/constants/file_constants.dart';
import 'package:moa_app/constants/font_constants.dart';
import 'package:moa_app/widgets/button.dart';

final GlobalKey<FormState> formKey = GlobalKey<FormState>();

enum ContentType { folder, hashtag }

class DeleteContent extends HookWidget {
  const DeleteContent({
    super.key,
    required this.contentName,
    required this.type,
    required this.onPressed,
    required this.folderColor,
    this.isMultiContent = false,
  });
  final String contentName;
  final ContentType type;
  final Function() onPressed;
  final Color folderColor;
  final bool isMultiContent;

  @override
  Widget build(BuildContext context) {
    var loading = useState(false);

    void deleteContent() async {
      loading.value = true;
      await onPressed();
      loading.value = false;
    }

    return SizedBox(
      width: double.infinity,
      child:

          /// 해시태그 삭제 뷰
          SafeArea(
        child: type == ContentType.hashtag
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  isMultiContent
                      ? const SizedBox(height: 46)
                      : Container(
                          margin: const EdgeInsets.only(top: 30),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 8),
                          decoration: BoxDecoration(
                            color: folderColor,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(50)),
                          ),
                          child: Text(
                            '#$contentName',
                            style: const Hash1TextStyle().merge(
                              const TextStyle(color: AppColors.placeholder),
                            ),
                          ),
                        ),
                  const SizedBox(height: 10),
                  Text(
                    isMultiContent
                        ? '$contentName\n태그를 삭제하시겠어요?'
                        : '${"#$contentName"}\n태그를 삭제하시겠어요?',
                    textAlign: TextAlign.center,
                    style: const H2TextStyle(),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 30, bottom: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image(
                          image: Assets.alert,
                          width: 13,
                          height: 13,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '해당 태그의 콘텐츠가 미분류로 변경돼요!',
                          style: const Body1TextStyle().merge(
                            const TextStyle(color: AppColors.primaryColor),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Button(
                    loading: loading.value,
                    text: '삭제하기',
                    onPressed: deleteContent,
                  )
                ],
              )

            /// 폴더 삭제 뷰
            : Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 30),
                    width: 100,
                    height: 80,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        fit: BoxFit.contain,
                        image: Assets.folder,
                        colorFilter: ColorFilter.mode(
                          folderColor,
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    '${"’$contentName’"}\n폴더를 삭제하시겠어요?',
                    textAlign: TextAlign.center,
                    style: const H2TextStyle(),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 30, bottom: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image(
                          image: Assets.alert,
                          width: 13,
                          height: 13,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '폴더를 삭제하면 모은 취향이 모두 사라져요!',
                          style: const Body1TextStyle().merge(
                            const TextStyle(color: AppColors.primaryColor),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Button(
                    text: '삭제하기',
                    onPressed: deleteContent,
                  )
                ],
              ),
      ),
    );
  }
}
