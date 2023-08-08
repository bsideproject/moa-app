import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:loading_more_list/loading_more_list.dart';
import 'package:moa_app/constants/app_constants.dart';
import 'package:moa_app/constants/file_constants.dart';
import 'package:moa_app/models/content_model.dart';
import 'package:moa_app/providers/hashtag_view_provider.dart';
import 'package:moa_app/repositories/content_repository.dart';
import 'package:moa_app/screens/home/content_view.dart';
import 'package:moa_app/screens/home/home.dart';
import 'package:moa_app/screens/home/widgets/content_card.dart';
import 'package:moa_app/screens/home/widgets/type_header.dart';
import 'package:moa_app/utils/router_provider.dart';
import 'package:moa_app/widgets/button.dart';
import 'package:moa_app/widgets/edit_text.dart';
import 'package:moa_app/widgets/image.dart';
import 'package:moa_app/widgets/loading_indicator.dart';

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
          source: source,
          contentType:
              contentUrl != null ? AddContentType.url : AddContentType.image,
        ),
      );
    }

    void goHashtagDetailView(String tag) {
      // context.go(
      //   '${GoRoutes.hashtag.fullPath}/$tag',
      // );
    }

    return Column(
      children: [
        Container(
          margin: const EdgeInsets.only(top: 25),
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            children: [
              EditText(
                height: 50,
                onChanged: (value) {},
                hintText: '나의 해시태그 검색',
                borderRadius: BorderRadius.circular(50),
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
              const SizedBox(height: 20),
              TypeHeader(count: count, onPressFilter: () {}),
              const SizedBox(height: 5),
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
                    if (notification.metrics.pixels ==
                        notification.metrics.maxScrollExtent) {
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
                          item.thumbnailImageUrl == ''
                              ? const Text('이미지 없을 경우 모아 이미지로 대체')
                              : AspectRatio(
                                  aspectRatio: 1,
                                  child: ImageOnNetwork(
                                    imageURL: item.thumbnailImageUrl,
                                  ),
                                ),
                          ContentCard(
                            content: item,
                            onPressHashtag: (tag) => goHashtagDetailView(tag),
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
    );
  }
}
