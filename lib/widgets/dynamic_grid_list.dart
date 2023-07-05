import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:go_router/go_router.dart';
import 'package:moa_app/constants/app_constants.dart';
import 'package:moa_app/models/hashtag_model.dart';
import 'package:moa_app/screens/home/content_view.dart';
import 'package:moa_app/screens/home/widgets/hashtag_card.dart';
import 'package:moa_app/utils/router_provider.dart';

class DynamicGridList extends HookWidget {
  const DynamicGridList({super.key, required this.pullToRefresh});
  final Future<void> Function() pullToRefresh;

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    void goContentView(int contentId) {
      context.push(
        '${GoRoutes.content.fullPath}/$contentId',
        extra: ContentView(
          contentId: contentId,
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: pullToRefresh,
      child: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: kBottomNavigationBarHeight),
        child: StaggeredGrid.count(
          axisDirection: AxisDirection.down, // <----- Add this line
          crossAxisCount: width > Breakpoints.md ? 3 : 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 20,
          children: [
            StaggeredGridTile.count(
              crossAxisCellCount: 1,
              mainAxisCellCount: 1.4,
              child: HashtagCard(
                onPressContent: () => goContentView(0),
                onPressHashtag: (tag) {},
                hashtag: HashtagModel(
                  title: 'title',
                  description: 'description',
                  tags: ['#자취레시피', '#꿀팁'],
                ),
              ),
            ),
            StaggeredGridTile.count(
              crossAxisCellCount: 1,
              mainAxisCellCount: 1.9,
              child: HashtagCard(
                onPressContent: () => goContentView(1),
                onPressHashtag: (tag) {},
                hashtag: HashtagModel(
                  title: 'title',
                  description: 'description',
                  tags: ['#자취레시피', '#꿀팁'],
                ),
              ),
            ),
            StaggeredGridTile.count(
              crossAxisCellCount: 1,
              mainAxisCellCount: 1.9,
              child: HashtagCard(
                onPressContent: () => goContentView(2),
                onPressHashtag: (tag) {},
                hashtag: HashtagModel(
                  title: 'title',
                  description: 'description',
                  tags: ['#자취레시피', '#꿀팁'],
                ),
              ),
            ),
            StaggeredGridTile.count(
              crossAxisCellCount: 1,
              mainAxisCellCount: 1,
              child: HashtagCard(
                onPressContent: () => goContentView(3),
                onPressHashtag: (tag) {},
                hashtag: HashtagModel(
                  title: 'title',
                  description: 'description',
                  tags: ['#자취레시피', '#꿀팁'],
                ),
              ),
            ),
            StaggeredGridTile.count(
              crossAxisCellCount: 1,
              mainAxisCellCount: 1.4,
              child: HashtagCard(
                onPressContent: () => goContentView(4),
                onPressHashtag: (tag) {},
                hashtag: HashtagModel(
                  title: 'title',
                  description: 'description',
                  tags: ['#자취레시피', '#꿀팁'],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
