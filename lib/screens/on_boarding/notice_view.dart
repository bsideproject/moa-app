import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:moa_app/constants/color_constants.dart';
import 'package:moa_app/constants/font_constants.dart';
import 'package:moa_app/widgets/button.dart';

class NoticeView extends StatelessWidget {
  const NoticeView({super.key, required this.nickname});
  final String nickname;

  @override
  Widget build(BuildContext context) {
    void handleNext() {
      context.go('/');
    }

    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
          child: Padding(
        padding:
            const EdgeInsets.only(left: 20, right: 20, top: 100, bottom: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RichText(
              text: TextSpan(
                style: const H1TextStyle().merge(
                  const TextStyle(
                    fontSize: 28,
                  ),
                ),
                children: [
                  const TextSpan(
                    text: '그럼 지금부터\n',
                  ),
                  TextSpan(
                    text: nickname,
                    style: const H1TextStyle().merge(const TextStyle(
                      fontSize: 28,
                      color: AppColors.primaryColor,
                    )),
                  ),
                  TextSpan(
                    text: '님의\n',
                    style: const H1TextStyle().merge(const TextStyle(
                      fontSize: 28,
                    )),
                  ),
                  TextSpan(
                    text: '취향을 바로 모아보세요!',
                    style: const H1TextStyle().merge(const TextStyle(
                      fontSize: 28,
                    )),
                  ),
                ],
              ),
            ),
            const Spacer(),
            Button(
              text: '바로 이용하기',
              onPress: handleNext,
            )
          ],
        ),
      )),
    );
  }
}
