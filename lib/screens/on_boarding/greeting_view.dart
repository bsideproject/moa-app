import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:moa_app/constants/file_constants.dart';
import 'package:moa_app/constants/font_constants.dart';
import 'package:moa_app/utils/router_provider.dart';
import 'package:moa_app/widgets/button.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GreetingView extends HookWidget {
  const GreetingView({super.key});

  @override
  Widget build(BuildContext context) {
    var isNextStep = useState(false);
    Future<SharedPreferences> prefs0 = SharedPreferences.getInstance();

    void setInitRunApp() async {
      SharedPreferences prefs = await prefs0;
      await prefs.setBool('isInitRunApp', false);
    }

    void goNextStep() {
      if (isNextStep.value) {
        setInitRunApp();
        context.go(GoRoutes.signIn.fullPath);
        return;
      }
      isNextStep.value = true;
    }

    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 100),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: !isNextStep.value
                    ? Text(
                        '안녕하세요. \nMOA입니다 :)',
                        style: const H1TextStyle().merge(
                          const TextStyle(fontSize: 28, height: 1.3),
                        ),
                      )
                    : Text(
                        'MOA는 모두의 취향을\n사진과 링크로 \n저장할 수 있는 서비스예요!',
                        style: const H1TextStyle().merge(
                          const TextStyle(fontSize: 28, height: 1.3),
                        ),
                      ),
              ),
              AnimatedSwitcher(
                transitionBuilder: (child, animation) {
                  return FadeTransition(opacity: animation, child: child);
                },
                duration: const Duration(milliseconds: 300),
                child: !isNextStep.value
                    ? const SizedBox()
                    : Column(
                        children: [
                          const SizedBox(height: 100),
                          Center(
                            child: Image(
                              image: Assets.greeting,
                              width: 246,
                              height: 177,
                            ),
                          ),
                        ],
                      ),
              ),
              const Spacer(),
              Button(
                text: '다음',
                onPress: goNextStep,
              ),
              const SizedBox(height: kBottomNavigationBarHeight),
            ],
          ),
        ),
      ),
    );
  }
}
