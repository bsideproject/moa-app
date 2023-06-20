import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:moa_app/constants/text_style_constants.dart';

class ShareOverlay extends HookWidget {
  const ShareOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    var count = useState(0);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.green,
        body: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(),
                const Text(
                  '저장 폴더를 선택해주세요!',
                  style: TitleTextStyle(),
                ),

                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                  onPressed: () {
                    print('11');
                    print('count.value:${count.value}');
                    count.value++;
                    // SystemNavigator.pop();
                  },
                  child: const Icon(
                    Icons.close,
                    size: 24,
                  ),
                )
                // IconButton(
                //   onPressed: () {
                //     SystemNavigator.pop();
                //   },
                //   icon: const Icon(
                //     Icons.close,
                //     size: 24,
                //   ),
                // )
              ],
            ),
            Text(
              '${count.value}',
              style: const TitleTextStyle(),
            ),
          ],
        ),
      ),
    );
  }
}
