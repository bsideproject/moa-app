import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:moa_app/constants/color_constants.dart';
import 'package:moa_app/constants/file_constants.dart';
import 'package:moa_app/constants/font_constants.dart';
import 'package:moa_app/models/content_model.dart';
import 'package:moa_app/models/hashtag_model.dart';
import 'package:moa_app/providers/hashtag_provider.dart';
import 'package:moa_app/repositories/hashtag_repository.dart';
import 'package:moa_app/screens/home/widgets/type_header.dart';
import 'package:moa_app/utils/general.dart';
import 'package:moa_app/widgets/app_bar.dart';
import 'package:moa_app/widgets/button.dart';
import 'package:moa_app/widgets/edit_text.dart';
import 'package:moa_app/widgets/loading_indicator.dart';
import 'package:moa_app/widgets/moa_widgets/bottom_modal_item.dart';
import 'package:moa_app/widgets/moa_widgets/delete_content.dart';
import 'package:moa_app/widgets/moa_widgets/dynamic_grid_list.dart';
import 'package:moa_app/widgets/moa_widgets/edit_content.dart';
import 'package:moa_app/widgets/snackbar.dart';

class HashtagDetailView extends HookConsumerWidget {
  const HashtagDetailView({
    super.key,
    required this.filterName,
    required this.tagId,
  });
  final String filterName;
  final String tagId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var hashtagAsync = ref.watch(hashtagProvider);
    var gridController = useScrollController();
    var gridPageNum = useState(20);
    var updatedHashtagName = useState('');

    var searchFocusNode = useFocusNode();
    var searchTerms = useState<List<HashtagModel>>([]);
    var matchQuery = useState<List<HashtagModel>>([]);

    var searchTextController = useTextEditingController();
    var searchBarHeight = useState(0.0);

    var searchHashText = useState(filterName);
    var searchTagId = useState(tagId);
    var changeText = useState('');

    void showEditHashtagModal() {
      General.instance.showBottomSheet(
        context: context,
        child: EditContent(
          title: '해시태그 수정',
          onPressed: () async {
            try {
              await HashtagRepository.instance.editHashtag(
                tagId: searchTagId.value,
                hashtags: updatedHashtagName.value,
              );
              await ref.read(hashtagProvider.notifier).editHashtag(
                    tagId: searchTagId.value,
                    hashtags: updatedHashtagName.value,
                  );

              searchHashText.value = updatedHashtagName.value;
              if (context.mounted) {
                context.pop();
              }
            } catch (e) {
              snackbar.alert(
                  context, kDebugMode ? e.toString() : '해시태그 수정에 실패했습니다.');
            }
          },
          updatedContentName: updatedHashtagName,
          contentName: searchHashText.value,
        ),
      );
    }

    void showDeleteHashtagModal() {
      General.instance.showBottomSheet(
        height: 300,
        context: context,
        isCloseButton: true,
        child: DeleteContent(
          folderColor: AppColors.folderColorECD8F3,
          contentName: searchHashText.value,
          type: ContentType.hashtag,
          onPressed: () async {
            try {
              await HashtagRepository.instance
                  .deleteHashtag(tagIds: [searchTagId.value]);
              await ref
                  .read(hashtagProvider.notifier)
                  .deleteHashtag(tagIds: [searchTagId.value]);
              if (context.mounted) {
                context.pop();
                context.pop();
              }
            } catch (e) {
              snackbar.alert(
                  context, kDebugMode ? e.toString() : '해시태그 삭제에 실패했습니다.');
            }
          },
        ),
      );
    }

    void showHashtagDetailModal() {
      General.instance.showBottomSheet(
        context: context,
        padding:
            const EdgeInsets.only(left: 15, right: 15, top: 15, bottom: 30),
        height: 190,
        child: Column(
          children: [
            BottomModalItem(
              icon: Assets.pencil,
              title: '해시태그 수정',
              onPressed: () {
                context.pop();
                showEditHashtagModal();
              },
            ),
            BottomModalItem(
              icon: Assets.trash,
              title: '해시태그 삭제',
              onPressed: () {
                context.pop();
                showDeleteHashtagModal();
              },
            ),
          ],
        ),
      );
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
            snackbar.alert(context, '검색 결과가 없습니다.');
          }
          return;
        }
        searchHashText.value = searchTextController.text;
        var tagId = list.first.contentHashTags
            .where((e) => e.hashTag == searchTextController.text)
            .toList()
            .first
            .tagId;

        searchTagId.value = tagId;
      } catch (error) {
        snackbar.alert(
            context, kDebugMode ? error.toString() : '오류가 발생했어요 다시 시도해주세요.');
      }
    }

    useEffect(() {
      gridController.addListener(() {
        /// load date at when scroll reached -100
        if (gridController.position.pixels >
            gridController.position.maxScrollExtent - 100) {
          gridPageNum.value += gridPageNum.value;
        }
      });

      return null;
    }, []);

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
      searchTerms.value = hashtagAsync.value ?? [];

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

    void searchHashtag(String searchText) {
      changeText.value = searchText;
    }

    return Scaffold(
      appBar: AppBarBack(
          isBottomBorderDisplayed: false,
          text: RichText(
              text: TextSpan(children: [
            TextSpan(
              text: '#${searchHashText.value}',
              style: const H1TextStyle().merge(
                const TextStyle(
                  color: AppColors.primaryColor,
                ),
              ),
            ),
            const TextSpan(
              text: '의 취향들',
              style: H1TextStyle(),
            ),
          ])),
          actions: [
            CircleIconButton(
              backgroundColor: AppColors.whiteColor,
              icon: Image(
                width: 36,
                height: 36,
                image: Assets.menu,
              ),
              onPressed: showHashtagDetailModal,
            ),
          ]),
      body: SafeArea(
          child: Stack(
        children: [
          Column(
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
              Expanded(
                child: useMemoized(
                  () => HashtagDetailList(
                    searchHashText: searchHashText,
                  ),
                  [searchHashText.value],
                ),
              ),
            ],
          ),

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
                                searchTagId.value = element.tagId;
                                searchHashText.value = element.hashTag;
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
                        shrinkWrap: true,
                        padding: const EdgeInsets.only(top: 20, bottom: 20),
                        itemCount: searchTerms.value.length,
                        itemBuilder: (context, index) {
                          var element = searchTerms.value[index];

                          return Material(
                            child: InkWell(
                              onTap: () {
                                searchTagId.value = element.tagId;
                                searchHashText.value = element.hashTag;
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
      )),
    );
  }
}

class HashtagDetailList extends HookConsumerWidget {
  const HashtagDetailList({
    super.key,
    required this.searchHashText,
  });
  final ValueNotifier<String> searchHashText;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Future<void> pullToRefresh() async {
      return Future.delayed(
        const Duration(seconds: 2),
        () {},
      );
    }

    void onPressFilter() {}

    return FutureBuilder<(List<ContentModel>, int)>(
      future:
          HashtagRepository.instance.getHashtagView(tag: searchHashText.value),
      builder: (context, snapshot) {
        var (list, _) = snapshot.data ?? ([], 0);

        return AnimatedSwitcher(
          transitionBuilder: (child, animation) {
            return FadeTransition(opacity: animation, child: child);
          },
          duration: const Duration(milliseconds: 300),
          child: () {
            var hashCount = list
                .expand((element) => element.contentHashTags)
                .where((element) => element.hashTag == searchHashText.value)
                .length;
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const LoadingIndicator();
            }
            if (snapshot.hasData && list.isNotEmpty) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    TypeHeader(count: hashCount, onPressFilter: onPressFilter),
                    const SizedBox(height: 5),
                    Expanded(
                        child: DynamicGridList(
                      contentList: list as List<ContentModel>,
                      pullToRefresh: pullToRefresh,
                    )),
                  ],
                ),
              );
            }
            return const SizedBox();
          }(),
        );
      },
    );
  }
}
