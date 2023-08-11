import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:moa_app/constants/app_constants.dart';
import 'package:moa_app/constants/file_constants.dart';
import 'package:moa_app/models/folder_model.dart';
import 'package:moa_app/providers/folder_view_provider.dart';
import 'package:moa_app/repositories/folder_repository.dart';
import 'package:moa_app/utils/general.dart';
import 'package:moa_app/utils/logger.dart';
import 'package:moa_app/widgets/loading_indicator.dart';
import 'package:moa_app/widgets/moa_widgets/add_folder.dart';
import 'package:moa_app/widgets/moa_widgets/bottom_modal_item.dart';
import 'package:moa_app/widgets/moa_widgets/delete_content.dart';
import 'package:moa_app/widgets/moa_widgets/edit_content.dart';
import 'package:moa_app/widgets/moa_widgets/folder_list.dart';
import 'package:moa_app/widgets/snackbar.dart';

class EditFolder extends HookConsumerWidget {
  const EditFolder({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var width = MediaQuery.of(context).size.width;
    var folderAsync = ref.watch(folderViewProvider);
    var updatedContentName = useState('');
    Future<void> folderPullToRefresh() async {
      await ref.read(folderViewProvider.notifier).refresh();
    }

    void showAddFolderModal() {
      General.instance.showBottomSheet(
        context: context,
        child: AddFolder(
          onRefresh: () {},
        ),
      );
    }

    void showEditFolderModal({required String folderName}) {
      General.instance.showBottomSheet(
        context: context,
        child: EditContent(
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
              if (context.mounted) {
                context.pop();
              }
            } on DioException catch (error) {
              logger.d(error);
              // 폴더 중복 에러 처리
              if (error.response!.statusCode == 409) {
                snackbar.alert(context,
                    kDebugMode ? error.toString() : '이미 가지고 있는 폴더이름이에요');
                return;
              }

              snackbar.alert(context,
                  kDebugMode ? error.toString() : '오류가 발생했어요 다시 시도해주세요.');
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

    void showFolderModal(
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

    return RefreshIndicator(
      onRefresh: folderPullToRefresh,
      child: folderAsync.when(
          data: (data) {
            var list = [
              const FolderModel(
                folderId: 'folderId',
                folderName: 'folderName',
                count: 0,
              ),
              ...data
            ];
            return GridView.builder(
              padding: const EdgeInsets.only(left: 15, right: 15, top: 20),
              itemCount: list.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: width > Breakpoints.md ? 3 : 2,
                childAspectRatio: 1.3,
                mainAxisSpacing: 20.0,
                crossAxisSpacing: 12.0,
              ),
              itemBuilder: (context, index) {
                var item = list[index];

                return index == 0
                    ? InkWell(
                        splashColor: Colors.transparent,
                        borderRadius: BorderRadius.circular(15),
                        onTap: showAddFolderModal,
                        child: Image(image: Assets.emptyFolder),
                      )
                    : FolderList(
                        folder: FolderModel(
                          folderId: item.folderId,
                          folderName: item.folderName,
                          count: item.count,
                          thumbnailUrl: item.thumbnailUrl,
                        ),
                        folderColor: folderColors[index % 4],
                        onPressMore: () => showFolderModal(
                          folderName: item.folderName,
                          folderColor: folderColors[index % 4],
                        ),
                        onPress: null,
                      );
              },
            );
          },
          error: (error, stackTrace) => const SizedBox(),
          loading: () => const LoadingIndicator()),
    );
  }
}
