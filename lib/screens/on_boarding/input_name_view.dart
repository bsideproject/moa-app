import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:moa_app/constants/color_constants.dart';
import 'package:moa_app/constants/file_constants.dart';
import 'package:moa_app/constants/font_constants.dart';
import 'package:moa_app/repositories/non_member_repository.dart';
import 'package:moa_app/repositories/user_repository.dart';
import 'package:moa_app/screens/on_boarding/notice_view.dart';
import 'package:moa_app/utils/router_provider.dart';
import 'package:moa_app/utils/utils.dart';
import 'package:moa_app/widgets/button.dart';
import 'package:moa_app/widgets/edit_text.dart';
import 'package:moa_app/widgets/moa_widgets/error_text.dart';
import 'package:moa_app/widgets/snackbar.dart';

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
    var focusNode = useFocusNode();

    void inputUserName() async {
      if (!isMember) {
        await NonMemberRepository.instance
            .setUserNickname(nickname: name.value);
      } else {
        try {
          await UserRepository.instance.editUserNickname(nickname: name.value);
          step.value = StepType.greeting;
        } catch (e) {
          if (context.mounted) {
            snackbar.alert(context, kDebugMode ? e.toString() : '중복된 닉네임입니다.');
          }
        }
      }
    }

    void handleNext() async {
      switch (step.value) {
        case StepType.inputName:
          {
            inputUserName();
            focusNode.unfocus();
            return;
          }
        case StepType.greeting:
          {
            step.value = StepType.tutorial;
            return;
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
            return;
          }
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
                focusNode: focusNode,
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
              ErrorText(
                  errorText: '이름은 한글 2~8자로 입력할 수 있어요.',
                  errorValidate:
                      name.value.isNotEmpty && !validateNickname(name.value)),
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
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  '모아는 다음과 같은 방법으로\n취향을 저장할 수 있어요!',
                  style:
                      const H1TextStyle().merge(const TextStyle(fontSize: 28)),
                ),
              ),
              SizedBox(
                height: 300,
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
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
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
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
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
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(8)),
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
                      borderRadius: const BorderRadius.all(Radius.circular(8)),
                      color: isNextPage.value
                          ? AppColors.primaryColor
                          : AppColors.blackColor.withOpacity(0.3),
                    ),
                  )
                ],
              ),
            ],
          );
        default:
          return const SizedBox();
      }
    }

    var isFocus = useState(false);
    focusNode.addListener(() {
      if (focusNode.hasFocus) {
        isFocus.value = true;
        return;
      }
      isFocus.value = false;
    });

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 30),
          child: Stack(
            fit: StackFit.expand,
            children: [
              step.value == StepType.tutorial
                  ? Padding(
                      padding: const EdgeInsets.only(top: 85),
                      child: widgetByStep(),
                    )
                  : AnimatedPadding(
                      padding: EdgeInsets.only(
                          left: 20,
                          right: 20,
                          top: focusNode.hasFocus ? 0 : 85),
                      duration: const Duration(milliseconds: 180),
                      curve: Curves.easeIn,
                      child: SingleChildScrollView(
                        physics: const ClampingScrollPhysics(),
                        child: widgetByStep(),
                      ),
                    ),
              Positioned(
                bottom: 0,
                left: 20,
                width: MediaQuery.of(context).size.width - 40,
                child: Button(
                  disabled:
                      !name.value.isNotEmpty || !validateNickname(name.value),
                  text: isNextPage.value ? '확인' : '다음',
                  onPressed: handleNext,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
