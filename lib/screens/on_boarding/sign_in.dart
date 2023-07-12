import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:moa_app/constants/app_constants.dart';
import 'package:moa_app/constants/color_constants.dart';
import 'package:moa_app/constants/file_constants.dart';
import 'package:moa_app/constants/font_constants.dart';
import 'package:moa_app/models/user_model.dart';
import 'package:moa_app/providers/token_provider.dart';
import 'package:moa_app/repositories/auth_repository.dart';
import 'package:moa_app/repositories/non_member_repository.dart';
import 'package:moa_app/screens/on_boarding/input_name_view.dart';
import 'package:moa_app/utils/logger.dart';
import 'package:moa_app/utils/router_provider.dart';
import 'package:moa_app/widgets/alert_dialog.dart';
import 'package:moa_app/widgets/button.dart';
import 'package:moa_app/widgets/edit_text.dart';
import 'package:moa_app/widgets/loading_indicator.dart';
import 'package:moa_app/widgets/snackbar.dart';

class SignIn extends HookConsumerWidget {
  const SignIn({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var loading = useState(false);
    var user =
        useState<UserModel>(const UserModel(id: '0', email: '', nickname: ''));

    //todo api 에서 nickname 가져와서 넣어주기
    var nickname = useState('');

    void hasNicknameCheck({required bool isMember}) async {
      /// 비회원
      if (!isMember) {
        var nonMember = await NonMemberRepository.instance.getNickname();
        if (nonMember != null) {
          nickname.value = nonMember.nickname ?? '';
        }
      }

      /// 회원
      // todo api 개발후 nickname 받아와서 넣어주기
      // nickname.value = '';

      if (nickname.value.isEmpty) {
        if (context.mounted) {
          context.go(GoRoutes.inputName.fullPath,
              extra: InputNameView(isMember: isMember));
        }
      } else {
        if (context.mounted) {
          context.go('/');
        }
      }
    }

    void handleLogin(Function login) async {
      /// 회원으로 시작
      try {
        loading.value = true;
        var token = await login();
        if (token != null) {
          await ref.watch(tokenStateProvider.notifier).addToken(token);

          // await UserRepository.instance.getUser();

          hasNicknameCheck(isMember: true);
        }
      } catch (e, traceback) {
        logger.d(e);
        logger.d(traceback);
        snackbar.alert(context,
            kDebugMode ? e.toString() : '회원가입 중 에러가 발생했습니다. 관리자에게 문의해주세요.');
      } finally {
        loading.value = false;
      }
    }

    void goNextScreen() {
      alertDialog.confirm(
        context,
        onPress: () {},
        showCancelButton: true,
        title: 'SNS 연동을 취소하시겠어요?',
        content: '모든 취향이 안전하게\n저장되지 않을 수 있어요!',
        cancelText: '네 안할래요.',
        onPressCancel: () async {
          /// 비회원으로 시작
          hasNicknameCheck(isMember: false);
        },
        confirmText: '아니요, 연동할래요!',
      );
    }

    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  alignment: Alignment.center,
                  margin: const EdgeInsets.symmetric(horizontal: 30),
                  width: 64,
                  height: 30,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: AppColors.textInputBackground,
                  ),
                  child: Text(
                    '1/3',
                    style: const Hash1TextStyle().merge(
                      TextStyle(
                        fontSize: 12,
                        color: AppColors.blackColor.withOpacity(0.3),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),

                Padding(
                  padding: const EdgeInsets.only(
                      left: 30, right: 30, top: kBottomNavigationBarHeight),
                  child: Text(
                    '앞으로 모아나갈 취향을\n안전하게 보관하기 위해\n계정을 연동해 주세요.',
                    style: const H1TextStyle()
                        .merge(const TextStyle(fontSize: 28, height: 1.4)),
                  ),
                ),
                const SizedBox(height: 80),
                Container(
                  margin: const EdgeInsets.only(left: 32, top: 25, right: 32),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: Button(
                          leftWidget: Padding(
                            padding: const EdgeInsets.only(right: 6),
                            child: Image(
                              width: 20,
                              height: 20,
                              image: Assets.kakao,
                            ),
                          ),
                          backgroundColor: const Color(0xffFEE501),
                          text: 'Kakao로 로그인',
                          textStyle:
                              const TextStyle(color: AppColors.blackColor),
                          onPress: () {
                            handleLogin(AuthRepository.instance.kakaoLogin);
                          },
                        ),
                      ),
                      (kIsWeb || Platform.isIOS)
                          ? Padding(
                              padding: const EdgeInsets.symmetric(vertical: 5),
                              child: Button(
                                leftWidget: Padding(
                                  padding: const EdgeInsets.only(right: 6),
                                  child: Image(
                                    width: 20,
                                    height: 20,
                                    image: Assets.apple,
                                  ),
                                ),
                                backgroundColor: AppColors.blackColor,
                                text: 'Apple로 로그인',
                                onPress: () {
                                  handleLogin(
                                      AuthRepository.instance.appleLogin);
                                },
                              ),
                            )
                          : const SizedBox(),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: Button(
                          leftWidget: Padding(
                            padding: const EdgeInsets.only(right: 6),
                            child: Image(
                              width: 20,
                              height: 20,
                              image: Assets.google,
                            ),
                          ),
                          borderWidth: 1,
                          backgroundColor: AppColors.whiteColor,
                          text: 'Google로 로그인',
                          textStyle:
                              const TextStyle(color: AppColors.blackColor),
                          onPress: () {
                            handleLogin(AuthRepository.instance.googleLogin);
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: Button(
                          leftWidget: Padding(
                            padding: const EdgeInsets.only(right: 6),
                            child: Image(
                              width: 20,
                              height: 20,
                              image: Assets.naver,
                            ),
                          ),
                          backgroundColor: const Color(0xff00BF18),
                          text: 'Naver로 로그인',
                          textStyle:
                              const TextStyle(color: AppColors.whiteColor),
                          onPress: () {
                            handleLogin(AuthRepository.instance.naverLogin);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                GestureDetector(
                  onTap: goNextScreen,
                  child: Center(
                    child: Text(
                      '아니요, 연동 안할게요.',
                      style: TextStyle(
                        color: AppColors.blackColor.withOpacity(0.4),
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ),

                /// 심사용 이메일 로그인
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.only(left: 32, top: 60, right: 32),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text('심시용 이메일 로그인'),
                      Column(children: [
                        ConstrainedBox(
                          constraints: const BoxConstraints(
                            maxWidth: Breakpoints.sm,
                          ),
                          child: EditText(
                            onChanged: (txt) {
                              user.value = user.value.copyWith(email: txt);
                            },
                            keyboardType: TextInputType.emailAddress,
                            hintText: 'Email',
                          ),
                        ),
                        ConstrainedBox(
                          constraints: const BoxConstraints(
                            maxWidth: Breakpoints.sm,
                          ),
                          child: EditText(
                            onChanged: (txt) {
                              // user.value = user.value.copyWith(password: txt);
                            },
                            hintText: 'Password',
                            obscureText: true,
                            enableSuggestions: false,
                            autocorrect: false,
                          ),
                        ),
                      ]),
                      ConstrainedBox(
                        constraints: const BoxConstraints(
                          maxWidth: Breakpoints.sm,
                        ),
                        child: Button(
                          text: '로그인 하기',
                          disabled: user.value.email == '',
                          onPress: () async {
                            // if (context.mounted) {
                            //   context.go(GoRoutes.home.fullPath);
                            // }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Offstage(
            offstage: !loading.value,
            child: Stack(
              children: [
                ModalBarrier(
                  dismissible: false,
                  color: Colors.black.withOpacity(0.5),
                ),
                const LoadingIndicator()
              ],
            ),
          )
        ],
      ),
    );
  }
}
