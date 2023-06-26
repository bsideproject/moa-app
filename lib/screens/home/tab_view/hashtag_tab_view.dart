import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:loading_more_list/loading_more_list.dart';
import 'package:moa_app/constants/app_constants.dart';
import 'package:moa_app/constants/file_constants.dart';
import 'package:moa_app/models/hashtag_model.dart';
import 'package:moa_app/screens/home/hashtag_detail_view.dart';
import 'package:moa_app/screens/home/home.dart';
import 'package:moa_app/screens/home/widgets/hashtag_card.dart';
import 'package:moa_app/screens/home/widgets/type_header.dart';
import 'package:moa_app/utils/router_provider.dart';
import 'package:moa_app/widgets/button.dart';
import 'package:moa_app/widgets/edit_text.dart';
import 'package:moa_app/widgets/loading_indicator.dart';

class HashtagTabView extends HookWidget {
  const HashtagTabView(
      {super.key, required this.uniqueKey, required this.source});
  final Key uniqueKey;
  final HashtagSource source;

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;

    void goHashtagDetailView(String tag) {
      context.push(
        '${GoRoutes.home.fullPath}/${GoRoutes.hashtagDetail.path}/$tag',
        extra: HashtagDetailView(filterName: tag),
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
              const SizedBox(height: 20),
              TypeHeader(typeCount: 146, onPressFilter: () {}),
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
              child: LoadingMoreList<HashtagModel>(
                ListConfig<HashtagModel>(
                  addRepaintBoundaries: true,
                  padding: const EdgeInsets.only(
                    left: 15,
                    right: 15,
                    top: 15,
                    bottom: kBottomNavigationBarHeight,
                  ),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: width > Breakpoints.md ? 4 : 2,
                    childAspectRatio: 0.7,
                    mainAxisSpacing: 20.0,
                    crossAxisSpacing: 12.0,
                  ),
                  sourceList: source,
                  indicatorBuilder: (context, status) {
                    return const LoadingIndicator();
                  },
                  itemBuilder: (c, item, index) {
                    return HashtagCard(
                      hashtag: item,
                      onPressHashtag: (tag) => goHashtagDetailView(tag),
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
