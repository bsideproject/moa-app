import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:moa_app/constants/color_constants.dart';
import 'package:moa_app/constants/font_constants.dart';
import 'package:moa_app/utils/router_provider.dart';
import 'package:moa_app/widgets/button.dart';

class NoticeView extends StatelessWidget {
  const NoticeView({super.key});

  @override
  Widget build(BuildContext context) {
    void handleNext() {
      context.go(GoRoutes.home.fullPath);
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
                style: const TextStyle(),
                children: [
                  TextSpan(
                    text: '안전한 보관',
                    style: const H1TextStyle().merge(
                      const TextStyle(
                        color: AppColors.primaryColor,
                        fontSize: 28,
                      ),
                    ),
                  ),
                  TextSpan(
                    text: '이\n시작되었습니다 :)\n지금 바로 취향을 모아보세요!',
                    style: const H1TextStyle()
                        .merge(const TextStyle(fontSize: 28)),
                  ),
                ],
              ),
            ),
            const Spacer(),
            Button(
              text: '시작하기',
              onPress: handleNext,
            )
          ],
        ),
      )),
    );
  }
}
