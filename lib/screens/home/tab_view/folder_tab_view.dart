import 'package:dio/dio.dart';
import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:loading_more_list/loading_more_list.dart';
import 'package:moa_app/constants/app_constants.dart';
import 'package:moa_app/constants/file_constants.dart';
import 'package:moa_app/models/folder_model.dart';
import 'package:moa_app/providers/folder_view_provider.dart';
import 'package:moa_app/repositories/folder_repository.dart';
import 'package:moa_app/screens/home/folder_detail_view.dart';
import 'package:moa_app/screens/home/home.dart';
import 'package:moa_app/utils/general.dart';
import 'package:moa_app/utils/logger.dart';
import 'package:moa_app/utils/router_provider.dart';
import 'package:moa_app/widgets/loading_indicator.dart';
import 'package:moa_app/widgets/moa_widgets/add_folder.dart';
import 'package:moa_app/widgets/moa_widgets/bottom_modal_item.dart';
import 'package:moa_app/widgets/moa_widgets/delete_content.dart';
import 'package:moa_app/widgets/moa_widgets/edit_content.dart';
import 'package:moa_app/widgets/moa_widgets/folder_list.dart';
import 'package:moa_app/widgets/snackbar.dart';

class FolderTabView extends HookConsumerWidget {
  const FolderTabView({
    super.key,
    required this.uniqueKey,
    required this.source,
    this.isRefresh,
  });
  final Key uniqueKey;
  final FolderSource source;
  final bool? isRefresh;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var width = MediaQuery.of(context).size.width;
    var updatedContentName = useState('');

    useEffect(() {
      if (isRefresh == true) {
        source.refresh(true);
      }
      return null;
    }, [isRefresh]);

    void showAddFolderModal() {
      General.instance.showBottomSheet(
        context: context,
        // isScrollControlled: true,
        child: AddFolder(
          onRefresh: () {
            source.refresh(true);
          },
        ),
      );
    }

    void goFolderDetailView({
      required String folderName,
      required int contentCount,
      required String folderId,
    }) {
      context.go(
          '${GoRoutes.folder.fullPath}/$folderId?folderName=$folderName&c=$contentCount',
          extra: FolderDetailView(
            folderName: folderName,
            id: folderId,
            contentCount: contentCount,
          ));
    }

    void showEditFolderModal({required String folderName}) {
      General.instance.showBottomSheet(
        context: context,
        child: EditContent(
          maxLength: 10,
          title: '폴더명 수정',
          updatedContentName: updatedContentName,
          contentName: folderName,
          onPressed: () async {
            try {
              await FolderRepository.instance.editFolderName(
                currentFolderName: folderName,
                editFolderName: updatedContentName.value,
              );
              await ref.read(folderViewProvider.notifier).editFolderName(
                    currentFolderName: folderName,
                    editFolderName: updatedContentName.value,
                  );
              await source.refresh(true);
              if (context.mounted) {
                context.pop();
              }
            } on DioException catch (error) {
              logger.d(error);
              // 폴더 중복 에러 처리
              if (error.response!.statusCode == 409) {
                if (context.mounted) {
                  snackbar.alert(context,
                      kDebugMode ? error.toString() : '이미 가지고 있는 폴더이름이에요');
                }
                return;
              }

              if (context.mounted) {
                snackbar.alert(context,
                    kDebugMode ? error.toString() : '오류가 발생했어요 다시 시도해주세요.');
              }
            }
          },
        ),
      );
    }

    void showDeleteFolderModal(
        {required String folderName, required Color folderColor}) {
      General.instance.showBottomSheet(
        height: 350,
        context: context,
        isCloseButton: true,
        child: DeleteContent(
          folderColor: folderColor,
          contentName: folderName,
          type: ContentType.folder,
          onPressed: () async {
            try {
              await FolderRepository.instance
                  .deleteFolder(folderName: folderName);
              await ref.read(folderViewProvider.notifier).deleteFolder(
                    folderName: folderName,
                  );
              if (context.mounted) {
                context.pop();
              }
            } catch (error) {
              if (context.mounted) {
                snackbar.alert(context,
                    kDebugMode ? error.toString() : '오류가 발생했어요 다시 시도해주세요.');
              }
            }
          },
        ),
      );
    }

    void showFolderDetailModal(
        {required String folderName, required Color folderColor}) {
      General.instance.showBottomSheet(
        context: context,
        height: 200,
        child: Column(
          children: [
            BottomModalItem(
              icon: Assets.pencil,
              title: '폴더명 수정',
              onPressed: () {
                context.pop();
                showEditFolderModal(folderName: folderName);
              },
            ),
            BottomModalItem(
              icon: Assets.trash,
              title: '폴더 삭제',
              onPressed: () {
                context.pop();
                showDeleteFolderModal(
                  folderName: folderName,
                  folderColor: folderColor,
                );
              },
            ),
          ],
        ),
      );
    }

    return ExtendedVisibilityDetector(
      uniqueKey: uniqueKey,
      child: RefreshIndicator(
        onRefresh: () async {
          ref.refresh(folderViewProvider).value;
          await source.refresh(true);
        },
        child: LoadingMoreList<FolderModel>(
          ListConfig<FolderModel>(
            physics: const BouncingScrollPhysics(),
            addRepaintBoundaries: true,
            padding: const EdgeInsets.only(
              left: 15,
              right: 15,
              top: 10,
              bottom: kBottomNavigationBarHeight,
            ),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: width > Breakpoints.md ? 3 : 2,
              childAspectRatio: 1.3,
              mainAxisSpacing: 20.0,
              crossAxisSpacing: 12.0,
            ),
            sourceList: source,
            indicatorBuilder: (context, status) {
              if ((status == IndicatorStatus.loadingMoreBusying) ||
                  (status == IndicatorStatus.fullScreenBusying)) {
                return const LoadingIndicator();
              }
              return const SizedBox();
            },
            itemBuilder: (c, item, index) {
              return index == 0
                  ? InkWell(
                      splashColor: Colors.transparent,
                      borderRadius: BorderRadius.circular(15),
                      onTap: showAddFolderModal,
                      child: Image(image: Assets.emptyFolder),
                    )
                  : FolderList(
                      folder: FolderModel(
                        folderColor: item.folderColor,
                        folderId: item.folderId,
                        folderName: item.folderName,
                        count: item.count,
                        thumbnailUrl: item.thumbnailUrl,
                      ),
                      folderColor: item.folderColor,
                      onPressMore: () => showFolderDetailModal(
                        folderName: item.folderName,
                        folderColor: item.folderColor,
                      ),
                      onPress: () => goFolderDetailView(
                        folderName: item.folderName,
                        contentCount: item.count,
                        folderId: item.folderId,
                      ),
                    );
            },
          ),
        ),
      ),
    );
  }
}
