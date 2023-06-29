import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:moa_app/constants/font_constants.dart';
import 'package:moa_app/utils/router_provider.dart';
import 'package:moa_app/widgets/app_bar.dart';
import 'package:moa_app/widgets/button.dart';
import 'package:moa_app/widgets/edit_text.dart';

class InputNameView extends HookWidget {
  const InputNameView({super.key});

  @override
  Widget build(BuildContext context) {
    var name = useState('');

    void handleNext() {
      if (name.value.isNotEmpty) {
        // todo 유저 로그인 정보에 이름 추가
        context.go(GoRoutes.notice.fullPath);
      }
    }

    void onChangedName(String value) {
      name.value = value;
    }

    return Scaffold(
      appBar: const AppBarBack(
        isBottomBorderDisplayed: false,
      ),
      body: SafeArea(
        child: Padding(
          padding:
              const EdgeInsets.only(left: 20, right: 20, top: 30, bottom: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '안녕하세요. MOA입니다 :)\n이름이 어떻게 되시나요?',
                style: const H1TextStyle().merge(const TextStyle(fontSize: 28)),
              ),
              const SizedBox(height: 25),
              EditText(
                onChanged: onChangedName,
                hintText: '이름을 입력하세요.',
              ),
              const Spacer(),
              Button(
                disabled: !name.value.isNotEmpty,
                text: '다음',
                onPress: handleNext,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
