import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:loading_more_list/loading_more_list.dart';
import 'package:moa_app/constants/app_constants.dart';
import 'package:moa_app/constants/file_constants.dart';
import 'package:moa_app/models/content_model.dart';
import 'package:moa_app/screens/home/content_view.dart';
import 'package:moa_app/screens/home/home.dart';
import 'package:moa_app/screens/home/widgets/content_card.dart';
import 'package:moa_app/screens/home/widgets/type_header.dart';
import 'package:moa_app/utils/router_provider.dart';
import 'package:moa_app/utils/utils.dart';
import 'package:moa_app/widgets/button.dart';
import 'package:moa_app/widgets/edit_text.dart';
import 'package:moa_app/widgets/loading_indicator.dart';

class HashtagTabView extends HookWidget {
  const HashtagTabView({
    super.key,
    required this.uniqueKey,
    required this.source,
    required this.count,
  });
  final Key uniqueKey;
  final HashtagSource source;
  final int count;

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;

    void goContentView(String contentId) {
      context.go(
        '${GoRoutes.content.fullPath}/$contentId',
        extra: ContentView(id: contentId, folderName: 'folderName'),
      );
    }

    void goHashtagDetailView(String tag) {
      context.go(
        '${GoRoutes.hashtag.fullPath}/$tag',
      );
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
                    return FutureBuilder(
                      future: getImageSize(imageURL: item.contentImageUrl),
                      builder: (context, snapshot) {
                        var rate = snapshot.data?.toDouble() ?? 1.4;

                        return AspectRatio(
                          aspectRatio: rate == 1.9
                              ? 0.6
                              : rate == 1.2
                                  ? 0.95
                                  : 0.7,
                          child: ContentCard(
                            onPressContent: () => goContentView(item.contentId),
                            content: item,
                            onPressHashtag: (tag) => goHashtagDetailView(tag),
                          ),
                        );
                      },
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
