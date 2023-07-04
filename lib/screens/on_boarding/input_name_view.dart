import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:moa_app/constants/color_constants.dart';
import 'package:moa_app/constants/file_constants.dart';
import 'package:moa_app/constants/font_constants.dart';
import 'package:moa_app/repositories/non_member_repository.dart';
import 'package:moa_app/screens/on_boarding/notice_view.dart';
import 'package:moa_app/utils/router_provider.dart';
import 'package:moa_app/widgets/button.dart';
import 'package:moa_app/widgets/edit_text.dart';

enum StepType {
  inputName,
  greeting,
  tutorial,
}

class InputNameView extends HookWidget {
  const InputNameView({super.key, required this.isMember});
  final bool isMember;

  @override
  Widget build(BuildContext context) {
    var name = useState('');
    var controller = useTextEditingController();
    var pageController = usePageController();
    var step = useState<StepType>(StepType.inputName);
    var isNextPage = useState(false);

    bool validateNickname(String value) {
      const pattern = r'^[가-힣]{2,8}$'; // 정규식 패턴: 한글 2~8글자
      var regex = RegExp(pattern);

      return regex.hasMatch(value);
    }

    void handleNext() async {
      switch (step.value) {
        case StepType.inputName:
          {
            if (!isMember) {
              await NonMemberRepository.instance
                  .setUserNickname(nickname: name.value);
            } else {
              // todo api 개발 후 유저 로그인 정보에 이름 추가
            }
            step.value = StepType.greeting;
          }
        case StepType.greeting:
          {
            step.value = StepType.tutorial;
          }
        case StepType.tutorial:
          {
            if (isNextPage.value) {
              context.go(
                GoRoutes.notice.fullPath,
                extra: NoticeView(nickname: name.value),
              );
            }
            await pageController.nextPage(
                duration: const Duration(milliseconds: 300),
                curve: Curves.ease);
          }
          break;
      }
    }

    void onChangedName(String value) {
      name.value = value;
    }

    void emptyInputName() {
      name.value = '';
      controller.text = '';
    }

    Widget widgetByStep() {
      switch (step.value) {
        case StepType.inputName:
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                alignment: Alignment.center,
                width: 64,
                height: 30,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: AppColors.textInputBackground,
                ),
                child: Text(
                  '2/3',
                  style: const Hash1TextStyle().merge(
                    TextStyle(
                      fontSize: 12,
                      color: AppColors.blackColor.withOpacity(0.3),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              isMember
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '안전한 보관이 시작되었어요. :)',
                          style: const H1TextStyle()
                              .merge(const TextStyle(fontSize: 28)),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          '앞으로 취향 콘텐츠 저장 및 연동이 가능해요',
                          style: const H5TextStyle().merge(
                              const TextStyle(color: AppColors.subTitle)),
                        ),
                        const SizedBox(height: 40),
                      ],
                    )
                  : const SizedBox(),
              const Text(
                '앞으로 모아에서 사용하실\n닉네임을 설정해 주세요.',
                style: H1TextStyle(),
              ),
              const SizedBox(height: 25),
              EditFormText(
                maxLength: 8,
                controller: controller,
                onChanged: onChangedName,
                hintText: '닉네임을 입력하세요.',
                suffixIcon: CircleIconButton(
                  icon: Image(
                    fit: BoxFit.contain,
                    image: Assets.circleClose,
                    width: 16,
                    height: 16,
                  ),
                  onPressed: emptyInputName,
                ),
              ),
              const SizedBox(height: 5),
              AnimatedSwitcher(
                transitionBuilder: (child, animation) {
                  return FadeTransition(opacity: animation, child: child);
                },
                duration: const Duration(milliseconds: 100),
                child: (name.value.isNotEmpty && !validateNickname(name.value))
                    ? Row(
                        children: [
                          Image(
                            image: Assets.alert,
                            width: 13,
                            height: 13,
                          ),
                          const SizedBox(width: 5),
                          Text(
                            '이름은 한글 2~8자로 입력할 수 있어요.',
                            style: const Body1TextStyle().merge(
                              const TextStyle(color: AppColors.primaryColor),
                            ),
                          )
                        ],
                      )
                    : const SizedBox(),
              ),
            ],
          );
        case StepType.greeting:
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                alignment: Alignment.center,
                width: 64,
                height: 30,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: AppColors.textInputBackground,
                ),
                child: Text(
                  '3/3',
                  style: const Hash1TextStyle().merge(
                    TextStyle(
                      fontSize: 12,
                      color: AppColors.blackColor.withOpacity(0.3),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              RichText(
                text: TextSpan(
                  style:
                      const H1TextStyle().merge(const TextStyle(fontSize: 28)),
                  children: [
                    const TextSpan(
                      text: '환영해요!\n',
                    ),
                    TextSpan(
                      text: name.value,
                      style: const H1TextStyle().merge(
                        const TextStyle(
                          fontSize: 28,
                          color: AppColors.primaryColor,
                        ),
                      ),
                    ),
                    const TextSpan(
                      text: '님',
                    ),
                  ],
                ),
              ),
            ],
          );

        case StepType.tutorial:
          return Flexible(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '모아는 다음과 같은 방법으로\n취향을 저장할 수 있어요!',
                  style:
                      const H1TextStyle().merge(const TextStyle(fontSize: 28)),
                ),
                Expanded(
                  child: PageView(
                    onPageChanged: (value) {
                      if (value == 0) {
                        isNextPage.value = false;
                      } else {
                        isNextPage.value = true;
                      }
                    },
                    controller: pageController,
                    physics: const ClampingScrollPhysics(),
                    children: [
                      Column(
                        children: [
                          const Spacer(),
                          Image(
                            image: Assets.onboarding1,
                            width: 114,
                            height: 88,
                          ),
                          const SizedBox(height: 20),
                          Text(
                            '앱으로 추가하기',
                            style: const H1TextStyle()
                                .merge(const TextStyle(fontSize: 22)),
                          ),
                          const SizedBox(height: 7),
                          Text(
                            '어플에서 직접 입력하여 추가할 수 있어요!',
                            style: const Body1TextStyle().merge(
                              const TextStyle(color: AppColors.subTitle),
                            ),
                          )
                        ],
                      ),
                      Column(
                        children: [
                          const Spacer(),
                          Image(
                            image: Assets.onboarding2,
                            width: 136,
                            height: 103,
                          ),
                          const SizedBox(height: 20),
                          Text(
                            '외부 웹에서 공유하기',
                            style: const H1TextStyle()
                                .merge(const TextStyle(fontSize: 22)),
                          ),
                          const SizedBox(height: 7),
                          Text(
                            '외부 링크도 간편하게 등록하세요!',
                            style: const Body1TextStyle().merge(
                              const TextStyle(color: AppColors.subTitle),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 60),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(8)),
                        color: !isNextPage.value
                            ? AppColors.primaryColor
                            : AppColors.blackColor.withOpacity(0.3),
                      ),
                    ),
                    const SizedBox(width: 5),
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(8)),
                        color: isNextPage.value
                            ? AppColors.primaryColor
                            : AppColors.blackColor.withOpacity(0.3),
                      ),
                    )
                  ],
                )
              ],
            ),
          );
        default:
          return const Text('Hello');
      }
    }

    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Padding(
          padding:
              const EdgeInsets.only(left: 20, right: 20, top: 30, bottom: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 100),
              widgetByStep(),
              const Spacer(),
              Button(
                disabled:
                    !name.value.isNotEmpty || !validateNickname(name.value),
                text: isNextPage.value ? '확인' : '다음',
                onPress: handleNext,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
