import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:moa_app/constants/color_constants.dart';
import 'package:moa_app/constants/file_constants.dart';
import 'package:moa_app/constants/font_constants.dart';
import 'package:moa_app/models/hashtag_model.dart';
import 'package:moa_app/providers/hashtag_provider.dart';
import 'package:moa_app/repositories/hashtag_repository.dart';
import 'package:moa_app/screens/add_content/add_image_content.dart';
import 'package:moa_app/screens/home/widgets/hashtag_button.dart';
import 'package:moa_app/utils/general.dart';
import 'package:moa_app/widgets/button.dart';
import 'package:moa_app/widgets/edit_text.dart';
import 'package:moa_app/widgets/loading_indicator.dart';
import 'package:moa_app/widgets/moa_widgets/delete_content.dart';
import 'package:moa_app/widgets/moa_widgets/edit_content.dart';
import 'package:moa_app/widgets/moa_widgets/hashtag_box.dart';
import 'package:moa_app/widgets/snackbar.dart';

class EditHashtag extends HookConsumerWidget {
  const EditHashtag({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    useAutomaticKeepAlive(wantKeepAlive: true);
    var hashtagAsync = ref.watch(hashtagProvider);
    var textController = useTextEditingController();
    var selectedTagList = useState<List<SelectedTagModel>>([]);
    var isDeleteMode = useState(false);
    var hashtagText = useState('');

    var updatedHashtagName = useState('');

    void addHashtag() async {
      if (textController.text.isEmpty) {
        return;
      }

      if (selectedTagList.value.length == 13) {
        if (context.mounted) {
          snackbar.alert(context, '더 이상 해시태그를 추가할 수 없습니다.');
        }
        return;
      }

      if (selectedTagList.value
          .map((e) => e.name)
          .contains(textController.text)) {
        return;
      }

      await ref
          .read(hashtagProvider.notifier)
          .addHashtag(hashtag: textController.text);

      selectedTagList.value = [
        SelectedTagModel(
          isSelected: false,
          name: textController.text,
        ),
        ...selectedTagList.value,
      ];

      textController.text = '';
    }

    void onCancelDeleteMode() {
      selectedTagList.value = selectedTagList.value
          .map((e) =>
              SelectedTagModel(tagId: e.tagId, isSelected: false, name: e.name))
          .toList();
      isDeleteMode.value = false;
    }

    void showHashEditModal({required String hashtag, String? tagId}) {
      if (tagId == null) {
        return;
      }
      General.instance.showBottomSheet(
        context: context,
        child: EditContent(
          title: '해시태그 수정',
          onPressed: () async {
            try {
              await HashtagRepository.instance.editHashtag(
                tagId: tagId,
                hashtags: updatedHashtagName.value,
              );
              await ref.read(hashtagProvider.notifier).editHashtag(
                    tagId: tagId,
                    hashtags: updatedHashtagName.value,
                  );

              hashtag = updatedHashtagName.value;
              if (context.mounted) {
                context.pop();
              }
            } catch (e) {
              if (context.mounted) {
                snackbar.alert(
                    context, kDebugMode ? e.toString() : '해시태그 수정에 실패했습니다.');
              }
            } finally {}
          },
          updatedContentName: updatedHashtagName,
          contentName: hashtag,
        ),
      );
    }

    void selectHashButton({
      required bool value,
      required SelectedTagModel tag,
    }) {
      if (!isDeleteMode.value) {
        showHashEditModal(tagId: tag.tagId, hashtag: tag.name);
        return;
      }

      selectedTagList.value = selectedTagList.value.map((e) {
        if (e.name == tag.name) {
          return SelectedTagModel(
            tagId: e.tagId,
            name: e.name,
            isSelected: value,
          );
        }
        return e;
      }).toList();
    }

    void pressDeleteHash() {
      if (selectedTagList.value.every((element) => !element.isSelected)) {
        return;
      }

      var selectedList =
          selectedTagList.value.where((element) => element.isSelected).toList();

      General.instance.showBottomSheet(
        height: 300,
        context: context,
        isCloseButton: true,
        child: DeleteContent(
          folderColor: AppColors.folderColorECD8F3,
          contentName: selectedList.length > 1
              ? '${selectedList.length}개의'
              : selectedList.first.name,
          isMultiContent: selectedList.length > 1,
          type: ContentType.hashtag,
          onPressed: () async {
            try {
              await HashtagRepository.instance.deleteHashtag(
                tagIds: selectedList.map((e) => e.tagId!).toList(),
              );
              await ref.read(hashtagProvider.notifier).deleteHashtag(
                    tagIds: selectedList.map((e) => e.tagId!).toList(),
                  );
              if (context.mounted) {
                context.pop();
              }
            } catch (e) {
              if (context.mounted) {
                snackbar.alert(
                    context, kDebugMode ? e.toString() : '해시태그 삭제에 실패했습니다.');
              }
            }
          },
        ),
      );
    }

    useEffect(() {
      if (hashtagAsync.hasValue) {
        selectedTagList.value = hashtagAsync.value!.$1
            .map((e) => SelectedTagModel(
                tagId: e.tagId, name: e.hashTag, isSelected: false))
            .toList();
      }
      return null;
    }, [hashtagAsync.isLoading]);

    return SingleChildScrollView(
      padding: const EdgeInsets.only(
          left: 15, right: 15, top: 20, bottom: kBottomNavigationBarHeight),
      physics: const ClampingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '기본 해시태그',
            style: H4TextStyle(),
          ),
          const SizedBox(height: 10),
          useMemoized(
              () => FutureBuilder<(List<HashtagModel>, List<HashtagModel>)>(
                  future: HashtagRepository.instance.getHashtagList(),
                  builder: (context, snapshot) {
                    var data = snapshot.data ?? ([], []);

                    return AnimatedSwitcher(
                      transitionBuilder: (child, animation) {
                        return FadeTransition(opacity: animation, child: child);
                      },
                      duration: const Duration(milliseconds: 300),
                      child: () {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const LoadingIndicator();
                        }
                        if (snapshot.hasData) {
                          return SizedBox(
                            width: double.infinity,
                            child: Wrap(
                              spacing: 10,
                              runSpacing: 10,
                              crossAxisAlignment: WrapCrossAlignment.center,
                              children: [
                                ...data.$2.map((tag) {
                                  return HashtagButton(
                                    text: '#${tag.hashTag}',
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 20,
                                      vertical: 8,
                                    ),
                                    style: const H4TextStyle().merge(
                                      const TextStyle(
                                          color: AppColors.subTitle),
                                    ),
                                  );
                                }).toList()
                              ],
                            ),
                          );
                        }
                        return const SizedBox();
                      }(),
                    );
                  }),
              []),
          const SizedBox(height: 30),
          const Text(
            '해시태그 생성',
            style: H4TextStyle(),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: EditText(
                  maxLength: 7,
                  controller: textController,
                  hintText: '새로운 해시태그를 입력해주세요.',
                  onChanged: (value) {
                    hashtagText.value = value;
                  },
                ),
              ),
              const SizedBox(width: 5),
              CircleIconButton(
                width: 50,
                height: 50,
                backgroundColor: AppColors.primaryColor,
                icon: const Icon(
                  Icons.add,
                  size: 30,
                ),
                onPressed: addHashtag,
              ),
            ],
          ),
          Row(
            children: [
              const Spacer(),
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  '${textController.text.characters.length}/7',
                  style: TextStyle(
                      color: textController.text.characters.length >= 7
                          ? AppColors.danger
                          : AppColors.blackColor.withOpacity(0.3),
                      fontSize: 12,
                      fontFamily: FontConstants.pretendard),
                ),
              ),
              const SizedBox(width: 65),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () => isDeleteMode.value = true,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Wrap(
                    direction: Axis.horizontal,
                    children: [
                      Image(width: 16, height: 16, image: Assets.trash),
                      const SizedBox(width: 2),
                      Text(
                        isDeleteMode.value ? '해시태그 선택' : '선택하여 삭제하기',
                        style: const Hash1TextStyle(),
                      )
                    ],
                  ),
                ),
              ),
              isDeleteMode.value
                  ? GestureDetector(
                      onTap: onCancelDeleteMode,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Text(
                          '취소하기',
                          style: const H5TextStyle().merge(const TextStyle(
                            decoration: TextDecoration.underline,
                          )),
                        ),
                      ),
                    )
                  : const SizedBox()
            ],
          ),
          hashtagAsync.when(
            data: (data) {
              return Wrap(
                spacing: 5,
                children: selectedTagList.value.map((tag) {
                  return HashtagBox(
                    isEditIcon: !isDeleteMode.value,
                    selected: tag.isSelected,
                    hashtag: tag.name,
                    onSelected: (value) =>
                        selectHashButton(tag: tag, value: value),
                  );
                }).toList(),
              );
            },
            error: (error, stackTrace) => const SizedBox(),
            loading: () => const LoadingIndicator(),
          ),
          const SizedBox(height: 35),
          isDeleteMode.value
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    CircleIconButton(
                      splashColor: AppColors.subTitle,
                      width: 45,
                      height: 45,
                      onPressed: pressDeleteHash,
                      backgroundColor: AppColors.blackColor,
                      icon: Image(
                        color: AppColors.whiteColor,
                        width: 27,
                        height: 27,
                        image: Assets.trash,
                      ),
                    ),
                  ],
                )
              : const SizedBox()
        ],
      ),
    );
  }
}
