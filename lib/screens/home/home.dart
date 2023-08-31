import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_branch_sdk/flutter_branch_sdk.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:loading_more_list/loading_more_list.dart';
import 'package:moa_app/constants/color_constants.dart';
import 'package:moa_app/constants/file_constants.dart';
import 'package:moa_app/constants/font_constants.dart';
import 'package:moa_app/models/content_model.dart';
import 'package:moa_app/models/folder_model.dart';
import 'package:moa_app/providers/button_click_provider.dart';
import 'package:moa_app/providers/folder_view_provider.dart';
import 'package:moa_app/providers/hashtag_view_provider.dart';
import 'package:moa_app/providers/user_provider.dart';
import 'package:moa_app/repositories/hashtag_repository.dart';
import 'package:moa_app/screens/home/tab_view/folder_tab_view.dart';
import 'package:moa_app/screens/home/tab_view/hashtag_tab_view.dart';
import 'package:moa_app/screens/home/widgets/moa_comment_img.dart';
import 'package:moa_app/utils/logger.dart';
import 'package:moa_app/widgets/loading_indicator.dart';

class Home extends HookConsumerWidget {
  const Home({super.key, this.isRefresh = false});
  final bool isRefresh;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var userAsync = ref.watch(userStateProvider);
    ref.watch(folderViewProvider);
    ref.watch(hashtagViewProvider);
    var folderAsync = ref.watch(folderViewProvider.notifier);
    var hashtagAsync = ref.watch(hashtagViewProvider.notifier);

    var isClick = ref.watch(buttonClickStateProvider);
    var tabIdx = useState(0);
    TabController tabController = useTabController(initialLength: 2);

    var folderCount = useState(0);
    var contentCount = useState(0);

    /// SliverPersistentHeader의 tab icon 색깔 리렌더를 위해서 addListener 사용
    tabController.addListener(() {
      if (tabController.index == 0) {
        tabIdx.value = 0;
      } else {
        tabIdx.value = 1;
      }
    });

    FlutterBranchSdk.initSession().listen((data) {
      if (data.containsKey('+clicked_branch_link') &&
          data['+clicked_branch_link'] == true) {
        if (context.mounted) {
          context.push('${data['\$canonical_identifier']}');
        }
      }
      return;
    });

    return Container(
      color: AppColors.backgroundColor,
      child: SafeArea(
        child: Scaffold(
          body: DefaultTabController(
            length: 2,
            child: ExtendedNestedScrollView(
              physics: const BouncingScrollPhysics(),
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
                      title: userAsync.when(
                        error: (error, stackTrace) {
                          return const SizedBox();
                        },
                        loading: () => Container(
                          margin: const EdgeInsets.only(right: 150),
                          alignment: Alignment.centerLeft,
                          child: const LoadingIndicator(),
                        ),
                        data: (userInfo) {
                          return Container(
                            margin: const EdgeInsets.only(right: 150),
                            alignment: Alignment.centerLeft,
                            child: RichText(
                              text: TextSpan(
                                text: '안녕하세요,\n${userInfo?.nickname}님!',
                                style: const H1TextStyle(),
                              ),
                            ),
                          );
                        },
                      )),
                  SliverPersistentHeader(
                    delegate: PersistentTabBar(
                      tabController: tabController,
                      isClick: isClick,
                      folderCount: folderCount.value,
                      contentCount: contentCount.value,
                    ),
                    pinned: true,
                    // floating: true,
                  ),
                ];
              },
              body: TabBarView(
                controller: tabController,
                children: <Widget>[
                  TabViewItem(
                    isRefresh: isRefresh,
                    folderList: folderAsync,
                    uniqueKey: const Key('folderTab'),
                    folderCount: folderCount,
                    contentCount: contentCount,
                  ),
                  TabViewItem(
                    isRefresh: isRefresh,
                    hashList: hashtagAsync,
                    uniqueKey: const Key('hashtagTab'),
                    folderCount: folderCount,
                    contentCount: contentCount,
                  ),
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
    required this.folderCount,
    required this.contentCount,
    this.isEditMyType = false,
    this.backgroundColor,
    this.isEditScreen = false,
  });
  final bool isClick;
  final TabController tabController;
  final int folderCount;
  final int contentCount;
  final bool isEditMyType;
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
                                ? '$folderCount개의 폴더'
                                : isEditMyType
                                    ? '$contentCount개의 해시태그'
                                    : '$contentCount개의 취향',
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
  FolderSource({
    required this.folderCount,
    required this.futureList,
  });
  final ValueNotifier<int> folderCount;
  final FolderView? futureList;

  var count = 0;
  int pageIndex = 1;
  bool _hasMore = false;
  bool forceRefresh = false;
  @override
  bool get hasMore => (_hasMore && length < 20) || forceRefresh;

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
  Future<bool> loadData([bool isloadMoreAction = false]) async {
    bool isSuccess = false;
    try {
      var list = await futureList!.future;
      folderCount.value = list.length;

      add(
        const FolderModel(
            folderId: 'add', folderName: '폴더 추가', count: 0, thumbnailUrl: ''),
      );

      for (FolderModel folder in list) {
        if (!contains(folder) && _hasMore) {
          add(folder);
        }
      }

      _hasMore = false;
      pageIndex++;
      isSuccess = true;
    } catch (error) {
      isSuccess = false;
      logger.d(error);
    }
    return isSuccess;
  }
}

class HashtagSource extends LoadingMoreBase<ContentModel> {
  HashtagSource({required this.contentCount, required this.futureList});
  final ValueNotifier<int> contentCount;
  final HashtagView? futureList;

  int pageIndex = 0;
  int size = 10;
  bool _hasMore = true;
  bool forceRefresh = false;

  var contentList = <ContentModel>[];
  @override
  bool get hasMore => _hasMore || forceRefresh;

  @override
  Future<bool> refresh([bool notifyStateChanged = false]) async {
    _hasMore = true;
    pageIndex = 0;
    contentList = [];
    //force to refresh list when you don't want clear list before request
    //for the case, if your list already has 20 items.
    forceRefresh = !notifyStateChanged;
    var result = await super.refresh(notifyStateChanged);
    forceRefresh = false;
    return result;
  }

  @override
  Future<bool> loadData([bool isloadMoreAction = false]) async {
    bool isSuccess = false;
    try {
      if (pageIndex == 0) {
        var (initialList, count) = await futureList!.future;
        // 최초렌더시 컨텐츠 전체 개수 가져오기
        contentCount.value = count;

        contentList.addAll(initialList);

        for (ContentModel content in contentList) {
          if (!contains(content)) {
            add(content);
          }
        }

        if (contentList.length < size) {
          _hasMore = false;
        }
        if (_hasMore) {
          pageIndex++;
        }
        isSuccess = true;

        return true;
      }

      if (_hasMore) {
        var (list, _) = await HashtagRepository.instance
            .getHashtagView(page: pageIndex, size: size);
        contentList = [...contentList, ...list];
        for (ContentModel content in contentList) {
          if (!contains(content)) {
            add(content);
          }
        }
        if (list.length < size) {
          _hasMore = false;
        }

        if (_hasMore) {
          pageIndex++;
        }
        isSuccess = true;
      }
    } catch (e) {
      isSuccess = false;

      logger.d(e);
    }
    return isSuccess;
  }
}

class TabViewItem extends HookConsumerWidget {
  const TabViewItem({
    super.key,
    required this.uniqueKey,
    this.folderList,
    this.hashList,
    required this.folderCount,
    required this.contentCount,
    this.isRefresh,
  });
  final Key uniqueKey;
  final FolderView? folderList;
  final HashtagView? hashList;
  final ValueNotifier<int> folderCount;
  final ValueNotifier<int> contentCount;
  final bool? isRefresh;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var folderWatch = ref.watch(folderViewProvider);
    var hashWatch = ref.watch(hashtagViewProvider);
    var folderAsync = ref.watch(folderViewProvider.notifier);
    var hashtagAsync = ref.watch(hashtagViewProvider.notifier);
    useAutomaticKeepAlive(wantKeepAlive: true);

    FolderSource folderSource = FolderSource(
      futureList: folderAsync,
      folderCount: folderCount,
    );
    HashtagSource hashtagSource = HashtagSource(
      futureList: hashtagAsync,
      contentCount: contentCount,
    );

    useEffect(() {
      return () {
        folderSource.dispose();
        hashtagSource.dispose();
      };
    }, []);

    if (uniqueKey == const Key('folderTab')) {
      return useMemoized(() {
        return FolderTabView(
          isRefresh: isRefresh,
          uniqueKey: uniqueKey,
          source: folderSource,
        );
      }, [folderWatch]);
    }
    return useMemoized(
        () => HashtagTabView(
              isRefresh: isRefresh,
              uniqueKey: uniqueKey,
              source: hashtagSource,
              count: contentCount.value,
            ),
        [contentCount.value, hashWatch]);
  }
}
