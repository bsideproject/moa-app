import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:loading_more_list/loading_more_list.dart';
import 'package:moa_app/constants/app_constants.dart';
import 'package:moa_app/constants/file_constants.dart';
import 'package:moa_app/models/content_model.dart';
import 'package:moa_app/screens/home/home.dart';
import 'package:moa_app/screens/home/widgets/hashtag_card.dart';
import 'package:moa_app/screens/home/widgets/type_header.dart';
import 'package:moa_app/utils/router_provider.dart';
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
                // return source.refresh(true);
                return Future.delayed(
                  const Duration(seconds: 2),
                  () {
                    source.refresh(false);
                  },
                );
              },
              child: LoadingMoreList<ContentModel>(
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
                    // crossAxisCount: 2,
                    mainAxisSpacing: 20.0,
                    crossAxisSpacing: 12.0,
                  ),
                  sourceList: source,
                  indicatorBuilder: (context, status) {
                    if (status == IndicatorStatus.loadingMoreBusying) {
                      return const LoadingIndicator();
                    }
                    return const SizedBox();
                  },
                  itemBuilder: (c, item, index) {
                    // todo image width, height 계선해서 aspectRatio 주기
                    return AspectRatio(
                      aspectRatio: 0.7,
                      child: ContentCard(
                        onPressContent: () => goContentView('5'),
                        content: item,
                        onPressHashtag: (tag) => goHashtagDetailView(tag),
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
