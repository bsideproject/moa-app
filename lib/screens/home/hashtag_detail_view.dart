import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:moa_app/constants/color_constants.dart';
import 'package:moa_app/constants/file_constants.dart';
import 'package:moa_app/constants/font_constants.dart';
import 'package:moa_app/screens/home/widgets/type_header.dart';
import 'package:moa_app/utils/general.dart';
import 'package:moa_app/widgets/app_bar.dart';
import 'package:moa_app/widgets/button.dart';
import 'package:moa_app/widgets/moa_widgets/bottom_modal_item.dart';
import 'package:moa_app/widgets/moa_widgets/delete_content.dart';
import 'package:moa_app/widgets/moa_widgets/dynamic_grid_list.dart';
import 'package:moa_app/widgets/moa_widgets/edit_content.dart';

class HashtagDetailView extends HookWidget {
  const HashtagDetailView({super.key, required this.filterName});
  final String filterName;

  @override
  Widget build(BuildContext context) {
    var gridController = useScrollController();
    var gridPageNum = useState(20);

    var updatedHashtagName = useState('');

    Future<void> pullToRefresh() async {
      return Future.delayed(
        const Duration(seconds: 2),
        () {},
      );
    }

    // Future<void> getHashtagDetailViewList() async {
    //     hashTagList.value = await
    // }

    void showEditHashtagModal() {
      General.instance.showBottomSheet(
        context: context,
        child: EditContent(
          title: '해시태그 수정',
          onPressed: () {
            // todo 해시태그 수정 api 연동후 성공하면 아래 코드 실행 실패시 snackbar 경고
          },
          updatedContentName: updatedHashtagName,
          contentName: filterName,
        ),
        isContainer: false,
      );
    }

    void showDeleteHashtagModal() {
      General.instance.showBottomSheet(
        height: 300,
        context: context,
        isCloseButton: true,
        child: DeleteContent(
          contentName: filterName,
          type: ContentType.hashtag,
          onPressed: () {
            // todo 폴더 삭제 api 연동후 성공하면 아래 코드 실행 실패시 snackbar 경고
          },
        ),
      );
    }

    void showHashtagDetailModal() {
      General.instance.showBottomSheet(
        context: context,
        padding:
            const EdgeInsets.only(left: 15, right: 15, top: 15, bottom: 30),
        height: 190,
        child: Column(
          children: [
            BottomModalItem(
              icon: Assets.pencil,
              title: '해시태그 수정',
              onPressed: () {
                context.pop();
                showEditHashtagModal();
              },
            ),
            BottomModalItem(
              icon: Assets.trash,
              title: '해시태그 삭제',
              onPressed: () {
                context.pop();
                showDeleteHashtagModal();
              },
            ),
          ],
        ),
      );
    }

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
      appBar: AppBarBack(
        bottomBorderStyle: const BottomBorderStyle(height: 0),
        actions: [
          CircleIconButton(
            backgroundColor: AppColors.whiteColor,
            icon: Image(
              width: 36,
              height: 36,
              image: Assets.menu,
            ),
            onPressed: showHashtagDetailModal,
          ),
        ],
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
            TypeHeader(count: 146, onPressFilter: () {}),
            const SizedBox(height: 5),
            Expanded(
                child: DynamicGridList(
              pullToRefresh: pullToRefresh,
            )),
          ],
        ),
      ),
    );
  }
}
