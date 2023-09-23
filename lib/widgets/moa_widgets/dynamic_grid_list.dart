import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:go_router/go_router.dart';
import 'package:moa_app/constants/app_constants.dart';
import 'package:moa_app/constants/color_constants.dart';
import 'package:moa_app/models/content_model.dart';
import 'package:moa_app/repositories/content_repository.dart';
import 'package:moa_app/screens/home/content_view.dart';
import 'package:moa_app/screens/home/widgets/content_card.dart';
import 'package:moa_app/utils/router_provider.dart';
import 'package:moa_app/widgets/image.dart';

class DynamicGridList extends HookWidget {
  const DynamicGridList({
    super.key,
    required this.contentList,
    required this.pullToRefresh,
    required this.controller,
    this.folderNameProp,
    this.folderDetailRefresher,
  });
  final List<ContentModel> contentList;
  final Future<void> Function() pullToRefresh;
  final ScrollController controller;
  final String? folderNameProp;
  final ValueNotifier<bool>? folderDetailRefresher;

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    void goContentView({
      required String contentId,
      required String folderName,
      String? contentUrl,
    }) async {
      await context.push(
        '${GoRoutes.content.fullPath}/$contentId',
        extra: ContentView(
          id: contentId,
          folderName: folderNameProp ?? folderName,
          contentType:
              contentUrl != '' ? AddContentType.url : AddContentType.image,
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: pullToRefresh,
      child: SingleChildScrollView(
        controller: controller,
        physics: const AlwaysScrollableScrollPhysics(),
        padding:
            const EdgeInsets.only(bottom: kBottomNavigationBarHeight, top: 15),
        child: StaggeredGrid.count(
          axisDirection: AxisDirection.down,
          crossAxisCount: width > Breakpoints.md ? 3 : 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 20,
          children: [
            ...List.generate(
              contentList.length,
              (i) => InkWell(
                splashColor: Colors.transparent,
                borderRadius: BorderRadius.circular(10),
                onTap: () {
                  goContentView(
                    contentId: contentList[i].contentId,
                    contentUrl: contentList[i].contentUrl,
                    folderName: contentList[i].folderName ?? '',
                  );
                },
                child: Column(
                  children: [
                    ImageOnNetwork(
                      border: Border.all(
                        color: AppColors.moaOpacity30,
                        width: 0.5,
                      ),
                      borderRadius: 10,
                      imageURL: contentList[i].thumbnailImageUrl,
                    ),
                    ContentCard(
                      onPressHashtag: (tag) {},
                      content: ContentModel(
                        contentId: contentList[i].contentId,
                        thumbnailImageUrl: contentList[i].thumbnailImageUrl,
                        contentName: contentList[i].contentName,
                        contentMemo: contentList[i].contentMemo,
                        contentHashTags: contentList[i].contentHashTags,
                        folderName: contentList[i].folderName,
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
