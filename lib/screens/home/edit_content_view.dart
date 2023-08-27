import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:moa_app/constants/color_constants.dart';
import 'package:moa_app/constants/file_constants.dart';
import 'package:moa_app/constants/font_constants.dart';
import 'package:moa_app/models/content_model.dart';
import 'package:moa_app/providers/content_detail_provider.dart';
import 'package:moa_app/providers/folder_view_provider.dart';
import 'package:moa_app/providers/hashtag_provider.dart';
import 'package:moa_app/providers/hashtag_view_provider.dart';
import 'package:moa_app/repositories/content_repository.dart';
import 'package:moa_app/screens/add_content/add_image_content.dart';
import 'package:moa_app/utils/general.dart';
import 'package:moa_app/widgets/button.dart';
import 'package:moa_app/widgets/edit_text.dart';
import 'package:moa_app/widgets/image.dart';
import 'package:moa_app/widgets/loading_indicator.dart';
import 'package:moa_app/widgets/moa_widgets/empty_image.dart';
import 'package:moa_app/widgets/moa_widgets/hashtag_box.dart';
import 'package:moa_app/widgets/snackbar.dart';

class EditContentView extends HookConsumerWidget {
  const EditContentView({
    super.key,
    required this.content,
    required this.isEditMode,
    required this.contentType,
  });
  final ContentModel content;
  final ValueNotifier<bool> isEditMode;
  final AddContentType contentType;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var titleController = useTextEditingController(text: content.contentName);
    var memoController = useTextEditingController(text: content.contentMemo);
    var hashtagList = useState<List<String>>(
        content.contentHashTags.map((e) => e.hashTag).toList());

    var title = useState(content.contentName);
    var memo = useState(content.contentMemo);

    var loading = useState(false);

    Future<void> saveEditContent() async {
      try {
        loading.value = true;
        await ContentRepository.instance.editContent(
          contentId: content.contentId,
          contentMemo: titleController.text,
          contentName: memoController.text,
          hashTagStringList: hashtagList.value.join(','),
        );
        await ref.read(contentDetailProvider.notifier).editContent(
              contentId: content.contentId,
              contentMemo: titleController.text,
              contentName: memoController.text,
              hashTagStringList: hashtagList.value.join(','),
            );

        await ref.read(hashtagViewProvider.notifier).refresh();
        await ref.read(folderViewProvider.notifier).refresh();
        isEditMode.value = false;
      } catch (e) {
        if (context.mounted) {
          snackbar.alert(
              context, kDebugMode ? e.toString() : '오류가 발생했습니다. 다시 시도해주세요.');
        }
      } finally {
        loading.value = false;
      }
    }

    void showEditHashtagModal() {
      General.instance.showBottomSheet(
        context: context,
        child: ChangeHashtagList(
          hashtagList: hashtagList,
        ),
      );
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        content.thumbnailImageUrl == ''
            ? const EmptyImage(
                aspectRatio: 1.8,
              )
            : contentType == AddContentType.url
                ? Container(
                    width: 85,
                    height: 85,
                    margin: const EdgeInsets.only(top: 20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: AppColors.grayBackground,
                        width: 0.5,
                      ),
                    ),
                    child: ImageOnNetwork(
                      imageURL: content.thumbnailImageUrl,
                      fit: BoxFit.cover,
                    ),
                  )
                : AspectRatio(
                    aspectRatio: 1,
                    child: Container(
                      margin: const EdgeInsets.only(top: 20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: AppColors.grayBackground,
                          width: 0.5,
                        ),
                      ),
                      child: ImageOnNetwork(
                        fit: BoxFit.contain,
                        imageURL: content.thumbnailImageUrl,
                      ),
                    ),
                  ),
        const SizedBox(height: 20),
        const Text(
          '제목',
          style: H4TextStyle(),
        ),
        const SizedBox(height: 10),
        EditText(
          borderRadius: const BorderRadius.all(Radius.circular(15)),
          controller: titleController,
          maxLength: 30,
          onChanged: (value) {
            title.value = value;
          },
          hintText: '1~30자로 입력할 수 있어요.',
        ),
        const SizedBox(height: 5),
        Row(
          children: [
            const Spacer(),
            Text(
              '${titleController.text.characters.length}/30',
              style: TextStyle(
                color: titleController.text.characters.length >= 30
                    ? AppColors.danger
                    : AppColors.blackColor.withOpacity(0.3),
                fontSize: 12,
                fontFamily: FontConstants.pretendard,
              ),
            ),
          ],
        ),
        const SizedBox(height: 30),
        const Text(
          '메모',
          style: H4TextStyle(),
        ),
        const SizedBox(height: 10),
        EditText(
          borderRadius: const BorderRadius.all(Radius.circular(15)),
          controller: memoController,
          maxLength: 100,
          maxLines: 4,
          onChanged: (value) {
            memo.value = value;
          },
          hintText: '메모를 입력하세요.',
        ),
        const SizedBox(height: 5),
        Row(
          children: [
            const Spacer(),
            Text(
              '${memoController.text.characters.length}/100',
              style: TextStyle(
                color: memoController.text.characters.length >= 100
                    ? AppColors.danger
                    : AppColors.blackColor.withOpacity(0.3),
                fontSize: 12,
                fontFamily: FontConstants.pretendard,
              ),
            ),
          ],
        ),
        Wrap(
          spacing: 10,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            ...hashtagList.value.map(
              (hash) => Container(
                margin: const EdgeInsets.only(top: 20),
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: AppColors.contentHashtagBackground,
                ),
                child: Text(
                  '#$hash',
                  style: const TextStyle(
                    color: AppColors.subTitle,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    fontFamily: FontConstants.pretendard,
                  ),
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 20),
              child: CircleIconButton(
                width: 35,
                height: 35,
                backgroundColor: AppColors.primaryColor,
                onPressed: showEditHashtagModal,
                icon: Image(
                  width: 16,
                  height: 16,
                  color: AppColors.whiteColor,
                  image: Assets.pencil,
                ),
              ),
            )
          ],
        ),
        const SizedBox(height: 30),
        Button(
          loading: loading.value,
          backgroundColor: AppColors.primaryColor,
          text: '변경 내용 저장',
          onPressed: saveEditContent,
        )
      ],
    );
  }
}

class ChangeHashtagList extends HookConsumerWidget {
  const ChangeHashtagList({super.key, required this.hashtagList});
  final ValueNotifier<List<String>> hashtagList;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var hashtagAsync = ref.watch(hashtagProvider);
    var selectedTagList = useState<List<SelectedTagModel>>([]);

    void onSelectedTag({required bool value, required SelectedTagModel tag}) {
      selectedTagList.value = selectedTagList.value
          .map(
            (e) => e.name == tag.name
                ? SelectedTagModel(name: e.name, isSelected: value)
                : e,
          )
          .toList();
    }

    void changeHashtag() {
      hashtagList.value = selectedTagList.value
          .where((element) => element.isSelected)
          .map((element) => element.name)
          .toList();
      context.pop();
    }

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 30),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            hashtagAsync.when(
              data: (data) {
                if (selectedTagList.value.isEmpty) {
                  selectedTagList.value = data.$1.map((e) {
                    if (hashtagList.value.contains(e.hashTag)) {
                      return SelectedTagModel(
                          name: e.hashTag, isSelected: true);
                    }
                    return SelectedTagModel(name: e.hashTag, isSelected: false);
                  }).toList();
                }

                return SizedBox(
                  height: 300,
                  child: SingleChildScrollView(
                    physics: const ClampingScrollPhysics(),
                    padding: const EdgeInsets.only(bottom: 50),
                    child: Wrap(
                        spacing: 5,
                        crossAxisAlignment: WrapCrossAlignment.start,
                        children: [
                          ...selectedTagList.value
                              .map(
                                (tag) => HashtagBox(
                                  hashtag: tag.name,
                                  selected: tag.isSelected,
                                  onSelected: (value) =>
                                      onSelectedTag(value: value, tag: tag),
                                ),
                              )
                              .toList(),
                        ]),
                  ),
                );
              },
              loading: () => const LoadingIndicator(),
              error: (error, stackTrace) => const Text('에러'),
            ),
            const SizedBox(height: 10),
            Button(
              text: '해시태그 변경',
              onPressed: changeHashtag,
            )
          ],
        ),
      ),
    );
  }
}
