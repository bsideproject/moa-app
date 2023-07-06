import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:moa_app/constants/color_constants.dart';
import 'package:moa_app/constants/file_constants.dart';
import 'package:moa_app/constants/font_constants.dart';
import 'package:moa_app/utils/general.dart';
import 'package:moa_app/widgets/app_bar.dart';
import 'package:moa_app/widgets/button.dart';
import 'package:moa_app/widgets/moa_widgets/bottom_modal_item.dart';

class ContentView extends HookWidget {
  const ContentView({super.key, required this.id});
  final String id;

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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Image(
                    image: Assets.smallFolder,
                    width: 42,
                    height: 42,
                  ),
                  const Text(
                    '요리/레시피',
                    style: H2TextStyle(),
                  ),
                ],
              ),
              Wrap(
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 30, bottom: 40),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: AppColors.primaryColor,
                    ),
                    child: const Text(
                      '#자취레시피',
                      style: TextStyle(
                        color: AppColors.whiteColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        fontFamily: FontConstants.pretendard,
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                height: 225,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: AppColors.primaryColor,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                '1인가구 제철채소 레시피',
                style: H2TextStyle(),
              ),
              const SizedBox(height: 30),
              Text(
                '요즘 유행인 다이어트 간식 #그릭요거트바크 만들기! 너무 초간단해보여서 저도 요가 후 후다닥 만들어보았는데~만들고 보니 아쉬웠던 점들도 있어서잇님들은 저처럼 시행착오 없이 바로 완벽 성공하길 바라며!',
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
          ),
        ),
      ),
    );
  }
}
