import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:moa_app/constants/file_constants.dart';
import 'package:moa_app/providers/button_click_provider.dart';

class MoaCommentImg extends HookConsumerWidget {
  const MoaCommentImg({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var isClick = ref.watch(buttonClickStateProvider.notifier);

    return GestureDetector(
      onTap: () {
        isClick.isClick(click: true);
      },
      child: SizedBox(
        height: 60,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                Image(
                  fit: BoxFit.cover,
                  width: 163,
                  height: 35,
                  image: Assets.moaCommentImg,
                ),
                const Positioned(
                  right: 30,
                  child: Text(
                    '원하는 모드를 선택해주세요!',
                    style: TextStyle(
                      color: Color(0xff7A7A7A),
                      fontSize: 10,
                    ),
                  ),
                ),
                const Positioned(
                  right: 15,
                  child: Icon(
                    Icons.close,
                    color: Color(0xffBCBCBC),
                    size: 11,
                  ),
                )
              ],
            ),
            Container(
              margin: const EdgeInsets.only(top: 10),
              child: Image(
                image: Assets.moaSwitchImg,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
