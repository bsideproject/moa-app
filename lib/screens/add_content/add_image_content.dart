import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:moa_app/constants/color_constants.dart';
import 'package:moa_app/constants/file_constants.dart';
import 'package:moa_app/constants/font_constants.dart';
import 'package:moa_app/models/content_model.dart';
import 'package:moa_app/providers/hashtag_provider.dart';
import 'package:moa_app/repositories/content_repository.dart';
import 'package:moa_app/screens/add_content/widgets/add_content_bottom.dart';
import 'package:moa_app/utils/utils.dart';
import 'package:moa_app/widgets/app_bar.dart';
import 'package:moa_app/widgets/button.dart';
import 'package:moa_app/widgets/moa_widgets/error_text.dart';
import 'package:moa_app/widgets/snackbar.dart';

class SelectedTagModel {
  SelectedTagModel({
    required this.isSelected,
    required this.name,
  });

  final bool isSelected;
  final String name;
}

class AddImageContent extends HookConsumerWidget {
  const AddImageContent({super.key, required this.folderId});
  final String folderId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var hashtagAsync = ref.watch(hashtagProvider);
    var loading = useState(false);
    var picker = ImagePicker();
    var imageFile = useState<XFile?>(null);

    var title = useState('');
    var memo = useState('');
    var hashtag = useState('');
    var hashtagController = useTextEditingController();
    var selectedTagList = useState<List<SelectedTagModel>>([]);

    var imageError = useState('');
    var titleError = useState('');
    var tagError = useState('');

    void pickImage(ImageSource source) async {
      var pickedFile = await picker.pickImage(source: source);
      imageFile.value = pickedFile;
      if (imageFile.value != null) {
        imageError.value = '';
      }
    }

    void completeAddContent() async {
      if (imageFile.value == null ||
          title.value.isEmpty ||
          selectedTagList.value.where((e) => e.isSelected).isEmpty) {
        if (imageFile.value == null) {
          imageError.value = '이미지를 선택해주세요.';
        }

        if (title.value.isEmpty) {
          titleError.value = '제목을 입력해주세요.';
        }

        if (selectedTagList.value.where((e) => e.isSelected).isEmpty) {
          tagError.value = '태그를 선택해주세요.';
        }

        return;
      }

      loading.value = true;
      String base64Image = await xFileToBase64(imageFile.value!);

      var selectTag = [];
      selectedTagList.value.map((element) {
        if (element.isSelected) {
          selectTag.add(element.name);
        }
      }).toList();

      var hashTagStringList = selectTag.join(',');

      try {
        await ContentRepository.instance.addContent(
          contentType: AddContentType.image,
          content: ContentModel(
            contentId: folderId,
            contentName: title.value,
            contentHashTag: [],
            contentImageUrl: base64Image,
            contentMemo: memo.value,
          ),
          hashTagStringList: hashTagStringList,
        );

        if (context.mounted) {
          context.go('/');
        }
      } catch (error) {
        if (context.mounted) {
          snackbar.alert(
              context, kDebugMode ? error.toString() : '오류가 발생했어요 다시 시도해주세요.');
        }
      } finally {
        loading.value = false;
      }
    }

    void onChangedTitle(String value) {
      title.value = value;
      titleError.value = '';
    }

    void onChangedHashtag(String value) {
      hashtag.value = value;
    }

    void onChangedMemo(String value) {
      memo.value = value;
    }

    void addHashtag() {
      if (selectedTagList.value.map((e) => e.name).contains(hashtag.value)) {
        tagError.value = '중복 태그가 존재해요.';
        return;
      }

      if (hashtagController.text.isEmpty) {
        return;
      }

      selectedTagList.value = [
        SelectedTagModel(name: hashtag.value, isSelected: true),
        ...selectedTagList.value
      ];
      tagError.value = '';
      hashtagController.clear();
    }

    useEffect(() {
      if (hashtagAsync.hasValue) {
        selectedTagList.value = hashtagAsync.value!
            .map((e) => SelectedTagModel(name: e.hashTag, isSelected: false))
            .toList();
      }
      return null;
    }, [hashtagAsync.isLoading]);

    return Scaffold(
      appBar: const AppBarBack(
        isBottomBorderDisplayed: false,
        title: '취향 모으기',
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              padding: const EdgeInsets.only(bottom: 100),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: 135,
                    child: Material(
                      color: AppColors.textInputBackground,
                      borderRadius: BorderRadius.circular(15),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(15),
                        onTap: () => pickImage(ImageSource.gallery),
                        child: imageFile.value != null
                            ? Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image:
                                        FileImage(File(imageFile.value!.path)),
                                  ),
                                ),
                              )
                            : Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image(
                                    width: 16,
                                    height: 16,
                                    image: Assets.circlePlus,
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    '대표 이미지 추가하기',
                                    style: const InputLabelTextStyle().merge(
                                      TextStyle(
                                        color: AppColors.blackColor
                                            .withOpacity(0.3),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                      ),
                    ),
                  ),
                  ErrorText(
                      errorText: imageError.value,
                      errorValidate: imageError.value.isNotEmpty),
                  AddContentBottom(
                    onChangedTitle: onChangedTitle,
                    addHashtag: addHashtag,
                    hashtagController: hashtagController,
                    onChangedHashtag: onChangedHashtag,
                    onChangedMemo: onChangedMemo,
                    memo: memo,
                    tagError: tagError,
                    title: title,
                    titleError: titleError,
                    selectedTagList: selectedTagList,
                  )
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            width: MediaQuery.of(context).size.width,
            child: Button(
              loading: loading.value,
              onPress: completeAddContent,
              backgroundColor: AppColors.primaryColor,
              text: '완료',
              height: 52 + MediaQuery.of(context).padding.bottom,
              borderRadius: 0,
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).padding.bottom),
            ),
          )
        ],
      ),
    );
  }
}
