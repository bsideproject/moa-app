import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:go_router/go_router.dart';
import 'package:moa_app/constants/app_constants.dart';
import 'package:moa_app/models/content_model.dart';
import 'package:moa_app/models/hashtag_model.dart';
import 'package:moa_app/screens/home/widgets/hashtag_card.dart';
import 'package:moa_app/utils/router_provider.dart';

class DynamicGridList extends HookWidget {
  const DynamicGridList({
    super.key,
    required this.contentList,
    required this.pullToRefresh,
  });
  final List<ContentModel> contentList;
  final Future<void> Function() pullToRefresh;

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    void goContentView(String contentId) {
      context.push(
        '${GoRoutes.content.fullPath}/$contentId',
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
            ...contentList.map((e) {
              return StaggeredGridTile.count(
                crossAxisCellCount: 1,
                mainAxisCellCount: 1.4,
                child: ContentCard(
                  onPressContent: () => goContentView('0'),
                  onPressHashtag: (tag) {},
                  content: ContentModel(
                    contentId: '1',
                    imageUrl: 'https://picsum.photos/200/300',
                    name: 'title',
                    memo: 'description',
                    hashTags: [
                      HashtagModel(tagId: '0', hashTag: '#자취레시피', count: 1),
                      HashtagModel(tagId: '1', hashTag: '#꿀팁', count: 1),
                    ],
                  ),
                ),
              );
            }).toList(),
            // StaggeredGridTile.count(
            //   crossAxisCellCount: 1,
            //   mainAxisCellCount: 1.4,
            //   child: ContentCard(
            //     onPressContent: () => goContentView('0'),
            //     onPressHashtag: (tag) {},
            //     content: ContentModel(
            //       contentId: '1',
            //       imageUrl: 'https://picsum.photos/200/300',
            //       name: 'title',
            //       memo: 'description',
            //       hashTags: [
            //         HashtagModel(tagId: '0', hashTag: '#자취레시피', count: 1),
            //         HashtagModel(tagId: '1', hashTag: '#꿀팁', count: 1),
            //       ],
            //     ),
            //   ),
            // ),
            // StaggeredGridTile.count(
            //   crossAxisCellCount: 1,
            //   mainAxisCellCount: 1.9,
            //   child: ContentCard(
            //     onPressContent: () => goContentView('1'),
            //     onPressHashtag: (tag) {},
            //     content: ContentModel(
            //       contentId: '1',
            //       imageUrl: 'https://picsum.photos/200/300',
            //       name: 'title',
            //       memo: 'description',
            //       hashTags: [
            //         HashtagModel(tagId: '0', hashTag: '#자취레시피', count: 1),
            //         HashtagModel(tagId: '1', hashTag: '#꿀팁', count: 1),
            //       ],
            //     ),
            //   ),
            // ),
            // StaggeredGridTile.count(
            //   crossAxisCellCount: 1,
            //   mainAxisCellCount: 1.9,
            //   child: ContentCard(
            //     onPressContent: () => goContentView('2'),
            //     onPressHashtag: (tag) {},
            //     content: ContentModel(
            //       contentId: '1',
            //       imageUrl: 'https://picsum.photos/200/300',
            //       name: 'title',
            //       memo: 'description',
            //       hashTags: [
            //         HashtagModel(tagId: '0', hashTag: '#자취레시피', count: 1),
            //         HashtagModel(tagId: '1', hashTag: '#꿀팁', count: 1),
            //       ],
            //     ),
            //   ),
            // ),
            // StaggeredGridTile.count(
            //   crossAxisCellCount: 1,
            //   mainAxisCellCount: 1,
            //   child: ContentCard(
            //     onPressContent: () => goContentView('3'),
            //     onPressHashtag: (tag) {},
            //     content: ContentModel(
            //       contentId: '1',
            //       imageUrl: 'https://picsum.photos/200/300',
            //       name: 'title',
            //       memo: 'description',
            //       hashTags: [
            //         HashtagModel(tagId: '0', hashTag: '#자취레시피', count: 1),
            //         HashtagModel(tagId: '1', hashTag: '#꿀팁', count: 1),
            //       ],
            //     ),
            //   ),
            // ),
            // StaggeredGridTile.count(
            //   crossAxisCellCount: 1,
            //   mainAxisCellCount: 1.4,
            //   child: ContentCard(
            //     onPressContent: () => goContentView('4'),
            //     onPressHashtag: (tag) {},
            //     content: ContentModel(
            //       contentId: '1',
            //       imageUrl: 'https://picsum.photos/200/300',
            //       name: 'title',
            //       memo: 'description',
            //       hashTags: [
            //         HashtagModel(tagId: '0', hashTag: '#자취레시피', count: 1),
            //         HashtagModel(tagId: '1', hashTag: '#꿀팁', count: 1),
            //       ],
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
