import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:loading_more_list/loading_more_list.dart';
import 'package:moa_app/constants/app_constants.dart';
import 'package:moa_app/constants/color_constants.dart';
import 'package:moa_app/constants/file_constants.dart';
import 'package:moa_app/constants/font_constants.dart';
import 'package:moa_app/models/content_model.dart';
import 'package:moa_app/models/hashtag_model.dart';
import 'package:moa_app/providers/hashtag_provider.dart';
import 'package:moa_app/providers/hashtag_view_provider.dart';
import 'package:moa_app/repositories/content_repository.dart';
import 'package:moa_app/repositories/hashtag_repository.dart';
import 'package:moa_app/screens/home/content_view.dart';
import 'package:moa_app/screens/home/home.dart';
import 'package:moa_app/screens/home/widgets/content_card.dart';
import 'package:moa_app/screens/home/widgets/type_header.dart';
import 'package:moa_app/utils/router_provider.dart';
import 'package:moa_app/widgets/button.dart';
import 'package:moa_app/widgets/edit_text.dart';
import 'package:moa_app/widgets/image.dart';
import 'package:moa_app/widgets/loading_indicator.dart';
import 'package:moa_app/widgets/snackbar.dart';

class HashtagTabView extends HookConsumerWidget {
  const HashtagTabView({
    super.key,
    required this.uniqueKey,
    required this.source,
    required this.count,
    this.isRefresh,
  });
  final Key uniqueKey;
  final HashtagSource source;
  final int count;
  final bool? isRefresh;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var width = MediaQuery.of(context).size.width;
    var hashtagAsync = ref.watch(hashtagProvider);
    var searchFocusNode = useFocusNode();
    var searchTerms = useState<List<HashtagModel>>([]);
    var matchQuery = useState<List<HashtagModel>>([]);

    var searchTextController = useTextEditingController();
    var searchBarHeight = useState(0.0);

    var changeText = useState('');

    useEffect(() {
      if (isRefresh == true) {
        source.refresh(true);
      }
      return null;
    }, [isRefresh]);

    void goContentView({
      required String contentId,
      required String folderName,
      String? contentUrl,
    }) {
      context.go(
        '${GoRoutes.content.fullPath}/$contentId',
        extra: ContentView(
          id: contentId,
          folderName: folderName,
          contentType:
              contentUrl != '' ? AddContentType.url : AddContentType.image,
        ),
      );
    }

    void goHashtagDetailView(String tag) {
      // context.go(
      //   '${GoRoutes.hashtag.fullPath}/$tag',
      // );
    }

    void onPressFilter() {}

    void searchHashtag(String searchText) {
      changeText.value = searchText;
    }

    void onPressSearchHashtag() async {
      if (searchTextController.text == '') {
        return;
      }

      try {
        var (list, _) = await HashtagRepository.instance.getHashtagView(
          tag: searchTextController.text,
        );
        if (list.isEmpty) {
          if (context.mounted) {
            snackbar.alert(
                context, '#${searchTextController.text}로 모은 취향 콘텐츠가 없어요!');
          }
          return;
        }

        var tagId = list.first.contentHashTags
            .where((e) => e.hashTag == searchTextController.text)
            .toList()
            .first
            .tagId;

        if (context.mounted) {
          context.go(
            '${GoRoutes.hashtag.fullPath}/${searchTextController.text}?tagId=$tagId',
          );
        }
      } catch (error) {
        snackbar.alert(
            context, kDebugMode ? error.toString() : '오류가 발생했어요 다시 시도해주세요.');
      }
    }

    useEffect(() {
      if (searchTextController.text == '') {
        matchQuery.value = [];
        return;
      }

      for (var hash in searchTerms.value) {
        if (hash.hashTag.contains(searchTextController.text) &&
            !matchQuery.value.contains(hash)) {
          matchQuery.value.add(HashtagModel(
            tagId: hash.tagId,
            hashTag: hash.hashTag,
            count: hash.count,
          ));
        }
      }
      return null;
    }, [searchTextController.text]);

    useEffect(() {
      searchTerms.value = [
        ...hashtagAsync.value?.$1 ?? [],
        ...hashtagAsync.value?.$2 ?? []
      ];
      searchFocusNode.addListener(() {
        if (searchFocusNode.hasFocus) {
          searchBarHeight.value = 300;
        }

        if (!searchFocusNode.hasFocus) {
          searchBarHeight.value = 0;
        }
      });
      return null;
    }, [hashtagAsync.value]);

    return Stack(
      children: [
        Column(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 25),
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                children: [
                  EditText(
                    controller: searchTextController,
                    focusNode: searchFocusNode,
                    height: 50,
                    onChanged: searchHashtag,
                    hintText: '나의 해시태그 검색',
                    borderRadius: BorderRadius.circular(50),
                    suffixIcon: CircleIconButton(
                      icon: Image(
                        fit: BoxFit.contain,
                        image: Assets.searchIcon,
                        width: 16,
                        height: 16,
                      ),
                      onPressed: onPressSearchHashtag,
                    ),
                  ),
                  const SizedBox(height: 20),
                  TypeHeader(count: count, onPressFilter: onPressFilter),
                ],
              ),
            ),
            Expanded(
              child: ExtendedVisibilityDetector(
                uniqueKey: uniqueKey,
                child: RefreshIndicator(
                  onRefresh: () {
                    ref.refresh(hashtagViewProvider).value;
                    return source.refresh(true);
                  },
                  child: LoadingMoreList<ContentModel>(
                    onScrollNotification: (notification) {
                      if (notification is ScrollEndNotification) {
                        if (notification.metrics.pixels >
                            notification.metrics.maxScrollExtent - 100) {
                          source.loadMore();
                        }
                      }
                      return false;
                    },
                    ListConfig<ContentModel>(
                      physics: const BouncingScrollPhysics(),
                      addRepaintBoundaries: true,
                      padding: const EdgeInsets.only(
                        left: 15,
                        right: 15,
                        top: 15,
                        bottom: kBottomNavigationBarHeight,
                      ),
                      extendedListDelegate:
                          SliverWaterfallFlowDelegateWithFixedCrossAxisCount(
                        crossAxisCount: width > Breakpoints.md ? 3 : 2,
                        mainAxisSpacing: 20.0,
                        crossAxisSpacing: 12.0,
                      ),
                      sourceList: source,
                      indicatorBuilder: (context, status) {
                        if ((status == IndicatorStatus.loadingMoreBusying) ||
                            (status == IndicatorStatus.fullScreenBusying)) {
                          return const LoadingIndicator();
                        }
                        return const SizedBox();
                      },
                      itemBuilder: (c, item, index) {
                        return InkWell(
                          splashColor: Colors.transparent,
                          borderRadius: BorderRadius.circular(10),
                          onTap: () => goContentView(
                            contentId: item.contentId,
                            folderName: item.folderName ?? '',
                            contentUrl: item.contentUrl,
                          ),
                          child: Column(
                            children: [
                              ImageOnNetwork(
                                imageURL: item.thumbnailImageUrl,
                              ),
                              ContentCard(
                                content: item,
                                onPressHashtag: (tag) =>
                                    goHashtagDetailView(tag),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),

        /// 검색 결과 ui
        Positioned(
          top: 85,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            constraints: BoxConstraints(
              maxHeight: searchBarHeight.value,
            ),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 15),
              width: MediaQuery.of(context).size.width - 30,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: AppColors.hashtagBackground,
              ),
              child: matchQuery.value.isNotEmpty
                  ? ListView.builder(
                      physics: const ClampingScrollPhysics(),
                      shrinkWrap: true,
                      padding: const EdgeInsets.only(top: 20, bottom: 20),
                      itemCount: matchQuery.value.length,
                      itemBuilder: (context, index) {
                        var element = matchQuery.value[index];

                        return Material(
                          child: InkWell(
                            onTap: () {
                              context.go(
                                '${GoRoutes.hashtag.fullPath}/${element.hashTag}?tagId=${element.tagId}',
                              );
                              searchFocusNode.unfocus();
                              matchQuery.value = [];
                              searchTextController.clear();
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 25, vertical: 5),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '# ${element.hashTag}',
                                    style: const Hash1TextStyle().merge(
                                      const TextStyle(
                                          color: AppColors.subTitle,
                                          height: 1.6),
                                    ),
                                  ),
                                  Text(
                                    '${element.count}개',
                                    style: const Hash1TextStyle().merge(
                                      const TextStyle(
                                          color: AppColors.subTitle),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    )
                  : ListView.builder(
                      physics: const ClampingScrollPhysics(),
                      shrinkWrap: true,
                      padding: const EdgeInsets.only(top: 20, bottom: 20),
                      itemCount: searchTerms.value.length,
                      itemBuilder: (context, index) {
                        var element = searchTerms.value[index];

                        return Material(
                          child: InkWell(
                            onTap: () {
                              context.go(
                                '${GoRoutes.hashtag.fullPath}/${element.hashTag}?tagId=${element.tagId}',
                              );
                              searchFocusNode.unfocus();
                              searchTextController.text = '';
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 25, vertical: 5),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '# ${element.hashTag}',
                                    style: const Hash1TextStyle().merge(
                                      const TextStyle(
                                          color: AppColors.subTitle,
                                          height: 1.6),
                                    ),
                                  ),
                                  Text(
                                    '${element.count}개',
                                    style: const Hash1TextStyle().merge(
                                      const TextStyle(
                                          color: AppColors.subTitle),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ),
        )
      ],
    );
  }
}
