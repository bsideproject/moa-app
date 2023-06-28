import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:moa_app/constants/color_constants.dart';
import 'package:moa_app/constants/file_constants.dart';
import 'package:moa_app/constants/font_constants.dart';
import 'package:moa_app/screens/home/widgets/dynamic_grid_view.dart';
import 'package:moa_app/screens/home/widgets/type_header.dart';
import 'package:moa_app/utils/general.dart';
import 'package:moa_app/widgets/app_bar.dart';
import 'package:moa_app/widgets/button.dart';

class FolderDetailView extends HookWidget {
  const FolderDetailView({super.key, required this.folderName});
  final String folderName;

  @override
  Widget build(BuildContext context) {
    Future<void> pullToRefresh() async {
      return Future.delayed(
        const Duration(seconds: 2),
        () {},
      );
    }

    // void closeBottomModal() {
    //   context.pop();
    // }

    Widget bottomModalItem({
      required AssetImage icon,
      required String title,
      required Function() onPressed,
    }) {
      return Material(
        child: Ink(
          color: AppColors.whiteColor,
          child: ListTile(
            onTap: onPressed,
            minLeadingWidth: 0,
            leading: SizedBox(
              height: double.infinity,
              child: Image(
                width: 16,
                height: 16,
                image: icon,
              ),
            ),
            title: Text(
              title,
              style: const H3TextStyle().merge(
                const TextStyle(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
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
            bottomModalItem(
              icon: Assets.share,
              title: '공유하기',
              onPressed: () {},
            ),
            bottomModalItem(
              icon: Assets.pencil,
              title: '폴더명 수정',
              onPressed: () {},
            ),
            bottomModalItem(
              icon: Assets.trash,
              title: '폴더 삭제',
              onPressed: () {},
            ),
          ],
        ),
      );
    }

    return Scaffold(
      appBar: AppBarBack(
        isBottomBorderDisplayed: false,
        title: Text(
          folderName,
          style: const H2TextStyle(),
        ),
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
            TypeHeader(typeCount: 56, onPressFilter: () {}),
            const SizedBox(height: 5),
            Expanded(
              child: DynamicGridView(
                pullToRefresh: pullToRefresh,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
