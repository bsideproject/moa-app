import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:moa_app/constants/color_constants.dart';
import 'package:moa_app/constants/font_constants.dart';
import 'package:moa_app/models/hashtag_model.dart';
import 'package:moa_app/providers/hashtag_provider.dart';
import 'package:moa_app/utils/router_provider.dart';

class CustomSearchDelegate extends HookConsumerWidget {
  const CustomSearchDelegate({
    super.key,
    required this.searchBarHeight,
    required this.matchQuery,
    required this.searchFocusNode,
    required this.searchTextController,
    required this.searchTerms,
  });
  final ValueNotifier<double> searchBarHeight;
  final ValueNotifier<List<HashtagModel>> matchQuery;
  final FocusNode searchFocusNode;
  final TextEditingController searchTextController;
  final ValueNotifier<(List<HashtagModel>, List<HashtagModel>)> searchTerms;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var hashtagAsync = ref.watch(hashtagProvider);

    useEffect(() {
      if (context.mounted) {
        searchTerms.value = hashtagAsync.value ?? ([], []);
        searchFocusNode.addListener(() {
          if (searchFocusNode.hasFocus) {
            searchBarHeight.value = 300;
          }

          if (!searchFocusNode.hasFocus) {
            searchBarHeight.value = 0;
          }
        });
      }
      return null;
    }, [hashtagAsync.value]);

    return

        /// 검색 결과 ui
        Positioned(
      top: 60,
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
                  shrinkWrap: true,
                  padding: const EdgeInsets.only(top: 20, bottom: 20),
                  itemCount: matchQuery.value.length,
                  itemBuilder: (context, index) {
                    var element = matchQuery.value[index];

                    return Material(
                      child: InkWell(
                        onTap: () {
                          context.go(
                            '${GoRoutes.hashtag.fullPath}/${element.hashTag}',
                          );
                          searchFocusNode.unfocus();
                          matchQuery.value = [];
                          searchTextController.clear();
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 25, vertical: 5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '# ${element.hashTag}',
                                style: const Hash1TextStyle().merge(
                                  const TextStyle(
                                      color: AppColors.subTitle, height: 1.6),
                                ),
                              ),
                              Text(
                                '${element.count}개',
                                style: const Hash1TextStyle().merge(
                                  const TextStyle(color: AppColors.subTitle),
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
                  shrinkWrap: true,
                  padding: const EdgeInsets.only(top: 20, bottom: 20),
                  itemCount: searchTerms.value.$1.length,
                  itemBuilder: (context, index) {
                    var element = searchTerms.value.$1[index];

                    return Material(
                      child: InkWell(
                        onTap: () {
                          context.go(
                            '${GoRoutes.hashtag.fullPath}/${element.hashTag}',
                          );
                          searchFocusNode.unfocus();
                          searchTextController.text = '';
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 25, vertical: 5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '# ${element.hashTag}',
                                style: const Hash1TextStyle().merge(
                                  const TextStyle(
                                      color: AppColors.subTitle, height: 1.6),
                                ),
                              ),
                              Text(
                                '${element.count}개',
                                style: const Hash1TextStyle().merge(
                                  const TextStyle(color: AppColors.subTitle),
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
    );
  }
}
