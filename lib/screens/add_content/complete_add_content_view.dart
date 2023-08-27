import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:moa_app/constants/file_constants.dart';
import 'package:moa_app/constants/font_constants.dart';
import 'package:moa_app/screens/home/home.dart';
import 'package:moa_app/widgets/app_bar.dart';
import 'package:moa_app/widgets/button.dart';

class CompleteAddContentView extends StatelessWidget {
  const CompleteAddContentView({super.key});

  @override
  Widget build(BuildContext context) {
    void goHome() {
      context.go(
        '/',
        extra: const Home(isRefresh: true),
      );
    }

    return Scaffold(
      appBar: const AppBarBack(
        isBackButton: false,
        title: '취향 모으기',
      ),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(),
                Image(width: 200, image: Assets.moaWalking),
                const SizedBox(height: 10),
                const Text(
                  '취향이 모아졌어요!',
                  style: H1TextStyle(),
                ),
                const Spacer(),
                Button(
                  onPressed: goHome,
                  text: '지금 저장한 취향 보러가기',
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
