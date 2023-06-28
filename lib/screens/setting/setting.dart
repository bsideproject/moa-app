import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:moa_app/constants/color_constants.dart';
import 'package:moa_app/constants/font_constants.dart';
import 'package:moa_app/providers/token_provider.dart';
import 'package:moa_app/utils/router_provider.dart';
import 'package:moa_app/widgets/alert_dialog.dart';

class Setting extends HookConsumerWidget {
  const Setting({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
        appBar: AppBar(
          actions: [
            Center(
              child: InkWell(
                borderRadius: BorderRadius.circular(5),
                onTap: () {
                  alertDialog.confirm(
                    context,
                    onPress: () async {
                      await ref
                          .watch(tokenStateProvider.notifier)
                          .removeToken();
                      if (context.mounted) {
                        context.go(GoRoutes.signIn.fullPath);
                      }
                    },
                    showCancelButton: true,
                    title: '로그아웃',
                    content: '로그아웃 하시겠습니까?',
                  );
                },
                child: Container(
                  padding: const EdgeInsets.all(20),
                  child: const Text(
                    '로그아웃',
                    style: TextStyle(
                      color: AppColors.primaryColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      fontFamily: FontConstants.pretendard,
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
        body: const Center(
          child: Text('setting'),
        ));
  }
}
