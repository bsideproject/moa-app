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
import 'package:moa_app/widgets/folder_list.dart';
import 'package:moa_app/widgets/loading_indicator.dart';
import 'package:moa_app/widgets/moa_widgets/add_folder.dart';
import 'package:moa_app/widgets/moa_widgets/edit_content.dart';

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

    void goFolderDetailView(String folderId) {
      context.go(
        '${GoRoutes.folder.fullPath}/$folderId',
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

    return ExtendedVisibilityDetector(
      uniqueKey: uniqueKey,
      child: RefreshIndicator(
        onRefresh: () {
          // return source.refresh(true);
          return Future.delayed(
            const Duration(seconds: 2),
            () {
              source.refresh(true);
            },
          );
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
              if (status == IndicatorStatus.loadingMoreBusying) {
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
                      folder: item,
                      folderColor: folderColors[index % 4],
                      onPressMore: () =>
                          showEditFolderModal(folderName: item.folderName),
                      onPress: () => goFolderDetailView(item.folderId),
                    );
            },
          ),
        ),
      ),
    );
  }
}
