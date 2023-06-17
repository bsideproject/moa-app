import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import 'package:loading_more_list/loading_more_list.dart';
import 'package:moa_app/constants/app_constants.dart';
import 'package:moa_app/constants/color_constants.dart';
import 'package:moa_app/constants/file_constants.dart';
import 'package:moa_app/constants/font_constants.dart';
import 'package:moa_app/screens/home/widgets/folder_list.dart';
import 'package:moa_app/screens/home/widgets/hashtag_list.dart';
import 'package:moa_app/screens/home/widgets/moa_comment_img.dart';
import 'package:moa_app/widgets/loading_indicator.dart';

class CollapsibleTabScroll extends HookWidget {
  const CollapsibleTabScroll({super.key});

  @override
  Widget build(BuildContext context) {
    GlobalKey<ExtendedNestedScrollViewState> globalKey =
        GlobalKey<ExtendedNestedScrollViewState>();
    var width = MediaQuery.of(context).size.width;
    return DefaultTabController(
      length: 2,
      child: ExtendedNestedScrollView(
        onlyOneScrollInBody: true,
        floatHeaderSlivers: false,
        key: globalKey,
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              toolbarHeight: 110,
              titleSpacing: 15,
              backgroundColor: AppColors.backgroundColor,
              flexibleSpace: FlexibleSpaceBar(
                background: Stack(
                  children: [
                    Positioned(
                      right: 15,
                      top: 3,
                      child: Image(
                        width: 150,
                        height: 182,
                        image: Assets.moaBannerImg,
                      ),
                    ),
                  ],
                ),
              ),
              title: Row(children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '안녕하세요 MOA님!',
                      style: TitleTextStyle(),
                    ),
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        Text(
                          '#카페러버',
                          style: const SubTitleTextStyle().merge(
                            TextStyle(
                              color: AppColors.blackColor.withOpacity(0.3),
                            ),
                          ),
                        ),
                        const SizedBox(width: 5),
                        Text(
                          '#취미부자',
                          style: const SubTitleTextStyle().merge(
                            TextStyle(
                              color: AppColors.blackColor.withOpacity(0.3),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ]),
            ),
            SliverPersistentHeader(
              delegate: PersistentTabBar(),
              pinned: true,
            ),
          ];
        },
        body: TabBarView(
          children: <Widget>[
            TabViewItem(const Key('Tab0'), width),
            TabViewItem(const Key('Tab1'), width),
          ],
        ),
      ),
    );
  }
}

/// list top tab bar
class PersistentTabBar extends SliverPersistentHeaderDelegate {
  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: AppColors.backgroundColor,
      child: Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
          color: AppColors.whiteColor,
        ),
        child: Padding(
          padding:
              const EdgeInsets.only(left: 15, right: 15, top: 20, bottom: 20),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 25),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    RichText(
                      text: TextSpan(
                        style: const TextStyle(
                            color: AppColors.blackColor,
                            fontSize: 24,
                            fontWeight: FontConstants.fontWeightNormal),
                        children: [
                          const TextSpan(
                            text: '지금까지 모아온\n',
                          ),
                          TextSpan(
                            text: '146개의 취향',
                            style: const TitleTextStyle().merge(
                              const TextStyle(
                                height: 1.4,
                                fontSize: 24,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(5),
                      width: 94,
                      height: 48,
                      decoration: BoxDecoration(
                        color: AppColors.secondaryColor,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: TabBar(
                        indicator: BoxDecoration(
                          color: AppColors.primaryColor,
                          borderRadius: BorderRadius.circular(40),
                        ),
                        indicatorSize: TabBarIndicatorSize.tab,
                        labelPadding: const EdgeInsets.symmetric(
                          vertical: 10,
                        ),
                        tabs: [
                          Image(
                            width: 16,
                            height: 16,
                            image: Assets.folderIcon,
                          ),
                          Image(
                            color: AppColors.whiteColor,
                            width: 16,
                            height: 16,
                            image: Assets.hashtag,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const MoaCommentImg(),
            ],
          ),
        ),
      ),
    );
  }

  @override
  double get maxExtent => 129.0;

  @override
  double get minExtent => 129.0;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}

/// list view item
class LoadMoreListSource extends LoadingMoreBase<int> {
  int pageIndex = 1;
  bool _hasMore = true;
  bool forceRefresh = false;
  @override
  bool get hasMore => (_hasMore && length < 30) || forceRefresh;

  @override
  Future<bool> refresh([bool notifyStateChanged = false]) async {
    _hasMore = true;
    pageIndex = 1;
    //force to refresh list when you don't want clear list before request
    //for the case, if your list already has 20 items.
    forceRefresh = !notifyStateChanged;
    var result = await super.refresh(notifyStateChanged);
    forceRefresh = false;
    return result;
  }

  @override
  Future<bool> loadData([bool isloadMoreAction = false]) {
    return Future<bool>.delayed(const Duration(seconds: 1), () {
      for (int i = 0; i < 10; i++) {
        add(0);
      }

      return true;
    });
  }
}

class TabViewItem extends StatefulWidget {
  const TabViewItem(this.uniqueKey, this.width, {super.key});
  final Key uniqueKey;
  final double width;
  @override
  TabViewItemState createState() => TabViewItemState();
}

class TabViewItemState extends State<TabViewItem>
    with AutomaticKeepAliveClientMixin {
  late final LoadMoreListSource source = LoadMoreListSource();

  @override
  void dispose() {
    source.dispose();
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    Widget child = ExtendedVisibilityDetector(
      uniqueKey: widget.uniqueKey,
      child: RefreshIndicator(
        onRefresh: () {
          // return source.refresh(true);
          return Future.delayed(
            const Duration(seconds: 2),
            () {
              source.refresh(false);
            },
          );
        },
        child: LoadingMoreList<int>(
          ListConfig<int>(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: widget.width > Breakpoints.md ? 4 : 2,
              childAspectRatio: 1.3,
              mainAxisSpacing: 20.0,
              crossAxisSpacing: 12.0,
            ),
            sourceList: source,
            indicatorBuilder: (context, status) {
              return const LoadingIndicator();
            },
            itemBuilder: (c, item, index) {
              return widget.uniqueKey == const Key('Tab0')
                  ? const FolderList()
                  : const HashtagList();
            },
          ),
        ),
      ),
    );
    return child;
  }
}
