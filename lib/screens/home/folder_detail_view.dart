import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:moa_app/constants/color_constants.dart';
import 'package:moa_app/constants/file_constants.dart';
import 'package:moa_app/models/content_model.dart';
import 'package:moa_app/repositories/folder_repository.dart';
import 'package:moa_app/screens/home/widgets/type_header.dart';
import 'package:moa_app/utils/router_provider.dart';
import 'package:moa_app/widgets/app_bar.dart';
import 'package:moa_app/widgets/button.dart';
import 'package:moa_app/widgets/loading_indicator.dart';
import 'package:moa_app/widgets/moa_widgets/dynamic_grid_list.dart';
import 'package:moa_app/widgets/moa_widgets/empty_content.dart';
import 'package:share_plus/share_plus.dart';

class FolderDetailView extends HookConsumerWidget {
  const FolderDetailView({super.key, required this.folderName});
  final String folderName;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Future<void> pullToRefresh() async {
      return Future.delayed(
        const Duration(seconds: 2),
        () {},
      );
    }

    void shareFolder() async {
      var encodeFolderName = Uri.encodeFull(folderName);

      // todo universal link로 변경
      await Share.share(
        'moa://moa${GoRoutes.folder.fullPath}/$encodeFolderName',
        subject: 'moa://moa${GoRoutes.folder.fullPath}/$encodeFolderName',
      );
    }

    return Scaffold(
      appBar: AppBarBack(
        isBottomBorderDisplayed: false,
        title: folderName,
        actions: [
          CircleIconButton(
            backgroundColor: AppColors.whiteColor,
            icon: Image(
              width: 20,
              height: 20,
              image: Assets.share,
            ),
            onPressed: shareFolder,
          ),
        ],
      ),
      body: SafeArea(
        child: FutureBuilder<List<ContentModel>>(
          future: FolderRepository.instance
              .getFolderDetailList(folderName: folderName),
          builder: (context, snapshot) {
            var contentList = snapshot.data ?? [];

            return AnimatedSwitcher(
              transitionBuilder: (child, animation) {
                return FadeTransition(opacity: animation, child: child);
              },
              duration: const Duration(milliseconds: 300),
              child: () {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const LoadingIndicator();
                }

                if (snapshot.hasData && contentList.isNotEmpty) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Column(
                      children: [
                        const SizedBox(height: 30),
                        TypeHeader(
                            count: contentList.length, onPressFilter: () {}),
                        const SizedBox(height: 5),
                        Expanded(
                          child: DynamicGridList(
                            contentList: contentList,
                            pullToRefresh: pullToRefresh,
                            folderNameProp: folderName,
                          ),
                        ),
                      ],
                    ),
                  );
                }
                return const EmptyContent(text: '저장된 취향이 없어요!\n취향을 저장해 주세요.');
              }(),
            );
          },
        ),
      ),
    );
  }
}
