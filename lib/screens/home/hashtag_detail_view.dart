import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:moa_app/constants/color_constants.dart';
import 'package:moa_app/constants/font_constants.dart';
import 'package:moa_app/screens/home/widgets/dynamic_grid_view.dart';
import 'package:moa_app/screens/home/widgets/type_header.dart';
import 'package:moa_app/widgets/app_bar.dart';

class HashtagDetailView extends HookWidget {
  const HashtagDetailView({super.key, required this.filterName});
  final String filterName;

  @override
  Widget build(BuildContext context) {
    // var hashTagList = useState(<HashtagModel>[]);
    var gridController = useScrollController();
    var gridPageNum = useState(20);

    Future<void> pullToRefresh() async {
      return Future.delayed(
        const Duration(seconds: 2),
        () {},
      );
    }

    // Future<void> getHashtagDetailViewList() async {
    //     hashTagList.value = await
    // }

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
                    filterName,
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
            TypeHeader(typeCount: 146, onPressFilter: () {}),
            const SizedBox(height: 5),
            Expanded(
                child: DynamicGridView(
              pullToRefresh: pullToRefresh,
            )),
          ],
        ),
      ),
    );
  }
}
