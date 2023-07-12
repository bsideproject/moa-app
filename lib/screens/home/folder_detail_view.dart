import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:moa_app/constants/color_constants.dart';
import 'package:moa_app/constants/file_constants.dart';
import 'package:moa_app/screens/home/widgets/type_header.dart';
import 'package:moa_app/utils/general.dart';
import 'package:moa_app/widgets/app_bar.dart';
import 'package:moa_app/widgets/button.dart';
import 'package:moa_app/widgets/moa_widgets/bottom_modal_item.dart';
import 'package:moa_app/widgets/moa_widgets/delete_content.dart';
import 'package:moa_app/widgets/moa_widgets/dynamic_grid_list.dart';
import 'package:moa_app/widgets/moa_widgets/edit_content.dart';

class FolderDetailView extends HookWidget {
  const FolderDetailView({super.key, required this.folderId});
  final String folderId;

  @override
  Widget build(BuildContext context) {
    var updatedContentName = useState('');

    // var args = ModalRoute.of(context)!.settings.arguments;

    Future<void> pullToRefresh() async {
      return Future.delayed(
        const Duration(seconds: 2),
        () {},
      );
    }

    // void closeBottomModal() {
    //   context.pop();
    // }

    void showEditFolderModal() {
      General.instance.showBottomSheet(
        context: context,
        child: EditContent(
          title: '폴더명 수정',
          onPressed: () {
            // todo 폴더 수정 api 연동후 성공하면 아래 코드 실행 실패시 snackbar 경고
          },
          updatedContentName: updatedContentName,
          contentName: 'folderName',
        ),
        isContainer: false,
      );
    }

    void showDeleteFolderModal() {
      General.instance.showBottomSheet(
        height: 350,
        context: context,
        isCloseButton: true,
        child: DeleteContent(
          contentName: 'folderName',
          type: ContentType.folder,
          onPressed: () {
            // todo 폴더 삭제 api 연동후 성공하면 아래 코드 실행 실패시 snackbar 경고
          },
        ),
      );
    }

    void showFolderDetailModal() {
      General.instance.showBottomSheet(
        context: context,
        padding:
            const EdgeInsets.only(left: 15, right: 15, top: 15, bottom: 30),
        height: 225,
        child: Column(
          children: [
            BottomModalItem(
              icon: Assets.share,
              title: '공유하기',
              onPressed: () {
                // Todo url링크복사후 snackbar 알림
              },
            ),
            BottomModalItem(
              icon: Assets.pencil,
              title: '폴더명 수정',
              onPressed: () {
                context.pop();
                showEditFolderModal();
              },
            ),
            BottomModalItem(
              icon: Assets.trash,
              title: '폴더 삭제',
              onPressed: () {
                context.pop();
                showDeleteFolderModal();
              },
            ),
          ],
        ),
      );
    }

    return Scaffold(
      appBar: AppBarBack(
        isBottomBorderDisplayed: false,
        title: 'folderName',
        actions: [
          CircleIconButton(
            backgroundColor: AppColors.whiteColor,
            icon: Image(
              width: 36,
              height: 36,
              image: Assets.menu,
            ),
            onPressed: showFolderDetailModal,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          children: [
            const SizedBox(height: 30),
            TypeHeader(count: 56, onPressFilter: () {}),
            const SizedBox(height: 5),
            Expanded(
              child: DynamicGridList(
                // todo folder id 내려줘야함
                pullToRefresh: pullToRefresh,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
