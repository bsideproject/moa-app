import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:moa_app/constants/color_constants.dart';
import 'package:moa_app/constants/file_constants.dart';
import 'package:moa_app/constants/font_constants.dart';
import 'package:moa_app/models/content_model.dart';
import 'package:moa_app/repositories/content_repository.dart';
import 'package:moa_app/utils/general.dart';
import 'package:moa_app/widgets/app_bar.dart';
import 'package:moa_app/widgets/button.dart';
import 'package:moa_app/widgets/moa_widgets/bottom_modal_item.dart';

class ContentView extends HookWidget {
  const ContentView({
    super.key,
    required this.id,
    required this.folderName,
  });
  final String id;
  final String folderName;

  @override
  Widget build(BuildContext context) {
    void pressGoToLink() {}

    void pressConfirm() {}

    void editContent() {}

    void deleteContent() {}

    void showContentModal() {
      General.instance.showBottomSheet(
        context: context,
        height: 150 + kBottomNavigationBarHeight,
        child: Column(
          children: [
            BottomModalItem(
              icon: Assets.pencil,
              title: '콘텐츠 수정',
              onPressed: () {
                context.pop();
                editContent();
              },
            ),
            BottomModalItem(
              icon: Assets.trash,
              title: '콘텐츠 삭제',
              onPressed: () {
                context.pop();
                deleteContent();
              },
            ),
          ],
        ),
      );
    }

    return Scaffold(
      appBar: AppBarBack(
        isBottomBorderDisplayed: false,
        actions: [
          CircleIconButton(
            backgroundColor: AppColors.whiteColor,
            icon: Image(
              width: 36,
              height: 36,
              image: Assets.menu,
            ),
            onPressed: showContentModal,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(
              left: 15, right: 15, bottom: kBottomNavigationBarHeight),
          child: FutureBuilder<ContentModel>(
            future: ContentRepository.instance.getContentDetail(contentId: id),
            builder: (context, snapshot) {
              var content = snapshot.data;

              if (snapshot.hasData && content != null) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Image(
                          image: Assets.smallFolder,
                          width: 42,
                          height: 42,
                        ),
                        Text(
                          folderName,
                          style: const H2TextStyle(),
                        ),
                      ],
                    ),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: [
                        ...content.contentHashTag.map(
                          (e) => Container(
                            margin: const EdgeInsets.only(top: 30, bottom: 40),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 8),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              color: AppColors.primaryColor,
                            ),
                            child: Text(
                              '#${e.hashTag}',
                              style: const TextStyle(
                                color: AppColors.whiteColor,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                fontFamily: FontConstants.pretendard,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      height: 225,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: AppColors.grayBackground,
                          width: 1,
                        ),
                        image: DecorationImage(
                          image: NetworkImage(content.contentImageUrl),
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      content.contentName,
                      style: const H2TextStyle(),
                    ),
                    const SizedBox(height: 30),
                    Text(
                      content.contentMemo ?? '',
                      style: const Hash1TextStyle().merge(
                        const TextStyle(height: 1.4),
                      ),
                    ),
                    const SizedBox(height: 80),
                    Row(
                      children: [
                        Expanded(
                          child: Button(
                            backgroundColor: AppColors.linkButton,
                            text: '링크 바로가기',
                            onPress: pressGoToLink,
                          ),
                        ),
                        const SizedBox(width: 15),
                        Expanded(
                          child: Button(
                            text: '확인',
                            onPress: pressConfirm,
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              }
              return const SizedBox();
            },
          ),
        ),
      ),
    );
  }
}
