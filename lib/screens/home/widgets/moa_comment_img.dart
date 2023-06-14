import 'package:flutter/material.dart';
import 'package:moa_app/constants/file_constants.dart';

class MoaCommentImg extends StatelessWidget {
  const MoaCommentImg({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: -15,
      top: 0,
      child: SizedBox(
        height: 60,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                Image(
                  width: 163,
                  image: Assets.moaCommentImg,
                ),
                const Text(
                  '원하는 모드를 선택해주세요!',
                  style: TextStyle(
                    color: Color(0xff7A7A7A),
                    fontSize: 11,
                  ),
                ),
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
