import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:moa_app/constants/file_constants.dart';
import 'package:moa_app/models/user_model.dart';
import 'package:moa_app/repositories/auth_repository.dart';
import 'package:moa_app/repositories/user_repository.dart';
import 'package:moa_app/utils/router_config.dart';
import 'package:moa_app/widgets/button.dart';
import 'package:moa_app/widgets/edit_text.dart';

class SignIn extends HookConsumerWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var user =
        useState<UserModel>(const UserModel(id: '0', email: '', password: ''));

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
                      await UserRepository.instance.login(user.value);
                      await ref.watch(userStateProvider.notifier).getMe();
                      if (context.mounted) {
                        context.go(GoRoutes.home.fullPath);
                      }
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
                    child: InkWell(
                      borderRadius: BorderRadius.circular(60),
                      onTap: () async {
                        var user = await AuthRepository.instance.kakaoLogin();
                        if (context.mounted && user != null) {
                          context.go(GoRoutes.home.fullPath);
                        }
                      },
                      child: Image(
                        width: 60,
                        image: Assets.kakao,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 20),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(60),
                      onTap: () async {
                        var user = await AuthRepository.instance.naverLogin();
                        if (context.mounted && user != null) {
                          context.go(GoRoutes.home.fullPath);
                        }
                      },
                      child: Image(
                        height: 60,
                        image: Assets.naver,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 20),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(60),
                      onTap: () async {
                        var user = await AuthRepository.instance.googleLogin();
                        if (context.mounted && user != null) {
                          context.go(GoRoutes.home.fullPath);
                        }
                      },
                      child: Image(
                        width: 60,
                        height: 60,
                        image: Assets.google,
                      ),
                    ),
                  ),
                  Platform.isIOS
                      ? InkWell(
                          borderRadius: BorderRadius.circular(60),
                          onTap: () async {
                            var user =
                                await AuthRepository.instance.appleLogin();
                            if (context.mounted && user != null) {
                              context.go(GoRoutes.home.fullPath);
                            }
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
    );
  }
}
