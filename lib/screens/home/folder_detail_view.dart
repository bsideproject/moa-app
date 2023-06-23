import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:moa_app/constants/color_constants.dart';
import 'package:moa_app/constants/file_constants.dart';
import 'package:moa_app/constants/font_constants.dart';
import 'package:moa_app/screens/home/widgets/dynamic_grid_view.dart';
import 'package:moa_app/screens/home/widgets/type_header.dart';
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
            onPressed: () {},
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
