import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:loading_more_list/loading_more_list.dart';
import 'package:moa_app/constants/app_constants.dart';
import 'package:moa_app/constants/color_constants.dart';
import 'package:moa_app/constants/file_constants.dart';
import 'package:moa_app/constants/font_constants.dart';
import 'package:moa_app/models/item_model.dart';
import 'package:moa_app/providers/button_click_provider.dart';
import 'package:moa_app/screens/home/widgets/folder_list.dart';
import 'package:moa_app/screens/home/widgets/hashtag_list.dart';
import 'package:moa_app/screens/home/widgets/moa_comment_img.dart';
import 'package:moa_app/widgets/button.dart';
import 'package:moa_app/widgets/edit_text.dart';
import 'package:moa_app/widgets/loading_indicator.dart';

List<Color> folderColors = [
  AppColors.folderColorFAE3CB,
  AppColors.folderColorFFD4D7,
  AppColors.folderColorD7E5FC,
  AppColors.folderColorECD8F3,
];

class CollapsibleTabScroll extends HookConsumerWidget {
  const CollapsibleTabScroll({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var isClick = ref.watch(buttonClickStateProvider);
    var tabIdx = useState(0);
    TabController tabController = useTabController(initialLength: 2);
    late AnimationController animationController = useAnimationController(
      duration: const Duration(milliseconds: 500),
    );
    late Animation<double> animation =
        Tween(begin: 0.0, end: 0.5).animate(animationController);

    /// SliverPersistentHeader의 tab icon 색깔 리렌더를 위해서 addListener 사용
    tabController.addListener(() {
      if (tabController.index == 0) {
        tabIdx.value = 0;
      } else {
        tabIdx.value = 1;
      }
    });

    return DefaultTabController(
      length: 2,
      child: ExtendedNestedScrollView(
        onlyOneScrollInBody: true,
        floatHeaderSlivers: false,
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
                      '안녕하세요 Moa님!',
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
              delegate: PersistentTabBar(
                tabController: tabController,
                isClick: isClick,
              ),
              pinned: true,
            ),
          ];
        },
        body: TabBarView(
          controller: tabController,
          children: const <Widget>[
            TabViewItem(Key('Tab0')),
            TabViewItem(Key('Tab1')),
          ],
        ),
      ),
    );
  }
}

/// list top tab bar
class PersistentTabBar extends SliverPersistentHeaderDelegate {
  const PersistentTabBar({
    required this.isClick,
    required this.tabController,
  });
  final bool isClick;
  final TabController tabController;

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
          padding: const EdgeInsets.only(left: 15, right: 15, top: 20),
          child: Column(
            children: [
              Stack(
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
                            controller: tabController,
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
                                color: tabController.index == 0
                                    ? AppColors.whiteColor
                                    : AppColors.hashtagColor,
                              ),
                              Image(
                                color: tabController.index == 1
                                    ? AppColors.whiteColor
                                    : AppColors.hashtagColor,
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
                  AnimatedPositioned(
                    right: isClick ? -200 : -15,
                    duration: const Duration(milliseconds: 400),
                    curve: Curves.easeInOut,
                    child: const MoaCommentImg(),
                  )
                ],
              ),
              AnimatedSwitcher(
                transitionBuilder: (child, animation) {
                  return FadeTransition(opacity: animation, child: child);
                },
                duration: const Duration(milliseconds: 600),
                child: tabController.index == 0
                    ? const SizedBox()
                    : Container(
                        margin: const EdgeInsets.only(top: 25),
                        child: EditText(
                          height: 50,
                          onChanged: (value) {},
                          hintText: '나의 해시태그 검색',
                          borderRadius: 50,
                          suffixIcon: CircleIconButton(
                            icon: Image(
                              fit: BoxFit.contain,
                              image: Assets.searchIcon,
                              width: 16,
                              height: 16,
                            ),
                            onPressed: () {},
                          ),
                        ),
                      ),
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  // double get maxExtent => 129.0;
  double get maxExtent => tabController.index == 1 ? 215.0 : 129.0;

  @override
  double get minExtent => 129.0;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}

/// list view item
class LoadMoreListSource extends LoadingMoreBase<ItemModel> {
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
      if (pageIndex == 1) {
        clear();
      }
      for (int i = 0; i < 4; i++) {
        add(const ItemModel(id: 0, title: 'title', content: 'content'));
      }

      add(
        const ItemModel(
          id: 0,
          title: 'title',
          content: 'content',
        ),
      );

      return true;
    });
  }
}

class TabViewItem extends StatefulWidget {
  const TabViewItem(this.uniqueKey, {super.key});
  final Key uniqueKey;

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
    var width = MediaQuery.of(context).size.width;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        widget.uniqueKey == const Key('Tab1')
            ? Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    RichText(
                      text: const TextSpan(
                        style: TextStyle(
                          fontSize: 16,
                          color: AppColors.blackColor,
                          fontFamily: FontConstants.pretendard,
                        ),
                        children: [
                          TextSpan(
                              text: '146개',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              )),
                          TextSpan(
                            text: '의 취향을 모았어요!',
                          ),
                        ],
                      ),
                    ),
                    InkWell(
                      onTap: () {},
                      child: Row(
                        children: [
                          const Text(
                            '최신순',
                            style: TextStyle(
                              fontSize: 14,
                              fontFamily: FontConstants.pretendard,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(width: 3),
                          Image(
                            image: Assets.newestIcon,
                            width: 15,
                            height: 15,
                          )
                        ],
                      ),
                    )
                  ],
                ),
              )
            : const SizedBox(),
        Expanded(
          child: ExtendedVisibilityDetector(
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
              child: LoadingMoreList<ItemModel>(
                ListConfig<ItemModel>(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: width > Breakpoints.md ? 4 : 2,
                    childAspectRatio: 1.3,
                    mainAxisSpacing: 20.0,
                    crossAxisSpacing: 12.0,
                  ),
                  sourceList: source,
                  indicatorBuilder: (context, status) {
                    return const LoadingIndicator();
                  },
                  itemBuilder: (c, item, index) {
                    if (widget.uniqueKey == const Key('Tab0')) {
                      /// 폴더 최대 16개 제한
                      return index == source.length - 1
                          ? GestureDetector(
                              onTap: () {},
                              child: Image(image: Assets.emptyFolder),
                            )
                          : FolderList(
                              folderColor: folderColors[index % 4],
                              onPress: () {},
                            );
                    }

                    return const HashtagList();
                  },
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
