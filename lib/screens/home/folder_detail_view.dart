import 'package:flutter/material.dart';
import 'package:flutter_branch_sdk/flutter_branch_sdk.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:moa_app/constants/color_constants.dart';
import 'package:moa_app/constants/file_constants.dart';
import 'package:moa_app/providers/folder_detail_provider.dart';
import 'package:moa_app/screens/home/widgets/type_header.dart';
import 'package:moa_app/utils/router_provider.dart';
import 'package:moa_app/widgets/app_bar.dart';
import 'package:moa_app/widgets/button.dart';
import 'package:moa_app/widgets/loading_indicator.dart';
import 'package:moa_app/widgets/moa_widgets/dynamic_grid_list.dart';
import 'package:moa_app/widgets/moa_widgets/empty_content.dart';
import 'package:moa_app/widgets/snackbar.dart';
import 'package:share_plus/share_plus.dart';

class FolderDetailView extends HookConsumerWidget {
  const FolderDetailView({
    super.key,
    required this.folderName,
    required this.id,
    required this.contentCount,
  });
  final String folderName;
  final String id;
  final int contentCount;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var controller = useScrollController();
    var pageNum = useState(0);
    var hasMore = useState(true);
    var loading = useState(false);
    var folderDetailAsync = ref.watch(folderDetailProvider(folderId: id));

    Future<void> pullToRefresh() async {
      ref.refresh(folderDetailProvider(folderId: id)).value;
    }

    void shareFolder() async {
      BranchUniversalObject buo = BranchUniversalObject(
        canonicalIdentifier: '${GoRoutes.folder.fullPath}/$id?c=$contentCount',
        title: '모아 폴더 공유',
        contentDescription: folderName,
        // imageUrl:
        //     'https://fastly.picsum.photos/id/237/200/300.jpg?hmac=TmmQSbShHz9CdQm0NkEjx1Dyh_Y984R9LpNrpvH2D_U',
      );

      BranchLinkProperties linkProperties = BranchLinkProperties(
        channel: 'custom',
        feature: 'share',
        campaign: 'example_campaign',
      );

      BranchResponse response = await FlutterBranchSdk.getShortUrl(
          buo: buo, linkProperties: linkProperties);
      if (response.success) {
        await Share.share(response.result);
      } else {
        if (context.mounted) {
          snackbar.alert(context, '공유하기에 실패했어요 다시 시도해주세요.');
        }
      }
    }

    void getContentList({required int page}) async {
      loading.value = true;
      var length = await ref
          .read(folderDetailProvider(folderId: id).notifier)
          .loadMore(folderId: id, page: page);

      loading.value = false;
      if (length < 10) {
        hasMore.value = false;
      }
    }

    useEffect(() {
      controller.addListener(() {
        /// load date at when scroll reached -100
        if (controller.position.pixels >
            controller.position.maxScrollExtent - 100) {
          if (hasMore.value) {
            pageNum.value = pageNum.value + 1;
            getContentList(page: pageNum.value);
          }
        }
      });
      return null;
    }, []);

    return Scaffold(
      appBar: AppBarBack(
        isBottomBorderDisplayed: false,
        title: folderName,
        actions: [
          CircleIconButton(
            backgroundColor: AppColors.whiteColor,
            icon: Image(
              width: 20,
              height: 20,
              image: Assets.share,
            ),
            onPressed: shareFolder,
          ),
        ],
      ),
      body: SafeArea(
          child: AnimatedSwitcher(
        transitionBuilder: (child, animation) {
          return FadeTransition(opacity: animation, child: child);
        },
        duration: const Duration(milliseconds: 300),
        child: folderDetailAsync.when(
          loading: () => const LoadingIndicator(),
          error: (error, stackTrace) {
            return const Center(
              child: Text(
                '에러가 발생했어요.\n다시 시도해주세요.',
                textAlign: TextAlign.center,
              ),
            );
          },
          data: (contentList) {
            return () {
              if (contentList != null) {
                return contentList.isEmpty
                    ? const EmptyContent(text: '저장된 취향이 없어요!\n취향을 저장해 주세요.')
                    : Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Column(
                          children: [
                            const SizedBox(height: 30),
                            TypeHeader(
                                count: contentCount, onPressFilter: () {}),
                            Expanded(
                              child: DynamicGridList(
                                controller: controller,
                                contentList: contentList,
                                pullToRefresh: pullToRefresh,
                                folderNameProp: folderName,
                              ),
                            ),
                            (loading.value && pageNum.value != 0)
                                ? const LoadingIndicator()
                                : const SizedBox(),
                          ],
                        ),
                      );
              }
              return const SizedBox();
            }();
          },
        ),
      )),
    );
  }
}
