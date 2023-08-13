import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:moa_app/constants/color_constants.dart';
import 'package:moa_app/constants/font_constants.dart';
import 'package:moa_app/providers/user_provider.dart';
import 'package:moa_app/utils/router_provider.dart';
import 'package:moa_app/widgets/app_bar.dart';
import 'package:moa_app/widgets/button.dart';
import 'package:moa_app/widgets/snackbar.dart';

class Withdraw extends HookConsumerWidget {
  const Withdraw({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var withdrawConfirm = useState(false);

    void onPressedWithdraw() async {
      try {
        await ref.read(userStateProvider.notifier).withDraw();
        if (context.mounted) {
          context.go(GoRoutes.signIn.fullPath);
        }
      } catch (e) {
        snackbar.alert(
            context, kDebugMode ? e.toString() : '회원탈퇴에 실패했습니다 다시 시도해주세요.');
      }
    }

    return Scaffold(
      appBar: const AppBarBack(
        title: '탈퇴하기',
      ),
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '회원탈퇴 신청 전에 아래의 \n안내사항을 꼭 확인해 주세요.',
              style: H1TextStyle(),
            ),
            const SizedBox(height: 15),
            Text(
              '- 탈퇴 후 회원정보 및 모아온 콘텐츠는 모두 삭제되어 \n 복구가 불가능합니다.',
              style: const Hash1TextStyle().merge(
                  const TextStyle(color: AppColors.subTitle, height: 1.6)),
            ),
            const SizedBox(height: 10),
            Text(
              '- 삭제된 데이터는 복구가 불가능합니다.',
              style: const Hash1TextStyle().merge(
                  const TextStyle(color: AppColors.subTitle, height: 1.6)),
            ),
            const SizedBox(height: 10),
            Text(
              '- 회원탈퇴 후 동일한 계정으로 재가입 하여도 탈퇴 전 \n 모아온 취향을 이용할 수 없습니다.',
              style: const Hash1TextStyle().merge(
                  const TextStyle(color: AppColors.subTitle, height: 1.6)),
            ),
            const SizedBox(height: 48),
            Row(
              children: [
                SizedBox(
                  width: 24,
                  height: 24,
                  child: Checkbox(
                    value: withdrawConfirm.value,
                    onChanged: (value) {
                      withdrawConfirm.value = value ?? false;
                    },
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(3)),
                    fillColor: MaterialStateProperty.all(Colors.white),
                    side: const BorderSide(
                      color: AppColors.primaryColor,
                      width: 1.5,
                    ),
                    checkColor: AppColors.primaryColor,
                  ),
                ),
                const SizedBox(width: 10),
                const Text(
                  '그래도 모아를 탈퇴하시겠어요?',
                  style: Hash1TextStyle(),
                )
              ],
            ),
            const Spacer(),
            Row(
              children: [
                Expanded(
                  child: Button(
                    backgroundColor: AppColors.blackColor,
                    onPressed: () => context.pop(),
                    text: '취소',
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Button(
                    disabled: !withdrawConfirm.value,
                    onPressed: onPressedWithdraw,
                    text: '탈퇴',
                  ),
                )
              ],
            )
          ],
        ),
      )),
    );
  }
}
