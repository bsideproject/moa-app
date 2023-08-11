import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:moa_app/constants/color_constants.dart';
import 'package:moa_app/constants/file_constants.dart';
import 'package:moa_app/constants/font_constants.dart';
import 'package:moa_app/providers/hashtag_provider.dart';
import 'package:moa_app/screens/add_content/add_image_content.dart';
import 'package:moa_app/screens/home/widgets/hashtag_button.dart';
import 'package:moa_app/utils/general.dart';
import 'package:moa_app/widgets/button.dart';
import 'package:moa_app/widgets/edit_text.dart';
import 'package:moa_app/widgets/loading_indicator.dart';
import 'package:moa_app/widgets/moa_widgets/hashtag_box.dart';

class EditHashtag extends HookConsumerWidget {
  const EditHashtag({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var hashtagAsync = ref.watch(hashtagProvider);
    var textController = useTextEditingController();
    var selectedTagList = useState<List<SelectedTagModel>>([]);
    var isDeleteMode = useState(false);

    void addHashtag() {
      if (textController.text.isEmpty) {
        return;
      }

      if (selectedTagList.value
          .map((e) => e.name)
          .contains(textController.text)) {
        return;
      }

      selectedTagList.value = [
        ...selectedTagList.value,
        SelectedTagModel(
          isSelected: false,
          name: textController.text,
        ),
      ];

      textController.text = '';
    }

    void onCancelDeleteMode() {
      selectedTagList.value = selectedTagList.value
          .map((e) => SelectedTagModel(isSelected: false, name: e.name))
          .toList();
      isDeleteMode.value = false;
    }

    void showHashEditModal() {
      General.instance.showBottomSheet(
        context: context,
        //todo 해시태그 수정 모달
        child: const SizedBox(),
      );
    }

    void selectHashButton(
        {required bool value, required SelectedTagModel tag}) {
      if (!isDeleteMode.value) {
        showHashEditModal();
        return;
      }

      selectedTagList.value = selectedTagList.value.map((e) {
        if (e.name == tag.name) {
          return SelectedTagModel(
            name: e.name,
            isSelected: value,
          );
        }
        return e;
      }).toList();
    }

    useEffect(() {
      if (hashtagAsync.hasValue) {
        selectedTagList.value = hashtagAsync.value!
            .map((e) => SelectedTagModel(name: e.hashTag, isSelected: false))
            .toList();
      }
      return null;
    }, [hashtagAsync.isLoading]);

    return Padding(
      padding: const EdgeInsets.only(left: 15, right: 15, top: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '기본 해시태그',
            style: H4TextStyle(),
          ),
          const SizedBox(height: 10),
          hashtagAsync.when(
            data: (data) {
              return Wrap(
                spacing: 10,
                runSpacing: 10,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  ...data.map((tag) {
                    return HashtagButton(
                      text: '#${tag.hashTag}',
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 8,
                      ),
                      style: const H4TextStyle().merge(
                        const TextStyle(color: AppColors.subTitle),
                      ),
                    );
                  }).toList()
                ],
              );
            },
            error: (error, stackTrace) {
              return const SizedBox();
            },
            loading: () => const LoadingIndicator(),
          ),
          const SizedBox(height: 30),
          const Text(
            '내가 생성한 해시태그',
            style: H4TextStyle(),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: EditText(
                  controller: textController,
                  hintText: '새로운 해시태그를 입력해주세요.',
                  onChanged: (value) {},
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
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              isDeleteMode.value
                  ? const SizedBox()
                  : GestureDetector(
                      onTap: () => isDeleteMode.value = true,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Wrap(
                          direction: Axis.horizontal,
                          children: [
                            Image(width: 16, height: 16, image: Assets.trash),
                            const SizedBox(width: 2),
                            const Text(
                              '선택하여 삭제하기',
                              style: Hash1TextStyle(),
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
          )
        ],
      ),
    );
  }
}
