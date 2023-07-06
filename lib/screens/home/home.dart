import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:loading_more_list/loading_more_list.dart';
import 'package:moa_app/constants/color_constants.dart';
import 'package:moa_app/constants/file_constants.dart';
import 'package:moa_app/constants/font_constants.dart';
import 'package:moa_app/models/folder_model.dart';
import 'package:moa_app/models/hashtag_model.dart';
import 'package:moa_app/providers/button_click_provider.dart';
import 'package:moa_app/screens/home/tab_view/folder_tab_view.dart';
import 'package:moa_app/screens/home/tab_view/hashtag_tab_view.dart';
import 'package:moa_app/screens/home/widgets/moa_comment_img.dart';

class Home extends HookConsumerWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var isClick = ref.watch(buttonClickStateProvider);
    var tabIdx = useState(0);
    TabController tabController = useTabController(initialLength: 2);

    // Future<void> getFolderList() async {
    //   await FolderRepository.instance.getFolderList();
    // }

    useEffect(() {
      /// SliverPersistentHeader의 tab icon 색깔 리렌더를 위해서 addListener 사용
      tabController.addListener(() {
        if (tabController.index == 0) {
          tabIdx.value = 0;
        } else {
          tabIdx.value = 1;
        }
      });
      return null;
    }, []);

    return Container(
      color: AppColors.backgroundColor,
      child: SafeArea(
        child: Scaffold(
          body: DefaultTabController(
            length: 2,
            child: ExtendedNestedScrollView(
              onlyOneScrollInBody: true,
              floatHeaderSlivers: true,
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
                            style: H1TextStyle(),
                          ),
                          const SizedBox(height: 5),
                          Row(
                            children: [
                              Text(
                                '#카페러버',
                                style: const Body1TextStyle().merge(
                                  TextStyle(
                                    color:
                                        AppColors.blackColor.withOpacity(0.3),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 5),
                              Text(
                                '#취미부자',
                                style: const Body1TextStyle().merge(
                                  TextStyle(
                                    color:
                                        AppColors.blackColor.withOpacity(0.3),
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
                    // floating: true,
                  ),
                ];
              },
              body: TabBarView(
                // physics: const NeverScrollableScrollPhysics(),
                controller: tabController,
                children: const <Widget>[
                  TabViewItem(Key('folderTab')),
                  TabViewItem(Key('hashtagTab')),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class PersistentTabBar extends SliverPersistentHeaderDelegate {
  const PersistentTabBar({
    required this.isClick,
    required this.tabController,
    this.backgroundColor,
    this.isEditScreen = false,
  });
  final bool isClick;
  final TabController tabController;
  final Color? backgroundColor;
  final bool isEditScreen;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: backgroundColor ?? AppColors.backgroundColor,
      child: Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
          color: AppColors.whiteColor,
        ),
        child: Padding(
          padding: EdgeInsets.only(
            left: 15,
            right: 15,
            top: isEditScreen ? 0 : 20,
          ),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 25, bottom: 10),
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
                            text: tabController.index == 0
                                ? '146개의 폴더'
                                : '146개의 취향',
                            style: const H1TextStyle().merge(
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
                        color: AppColors.moaSecondary,
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
        ),
      ),
    );
  }

  @override
  double get maxExtent => isEditScreen ? 99 : 117;

  @override
  double get minExtent => isEditScreen ? 99 : 117;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}

class FolderSource extends LoadingMoreBase<FolderModel> {
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
        add(const FolderModel(id: '0', title: 'title', content: 'content'));
      }

      add(
        const FolderModel(
          id: '0',
          title: 'title',
          content: 'content',
        ),
      );

      return true;
    });
  }
}

class HashtagSource extends LoadingMoreBase<HashtagModel> {
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
      // if (pageIndex == 1) {
      //   clear();
      // }
      for (int i = 0; i < 4; i++) {
        add(HashtagModel(
          title: 'title',
          description: 'description',
          tags: ['tag1', 'tag2'],
        ));
      }

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
  late final FolderSource folderSource = FolderSource();
  late final HashtagSource hashtagSource = HashtagSource();

  @override
  void dispose() {
    folderSource.dispose();
    hashtagSource.dispose();

    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    if (widget.uniqueKey == const Key('folderTab')) {
      return FolderTabView(uniqueKey: widget.uniqueKey, source: folderSource);
    }
    return HashtagTabView(uniqueKey: widget.uniqueKey, source: hashtagSource);
  }
}
