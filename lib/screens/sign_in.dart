import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:moa_app/constants/app_constants.dart';
import 'package:moa_app/constants/file_constants.dart';
import 'package:moa_app/models/user_model.dart';
import 'package:moa_app/providers/token_provider.dart';
import 'package:moa_app/repositories/auth_repository.dart';
import 'package:moa_app/widgets/button.dart';
import 'package:moa_app/widgets/edit_text.dart';
import 'package:moa_app/widgets/loading_indicator.dart';
import 'package:moa_app/widgets/snackbar.dart';

class SignIn extends HookConsumerWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var size = MediaQuery.of(context).size;
    var loading = useState(false);
    var user =
        useState<UserModel>(const UserModel(id: '0', email: '', password: ''));

    void handleLogin(Function login) async {
      try {
        loading.value = true;
        await login();
        await ref.watch(tokenStateProvider.notifier).addToken();
      } catch (e) {
        snackbar.alert(context,
            kDebugMode ? e.toString() : '회원가입 중 에러가 발생했습니다. 관리자에게 문의해주세요.');
      } finally {
        loading.value = false;
      }
    }

    return Scaffold(
      body: Stack(
        children: [
          SafeArea(
            child: ListView(
              children: [
                Container(
                  margin: const EdgeInsets.only(left: 32, top: 60, right: 32),
                  child: Column(
                    children: [
                      Container(
                        alignment: Alignment.center,
                        margin: const EdgeInsets.only(top: 60, bottom: 60),
                        child: const Text(
                          'MOA',
                          style: TextStyle(
                              fontSize: 32, fontWeight: FontWeight.w700),
                        ),
                      ),
                      Column(children: [
                        SizedBox(
                          width: size.width < Breakpoints.md
                              ? size.width
                              : size.width / 3,
                          child: EditText(
                            onChanged: (txt) {
                              user.value = user.value.copyWith(email: txt);
                            },
                            keyboardType: TextInputType.emailAddress,
                            hintText: 'Email',
                          ),
                        ),
                        SizedBox(
                          width: size.width < Breakpoints.md
                              ? size.width
                              : size.width / 3,
                          child: EditText(
                            onChanged: (txt) {
                              user.value = user.value.copyWith(password: txt);
                            },
                            hintText: 'Password',
                            obscureText: true,
                            enableSuggestions: false,
                            autocorrect: false,
                          ),
                        ),
                      ]),
                      Button(
                        width: size.width < Breakpoints.md
                            ? size.width
                            : size.width / 3,
                        text: '로그인 하기',
                        disabled:
                            user.value.email == '' || user.value.password == '',
                        onPress: () async {
                          // if (context.mounted) {
                          //   context.go(GoRoutes.home.fullPath);
                          // }
                        },
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(left: 32, top: 25, right: 32),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 20),
                        child: GestureDetector(
                          onTap: () {
                            handleLogin(AuthRepository.instance.kakaoLogin);
                          },
                          child: Image(
                            width: 60,
                            image: Assets.kakao,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 20),
                        child: GestureDetector(
                          onTap: () {
                            handleLogin(AuthRepository.instance.naverLogin);
                          },
                          child: Image(
                            height: 60,
                            image: Assets.naver,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 20),
                        child: GestureDetector(
                          onTap: () {
                            handleLogin(AuthRepository.instance.googleLogin);
                          },
                          child: Image(
                            width: 60,
                            height: 60,
                            image: Assets.google,
                          ),
                        ),
                      ),
                      (!kIsWeb && Platform.isIOS)
                          ? GestureDetector(
                              onTap: () {
                                handleLogin(AuthRepository.instance.appleLogin);
                              },
                              child: Image(
                                width: 60,
                                height: 60,
                                image: Assets.apple,
                              ),
                            )
                          : const SizedBox(),
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
