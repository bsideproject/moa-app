import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:moa_app/models/user_model.dart';
import 'package:moa_app/providers/user_provider.dart';
import 'package:moa_app/repositories/auth_repository.dart';
import 'package:moa_app/repositories/user_repository.dart';
import 'package:moa_app/utils/colors.dart';
import 'package:moa_app/utils/localization.dart';
import 'package:moa_app/utils/router_config.dart';
import 'package:moa_app/widgets/common/button.dart';
import 'package:moa_app/widgets/common/edit_text.dart';

class SignIn extends HookConsumerWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var user =
        useState<UserModel>(const UserModel(id: '0', email: '', password: ''));
    var t = localization(context);

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
                    margin: const EdgeInsets.only(top: 60, bottom: 8),
                    child: Text(
                      t.appName,
                      style: const TextStyle(
                          fontSize: 32, fontWeight: FontWeight.w700),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(bottom: 64),
                    child: const Text(
                      'MOA',
                      textAlign: TextAlign.center,
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
                  children: [
                    Button(
                      text: '구글',
                      onPress: () async {
                        var user = await GoogleAuthRepository.instance.login();
                        if(context.mounted && user != null) {
                          context.go(GoRoutes.home.fullPath);
                        }
                      },
                    ),
                    Button(
                      text: '애플',
                      onPress: () async {
                        var user = await AppleAuthRepository.instance.login();
                        if(context.mounted && user != null) {
                          context.go(GoRoutes.home.fullPath);
                        }
                      },
                    ),
                    Button(
                      text: '카카오',
                      onPress: () async {
                        var user = await KakaoAuthRepository.instance.login();
                        if(context.mounted && user != null) {
                          context.go(GoRoutes.home.fullPath);
                        }
                      },
                    ),
                    Button(
                      text: '네이버',
                      onPress: () async {
                        var user = await NaverAuthRepository.instance.login();
                        if(context.mounted && user != null) {
                          context.go(GoRoutes.home.fullPath);
                        }
                      },
                    ),
                  ],
                )
            ),
            Container(
              margin: const EdgeInsets.only(top: 56, bottom: 48),
              child: Column(
                children: [
                  Text(localization(context).inquiry,
                      style: const TextStyle(fontSize: 12, color: grey)),
                  Container(
                    margin: const EdgeInsets.only(top: 8),
                    child: const Text(
                      'support@dooboolab.com',
                      style: TextStyle(fontSize: 12),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
