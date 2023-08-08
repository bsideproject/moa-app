import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:moa_app/constants/color_constants.dart';
import 'package:moa_app/constants/file_constants.dart';
import 'package:moa_app/constants/font_constants.dart';
import 'package:moa_app/models/content_model.dart';
import 'package:moa_app/providers/content_detail_provider.dart';
import 'package:moa_app/providers/hashtag_view_provider.dart';
import 'package:moa_app/repositories/content_repository.dart';
import 'package:moa_app/screens/home/edit_content_view.dart';
import 'package:moa_app/screens/home/home.dart';
import 'package:moa_app/utils/general.dart';
import 'package:moa_app/widgets/app_bar.dart';
import 'package:moa_app/widgets/button.dart';
import 'package:moa_app/widgets/image.dart';
import 'package:moa_app/widgets/loading_indicator.dart';
import 'package:moa_app/widgets/moa_widgets/bottom_modal_item.dart';
import 'package:url_launcher/url_launcher.dart';

class ContentView extends HookConsumerWidget {
  const ContentView({
    super.key,
    required this.id,
    required this.folderName,
    required this.contentType,
    this.source,
  });
  final String id;
  final String folderName;
  final AddContentType contentType;
  final HashtagSource? source;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var contentNotifier = ref.watch(contentDetailProvider.notifier);
    var hashtagAsync = ref.watch(hashtagViewProvider.notifier);
    var isEditMode = useState(false);

    void pressGoToLink(String contentUrl) async {
      var url = Uri.parse(contentUrl);
      if (!await launchUrl(url)) {
        throw Exception('Could not launch $url');
      }
    }

    void pressConfirm() {}

    void editContent() {
      isEditMode.value = true;
    }

    void deleteContent() async {
      await hashtagAsync.deleteContent(contentId: id);
      await source?.refresh(true);
      if (context.mounted) {
        context.pop();
        context.pop();
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

    void showContentModal() {
      General.instance.showBottomSheet(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
        context: context,
        height: 150 + kBottomNavigationBarHeight,
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
          ],
        ),
      );
    }

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBarBack(
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
        child: FutureBuilder<ContentModel>(
          future: contentNotifier.fetchItem(contentId: id),
          builder: (context, snapshot) {
            var content = snapshot.data;
            return AnimatedSwitcher(
              transitionBuilder: (child, animation) {
                return FadeTransition(opacity: animation, child: child);
              },
              duration: const Duration(milliseconds: 300),
              child: () {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 100),
                    child: const LoadingIndicator(),
                  );
                }
                if (snapshot.hasError) {
                  return const Center(
                    child: Text(
                      '취향을 불러오는데 실패했습니다.',
                      style: TextStyle(
                        color: AppColors.blackColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        fontFamily: FontConstants.pretendard,
                      ),
                    ),
                  );
                }
                if (snapshot.hasData && content != null) {
                  return isEditMode.value
                      ? SingleChildScrollView(
                          padding: const EdgeInsets.only(
                            left: 15,
                            right: 15,
                            bottom: 30,
                          ),
                          physics: const ClampingScrollPhysics(),
                          child: EditContentView(
                            content: content,
                            isEditMode: isEditMode,
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
                                  ? const Text('이미지 없을 경우 모아 이미지로 대체')
                                  : AspectRatio(
                                      aspectRatio: 1,
                                      child: Container(
                                        margin: const EdgeInsets.only(top: 20),
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
        ),
      ),
    );
  }
}
