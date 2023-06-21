import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:moa_app/constants/color_constants.dart';
import 'package:moa_app/constants/file_constants.dart';
import 'package:moa_app/constants/font_constants.dart';
import 'package:moa_app/models/hashtag_model.dart';
import 'package:moa_app/screens/home/widgets/hashtag_list.dart';
import 'package:moa_app/widgets/app_bar.dart';

class HashtagDetail extends HookWidget {
  const HashtagDetail({super.key, required this.filterHashtag});
  final String filterHashtag;

  @override
  Widget build(BuildContext context) {
    var gridController = useScrollController();
    var gridPageNum = useState(20);

    useEffect(() {
      gridController.addListener(() {
        /// load date at when scroll reached -100
        if (gridController.position.pixels >
            gridController.position.maxScrollExtent - 100) {
          gridPageNum.value += gridPageNum.value;
        }
      });

      return null;
    }, []);
    return Scaffold(
      appBar: const AppBarBack(
        bottomBorderStyle: BottomBorderStyle(height: 0),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: AppColors.primaryColor,
                  ),
                  child: Text(
                    filterHashtag,
                    style: const TextStyle(
                      color: AppColors.whiteColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      fontFamily: FontConstants.pretendard,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                RichText(
                  text: const TextSpan(
                    style: TextStyle(
                      fontSize: 16,
                      color: AppColors.blackColor,
                      fontFamily: FontConstants.pretendard,
                    ),
                    children: [
                      TextSpan(
                          text: '146개',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          )),
                      TextSpan(
                        text: '의 취향을 모았어요!',
                      ),
                    ],
                  ),
                ),
                Material(
                  child: InkWell(
                    borderRadius: BorderRadius.circular(2),
                    onTap: () {},
                    child: Row(
                      children: [
                        const Text(
                          '최신순',
                          style: TextStyle(
                            fontSize: 14,
                            fontFamily: FontConstants.pretendard,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(width: 3),
                        Image(
                          image: Assets.newestIcon,
                          width: 15,
                          height: 15,
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
            const SizedBox(height: 5),
            Expanded(
              child: RefreshIndicator(
                onRefresh: () {
                  return Future.delayed(
                    const Duration(seconds: 2),
                    () {},
                  );
                },
                child: GridView.builder(
                  controller: gridController,
                  padding: EdgeInsets.zero,
                  itemCount: gridPageNum.value,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 20,
                    childAspectRatio: 9 / 14,
                  ),
                  itemBuilder: (context, index) {
                    return HashtagList(
                      type: 'detailView',
                      hashtag: HashtagModel(
                        title: 'title',
                        description: 'description',
                        tags: ['#자취레시피', '#꿀팁'],
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
