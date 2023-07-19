import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:loading_more_list/loading_more_list.dart';
import 'package:moa_app/constants/app_constants.dart';
import 'package:moa_app/constants/file_constants.dart';
import 'package:moa_app/models/folder_model.dart';
import 'package:moa_app/repositories/folder_repository.dart';
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

class FolderTabView extends HookWidget {
  const FolderTabView(
      {super.key, required this.uniqueKey, required this.source});
  final Key uniqueKey;
  final FolderSource source;

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var updatedContentName = useState('');

    void showAddFolderModal() {
      General.instance.showBottomSheet(
        context: context,
        child: AddFolder(
          onRefresh: () {
            source.refresh(true);
          },
        ),
        isContainer: false,
      );
    }

    void goFolderDetailView({required String folderName}) {
      context.go(
        '${GoRoutes.folder.fullPath}/$folderName',
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
              await source.refresh(true);
              // todo 폴더명 중복 체크후 중복이면 에러메세지
              // if 중복이면
              // return '이미 가지고 있는 폴더이름이에요!';
              // 중복 아니면
              return '';
            } catch (error) {
              logger.d(error);
            }
          },
        ),
        isContainer: false,
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
            // todo 폴더 삭제 api 연동후 성공하면 아래 코드 실행 실패시 snackbar 경고

            await FolderRepository.instance
                .deleteFolder(folderName: folderName);
            await source.refresh(true);
          },
        ),
      );
    }

    void showFolderDetailModal(
        {required String folderName, required Color folderColor}) {
      General.instance.showBottomSheet(
        context: context,
        padding:
            const EdgeInsets.only(left: 15, right: 15, top: 15, bottom: 30),
        height: 225,
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
        onRefresh: () {
          return source.refresh(true);
        },
        child: LoadingMoreList<FolderModel>(
          ListConfig<FolderModel>(
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
              return index == source.length - 1
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
                        thumbnailUrl: item.thumbnailUrl == 'default'
                            ? ''
                            : item.thumbnailUrl,
                      ),
                      folderColor: folderColors[index % 4],
                      onPressMore: () => showFolderDetailModal(
                        folderName: item.folderName,
                        folderColor: folderColors[index % 4],
                      ),
                      onPress: () =>
                          goFolderDetailView(folderName: item.folderName),
                    );
            },
          ),
        ),
      ),
    );
  }
}
