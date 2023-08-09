import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:html/parser.dart' as html_parser;
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:moa_app/constants/color_constants.dart';
import 'package:moa_app/constants/file_constants.dart';
import 'package:moa_app/constants/font_constants.dart';
import 'package:moa_app/models/content_model.dart';
import 'package:moa_app/providers/folder_view_provider.dart';
import 'package:moa_app/providers/hashtag_provider.dart';
import 'package:moa_app/providers/hashtag_view_provider.dart';
import 'package:moa_app/repositories/content_repository.dart';
import 'package:moa_app/screens/add_content/add_image_content.dart';
import 'package:moa_app/screens/add_content/widgets/add_content_bottom.dart';
import 'package:moa_app/screens/home/home.dart';
import 'package:moa_app/utils/utils.dart';
import 'package:moa_app/widgets/app_bar.dart';
import 'package:moa_app/widgets/button.dart';
import 'package:moa_app/widgets/edit_text.dart';
import 'package:moa_app/widgets/moa_widgets/error_text.dart';
import 'package:moa_app/widgets/snackbar.dart';

class AddLinkContent extends HookConsumerWidget {
  const AddLinkContent({super.key, required this.folderId, this.receiveUrl});
  final String folderId;
  final String? receiveUrl;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var hashtagAsync = ref.watch(hashtagProvider);
    var loading = useState(false);
    var picker = ImagePicker();
    var imageFile = useState<XFile?>(null);
    var defaultImage = useState<String?>(null);
    var defaultImageList = useState<List<AssetImage?>>([
      null,
      Assets.bagMoa,
      Assets.book,
      Assets.brush,
      Assets.heartMoa,
      Assets.hearts,
      Assets.location,
      Assets.movie,
      Assets.movie2,
      Assets.newsMoa,
      Assets.recipe,
      Assets.style
    ]);

    var selectedIndex = useState(-1);
    var title = useState('');
    var link = useState('');
    var memo = useState('');
    var hashtag = useState('');
    var hashtagController = useTextEditingController();
    var selectedTagList = useState<List<SelectedTagModel>>([]);
    var lifeCycle = useAppLifecycleState();

    var imageError = useState('');
    var titleError = useState('');
    var tagError = useState('');
    var linkError = useState('');

    var linkController = useTextEditingController();
    var titleController = useTextEditingController();
    var memoController = useTextEditingController();

    void pickImage({required ImageSource source, required int index}) async {
      if (index == 0) {
        var pickedFile = await picker.pickImage(source: source);
        imageFile.value = pickedFile;
        return;
      }

      // todo 대표 이미지 미지정시 하트들고있는 모아 이미지로 대체
      if (imageFile.value != null) {
        imageError.value = '';
      }
    }

    void completeAddContent() async {
      if (link.value.isEmpty ||
          title.value.isEmpty ||
          selectedTagList.value.where((e) => e.isSelected).isEmpty) {
        if (link.value.isEmpty) {
          linkError.value = '링크를 입력해주세요.';
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
      late String base64Image = '';
      if (imageFile.value != null) {
        base64Image = await xFileToBase64(imageFile.value!);
      }

      if (defaultImage.value != null) {
        base64Image = defaultImage.value!;
      }

      var selectTag = [];
      selectedTagList.value.map((element) {
        if (element.isSelected) {
          selectTag.add(element.name);
        }
      }).toList();

      var hashTagStringList = selectTag.join(',');

      try {
        await ContentRepository.instance.addContent(
          contentType: AddContentType.url,
          content: ContentModel(
            folderName: 'folderName',
            contentId: folderId,
            contentUrl: link.value,
            contentName: title.value,
            contentHashTags: [],
            thumbnailImageUrl: base64Image,
            contentMemo: memo.value,
          ),
          hashTagStringList: hashTagStringList,
        );

        await ref.read(hashtagViewProvider.notifier).addContent();
        await ref
            .refresh(folderViewProvider.notifier)
            .addFolder(folderName: 'folderName');

        if (context.mounted) {
          context.go(
            '/',
            extra: const Home(isRefresh: true),
          );
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

    void onChangedLink(String value) {
      link.value = value;
      linkError.value = '';
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

    /// 공유로 받아온 url 크롤링
    void getCrawlUrl(String url) async {
      await http.get(Uri.parse(url)).then((response) {
        var document = html_parser.parse(response.body);

        var crawledTitle = document.head
            ?.querySelector("meta[property='og:title']")
            ?.attributes['content'];

        if (crawledTitle != null && crawledTitle.length > 30) {
          crawledTitle = '${crawledTitle.substring(0, 30)}...';
        }
        var crawledDescription = document.head
            ?.querySelector("meta[property='og:description']")
            ?.attributes['content'];
        // var crawledImage = document.head
        //     ?.querySelector("meta[property='og:image']")
        //     ?.attributes['content'];

        link.value = url;
        linkController.text = url;
        title.value = crawledTitle ?? '';
        titleController.text = crawledTitle ?? '';
        memo.value = crawledDescription ?? '';
        memoController.text = crawledDescription ?? '';
      });
    }

    useEffect(() {
      if (receiveUrl != null && lifeCycle == AppLifecycleState.resumed) {
        // todo 유효한 url인지 체크필요
        getCrawlUrl(receiveUrl!);
      }
      return null;
    }, [lifeCycle]);

    return Scaffold(
      appBar: const AppBarBack(
        isBottomBorderDisplayed: false,
        title: '취향 모으기',
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            padding: const EdgeInsets.only(bottom: 100),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '링크',
                        style: H4TextStyle(),
                      ),
                      const SizedBox(height: 5),
                      EditText(
                        controller: linkController,
                        onChanged: onChangedLink,
                        hintText: '링크를 입력하세요.',
                      ),
                      ErrorText(
                        errorText: linkError.value,
                        errorValidate: linkError.value.isNotEmpty,
                      ),
                      const SizedBox(height: 25),
                      const Text(
                        '대표 이미지',
                        style: H4TextStyle(),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 5),
                SizedBox(
                  width: double.infinity,
                  height: 85,
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    itemCount: defaultImageList.value.length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      var image = defaultImageList.value[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 7),
                        child: Ink(
                          width: 85,
                          height: 85,
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.all(
                              Radius.circular(15),
                            ),
                            border: Border.all(
                              color: selectedIndex.value == index
                                  ? AppColors.primaryColor
                                  : AppColors.grayBackground,
                              width: 0.5,
                            ),
                            color: selectedIndex.value == index
                                ? AppColors.moaSecondary
                                : AppColors.textInputBackground,
                          ),
                          child: InkWell(
                            onTap: () async {
                              if (index == 0) {
                                pickImage(
                                    source: ImageSource.gallery, index: index);
                                selectedIndex.value = -1;
                                return;
                              }

                              ByteData bytes = await rootBundle
                                  .load(image!.assetName.toString());
                              var buffer = bytes.buffer;
                              var base64Images =
                                  base64.encode(Uint8List.view(buffer));
                              defaultImage.value = base64Images;
                              imageFile.value = null;
                              selectedIndex.value = index;
                            },
                            borderRadius: const BorderRadius.all(
                              Radius.circular(15),
                            ),
                            child: index == 0
                                ? imageFile.value != null
                                    ? Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          border: Border.all(
                                            color: AppColors.grayBackground,
                                            width: 0.5,
                                          ),
                                          image: DecorationImage(
                                            fit: BoxFit.cover,
                                            image: FileImage(
                                                File(imageFile.value!.path)),
                                          ),
                                        ),
                                      )
                                    : Center(
                                        child: Image(
                                          width: 15,
                                          height: 15,
                                          image: Assets.circlePlus,
                                        ),
                                      )
                                : Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 20,
                                    ),
                                    child: Center(
                                      child: Image(
                                        image: image!,
                                      ),
                                    ),
                                  ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                AddContentBottom(
                  onChangedTitle: onChangedTitle,
                  titleController: titleController,
                  memoController: memoController,
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
          Positioned(
            bottom: 0,
            width: MediaQuery.of(context).size.width,
            child: Button(
              loading: loading.value,
              onPressed: completeAddContent,
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
