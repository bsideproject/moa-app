import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:go_router/go_router.dart';
import 'package:moa_app/constants/app_constants.dart';
import 'package:moa_app/models/content_model.dart';
import 'package:moa_app/screens/home/content_view.dart';
import 'package:moa_app/screens/home/widgets/content_card.dart';
import 'package:moa_app/utils/router_provider.dart';
import 'package:moa_app/utils/utils.dart';

class DynamicGridList extends HookWidget {
  const DynamicGridList({
    super.key,
    required this.contentList,
    required this.pullToRefresh,
    required this.folderName,
  });
  final List<ContentModel> contentList;
  final Future<void> Function() pullToRefresh;
  final String folderName;

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    void goContentView(String contentId) {
      context.push(
        '${GoRoutes.content.fullPath}/$contentId',
        extra: ContentView(id: contentId, folderName: folderName),
      );
    }

    return RefreshIndicator(
      onRefresh: pullToRefresh,
      child: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: kBottomNavigationBarHeight),
        child: StaggeredGrid.count(
          axisDirection: AxisDirection.down,
          crossAxisCount: width > Breakpoints.md ? 3 : 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 20,
          children: [
            ...List.generate(
              contentList.length,
              (i) => FutureBuilder(
                future: getImageSize(imageURL: contentList[i].contentImageUrl),
                builder: (context, snapshot) {
                  var rate = snapshot.data ?? 1.4;

                  if (snapshot.hasData) {
                    return StaggeredGridTile.count(
                      crossAxisCellCount: 1,
                      mainAxisCellCount: rate,
                      child: ContentCard(
                        onPressContent: () =>
                            goContentView(contentList[i].contentId),
                        onPressHashtag: (tag) {},
                        content: ContentModel(
                          contentId: contentList[i].contentId,
                          contentImageUrl: contentList[i].contentImageUrl,
                          contentName: contentList[i].contentName,
                          contentMemo: contentList[i].contentMemo,
                          contentHashTag: contentList[i].contentHashTag,
                        ),
                      ),
                    );
                  }
                  return const SizedBox();
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
