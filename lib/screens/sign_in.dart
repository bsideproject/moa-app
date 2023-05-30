import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:moa_app/constants/file_constants.dart';
import 'package:moa_app/models/user_model.dart';
import 'package:moa_app/providers/token_provider.dart';
import 'package:moa_app/repositories/auth_repository.dart';
import 'package:moa_app/widgets/button.dart';
import 'package:moa_app/widgets/edit_text.dart';

class SignIn extends HookConsumerWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var user =
        useState<UserModel>(const UserModel(id: '0', email: '', password: ''));

    void addToken() async {
      await ref.watch(tokenStateProvider.notifier).addToken();
    }

    void handleKakaoLogin() async {
      await AuthRepository.instance.kakaoLogin();
      addToken();
    }

    void handleNaverLogin() async {
      await AuthRepository.instance.naverLogin();
      addToken();
    }

    void handleGoogleLogin() async {
      await AuthRepository.instance.googleLogin();
      addToken();
    }

    void handleAppleLogin() async {
      await AuthRepository.instance.appleLogin();
      addToken();
    }

    return Scaffold(
      body: SafeArea(
        child: ListView(
          children: [
            Container(
              margin: const EdgeInsets.only(left: 32, top: 60, right: 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    alignment: Alignment.center,
                    margin: const EdgeInsets.only(top: 60, bottom: 60),
                    child: const Text(
                      'MOA',
                      style:
                          TextStyle(fontSize: 32, fontWeight: FontWeight.w700),
                    ),
                  ),
                  Column(children: [
                    EditText(
                      onChanged: (txt) {
                        user.value = user.value.copyWith(email: txt);
                      },
                      keyboardType: TextInputType.emailAddress,
                      hintText: 'Email',
                    ),
                    EditText(
                      onChanged: (txt) {
                        user.value = user.value.copyWith(password: txt);
                      },
                      hintText: 'Password',
                      obscureText: true,
                      enableSuggestions: false,
                      autocorrect: false,
                    ),
                  ]),
                  Button(
                    text: '로그인 하기',
                    disabled:
                        user.value.email == '' || user.value.password == '',
                    onPress: () async {
                      // context.go(GoRoutes.home.fullPath);
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
                      onTap: handleKakaoLogin,
                      child: Image(
                        width: 60,
                        image: Assets.kakao,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 20),
                    child: GestureDetector(
                      onTap: handleNaverLogin,
                      child: Image(
                        height: 60,
                        image: Assets.naver,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 20),
                    child: GestureDetector(
                      onTap: handleGoogleLogin,
                      child: Image(
                        width: 60,
                        height: 60,
                        image: Assets.google,
                      ),
                    ),
                  ),
                  Platform.isIOS
                      ? GestureDetector(
                          onTap: handleAppleLogin,
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
    );
  }
}
