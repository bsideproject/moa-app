import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:moa_app/constants/color_constants.dart';
import 'package:moa_app/constants/file_constants.dart';
import 'package:moa_app/constants/font_constants.dart';
import 'package:moa_app/providers/content_detail_provider.dart';
import 'package:moa_app/providers/folder_detail_provider.dart';
import 'package:moa_app/providers/folder_view_provider.dart';
import 'package:moa_app/providers/hashtag_view_provider.dart';
import 'package:moa_app/repositories/content_repository.dart';
import 'package:moa_app/screens/home/edit_content_view.dart';
import 'package:moa_app/utils/general.dart';
import 'package:moa_app/utils/router_provider.dart';
import 'package:moa_app/widgets/app_bar.dart';
import 'package:moa_app/widgets/button.dart';
import 'package:moa_app/widgets/image.dart';
import 'package:moa_app/widgets/loading_indicator.dart';
import 'package:moa_app/widgets/moa_widgets/bottom_modal_item.dart';
import 'package:moa_app/widgets/moa_widgets/empty_image.dart';
import 'package:moa_app/widgets/snackbar.dart';
import 'package:url_launcher/url_launcher.dart';

class ContentView extends HookConsumerWidget {
  const ContentView({
    super.key,
    required this.id,
    required this.folderName,
    required this.contentType,
  });
  final String id;
  final String folderName;
  final AddContentType contentType;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var contentAsync = ref.watch(contentDetailProvider(id: id));
    var hashtagAsync = ref.watch(hashtagViewProvider.notifier);
    var isEditMode = useState(false);

    void pressGoToLink(String contentUrl) async {
      var url = Uri.parse(contentUrl);
      if (!await launchUrl(url)) {
        if (context.mounted) {
          snackbar.alert(context, '잘못된 링크입니다.\n$url');
        }
      }
    }

    void refreshCache() {
      ref.refresh(folderDetailProvider(folderName: folderName)).value;
    }

    void pressConfirm() {
      refreshCache();
      context.pop();
    }

    void editContent() {
      isEditMode.value = true;
    }

    void deleteContent() async {
      await hashtagAsync.deleteContent(contentId: id);
      await ref.read(folderViewProvider.notifier).refresh();
      ref.refresh(folderDetailProvider(folderName: folderName)).value;

      if (context.mounted) {
        context.pop();
        context.pop(true);
      }
    }

    void showDeleteContentModal() {
      General.instance.showBottomSheet(
        height: 250,
        context: context,
        isCloseButton: true,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '취향 컨텐츠 삭제 시\n복구가 불가능해요.\n정말로 삭제하시겠어요?',
                  style:
                      const H2TextStyle().merge(const TextStyle(height: 1.5)),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 25),
                Button(
                  text: '삭제하기',
                  onPressed: deleteContent,
                )
              ],
            ),
          ),
        ),
      );
    }

    void showFolderListModal() {
      General.instance.showBottomSheet(
        padding: const EdgeInsets.only(
          left: 15,
          right: 15,
          top: 0,
        ),
        isScrollControlled: true,
        height: MediaQuery.of(context).size.height * 0.7,
        context: context,
        child: FolderListModalView(
          contentId: id,
          contentType: contentType,
        ),
      );
    }

    void showContentModal() {
      General.instance.showBottomSheet(
        context: context,
        height: 200 + kBottomNavigationBarHeight,
        child: Column(
          children: [
            BottomModalItem(
              icon: Assets.pencil,
              title: '콘텐츠 수정',
              onPressed: () {
                context.pop();
                editContent();
              },
            ),
            BottomModalItem(
              icon: Assets.trash,
              title: '콘텐츠 삭제',
              onPressed: () {
                context.pop();
                showDeleteContentModal();
              },
            ),
            BottomModalItem(
              icon: Assets.folderIcon,
              title: '폴더 변경',
              onPressed: () {
                context.pop();
                showFolderListModal();
              },
            ),
          ],
        ),
      );
    }

    return Scaffold(
      appBar: AppBarBack(
        onPressedBack: () => {
          refreshCache(),
          context.pop(),
        },
        title: folderName,
        isBottomBorderDisplayed: false,
        actions: [
          CircleIconButton(
            backgroundColor: AppColors.whiteColor,
            icon: Image(
              width: 36,
              height: 36,
              image: Assets.menu,
            ),
            onPressed: showContentModal,
          ),
        ],
      ),
      body: SafeArea(
        child: contentAsync.when(
          data: (content) {
            return AnimatedSwitcher(
              transitionBuilder: (child, animation) {
                return FadeTransition(opacity: animation, child: child);
              },
              duration: const Duration(milliseconds: 300),
              child: () {
                if (content != null) {
                  return isEditMode.value
                      ? SingleChildScrollView(
                          padding: const EdgeInsets.only(
                            left: 15,
                            right: 15,
                            bottom: 30,
                          ),
                          physics: const ClampingScrollPhysics(),
                          child: ConstrainedBox(
                            constraints: BoxConstraints(
                              minHeight: MediaQuery.of(context).size.height -
                                  kToolbarHeight -
                                  kBottomNavigationBarHeight -
                                  55,
                            ),
                            child: EditContentView(
                              contentType: contentType,
                              content: content,
                              isEditMode: isEditMode,
                            ),
                          ),
                        )
                      : Padding(
                          padding: const EdgeInsets.only(
                            left: 15,
                            right: 15,
                            bottom: 30,
                          ),
                          child: Column(
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
                                          margin:
                                              const EdgeInsets.only(top: 20),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
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
                                            margin:
                                                const EdgeInsets.only(top: 20),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              border: Border.all(
                                                color: AppColors.grayBackground,
                                                width: 0.5,
                                              ),
                                            ),
                                            child: ImageOnNetwork(
                                              imageURL:
                                                  content.thumbnailImageUrl,
                                              fit: BoxFit.contain,
                                            ),
                                          ),
                                        ),
                              const SizedBox(height: 10),
                              Text(
                                content.contentName,
                                style: const H2TextStyle(),
                              ),
                              const SizedBox(height: 30),
                              Text(
                                content.contentMemo ?? '',
                                style: const Hash1TextStyle().merge(
                                  const TextStyle(height: 1.4),
                                ),
                              ),
                              Wrap(
                                spacing: 10,
                                runSpacing: 10,
                                children: [
                                  ...content.contentHashTags.map(
                                    (e) => Container(
                                      margin: const EdgeInsets.only(top: 30),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20, vertical: 8),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(50),
                                        color:
                                            AppColors.contentHashtagBackground,
                                      ),
                                      child: Text(
                                        '#${e.hashTag}',
                                        style: const TextStyle(
                                          color: AppColors.subTitle,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          fontFamily: FontConstants.pretendard,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const Spacer(),
                              contentType == AddContentType.url
                                  ? Row(
                                      children: [
                                        Expanded(
                                          child: Button(
                                            backgroundColor:
                                                AppColors.linkButton,
                                            text: '링크 바로가기',
                                            onPressed: () => pressGoToLink(
                                                content.contentUrl!),
                                          ),
                                        ),
                                        const SizedBox(width: 15),
                                        Expanded(
                                          child: Button(
                                            text: '확인',
                                            onPressed: pressConfirm,
                                          ),
                                        ),
                                      ],
                                    )
                                  : Button(
                                      text: '확인',
                                      onPressed: pressConfirm,
                                    ),
                            ],
                          ),
                        );
                }
                return const SizedBox();
              }(),
            );
          },
          error: (error, stackTrace) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  kDebugMode ? error.toString() : '취향을 불러오는데 실패했습니다.',
                  style: const TextStyle(
                    color: AppColors.blackColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    fontFamily: FontConstants.pretendard,
                  ),
                ),
                Button(
                  onPressed: () {
                    ref.refresh(contentDetailProvider(id: id)).value;
                  },
                  margin: const EdgeInsets.only(left: 100, right: 100, top: 20),
                  text: '다시 시도',
                ),
              ],
            );
          },
          loading: () => const LoadingIndicator(),
        ),
      ),
    );
  }
}

class FolderListModalView extends HookConsumerWidget {
  const FolderListModalView({
    super.key,
    required this.contentId,
    required this.contentType,
  });
  final String contentId;
  final AddContentType contentType;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var selectedIndex = useState(-1);
    var folderAsync = ref.watch(folderViewProvider);
    void selectFolder({required int index}) {
      selectedIndex.value = index;
    }

    void changeFolder({
      required String changeFolderId,
      required String folderName,
    }) async {
      await ContentRepository.instance.changeContentFolder(
        contentId: contentId,
        changeFolderId: changeFolderId,
      );
      await ref.read(folderViewProvider.notifier).refresh();
      if (context.mounted) {
        context.pop();
        context.replace(
          '${GoRoutes.content.fullPath}/$contentId',
          extra: ContentView(
            id: contentId,
            folderName: folderName,
            contentType: contentType,
          ),
        );
      }
    }

    return folderAsync.when(
      data: (folderList) {
        return Column(
          children: [
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.only(top: 30),
                itemCount: folderList.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: 1.3,
                  mainAxisExtent: 117,
                ),
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      Stack(
                        children: [
                          SizedBox(
                            height: 77,
                            child: Material(
                              color: AppColors.whiteColor,
                              child: Ink(
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    fit: BoxFit.contain,
                                    image: Assets.folder,
                                    colorFilter: ColorFilter.mode(
                                      folderList[index].folderColor.withOpacity(
                                            (selectedIndex.value == -1 ||
                                                    selectedIndex.value ==
                                                        index)
                                                ? 1
                                                : 0.5,
                                          ),
                                      BlendMode.srcIn,
                                    ),
                                  ),
                                ),
                                child: InkWell(
                                  splashColor: Colors.transparent,
                                  borderRadius: BorderRadius.circular(8),
                                  onTap: () => selectFolder(index: index),
                                ),
                              ),
                            ),
                          ),
                          selectedIndex.value == index
                              ? Positioned.fill(
                                  child: Center(
                                    child: Image(
                                      image: Assets.check,
                                      width: 20,
                                      height: 20,
                                    ),
                                  ),
                                )
                              : const SizedBox()
                        ],
                      ),
                      const SizedBox(height: 5),
                      Text(
                        folderList[index].folderName,
                        style: const H4TextStyle().merge(
                          TextStyle(
                            color: AppColors.blackColor.withOpacity(
                              (selectedIndex.value == -1 ||
                                      selectedIndex.value == index)
                                  ? 1
                                  : 0.5,
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
            Button(
              disabled: selectedIndex.value == -1,
              text: '폴더 변경',
              onPressed: () => changeFolder(
                changeFolderId: folderList[selectedIndex.value].folderId,
                folderName: folderList[selectedIndex.value].folderName,
              ),
            ),
            const SizedBox(height: 30)
          ],
        );
      },
      error: (error, stackTrace) => const SizedBox(),
      loading: () => const LoadingIndicator(),
    );
  }
}
