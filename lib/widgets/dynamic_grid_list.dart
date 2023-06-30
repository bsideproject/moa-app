import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:moa_app/models/hashtag_model.dart';
import 'package:moa_app/screens/home/widgets/hashtag_card.dart';

class DynamicGridList extends HookWidget {
  const DynamicGridList({super.key, required this.pullToRefresh});
  final Future<void> Function() pullToRefresh;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: pullToRefresh,
      child: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: kBottomNavigationBarHeight),
        child: StaggeredGrid.count(
          axisDirection: AxisDirection.down, // <----- Add this line
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 20,
          children: [
            StaggeredGridTile.count(
              crossAxisCellCount: 1,
              mainAxisCellCount: 1.4,
              child: HashtagCard(
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
