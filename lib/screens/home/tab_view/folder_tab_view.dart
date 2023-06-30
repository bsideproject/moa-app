import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:loading_more_list/loading_more_list.dart';
import 'package:moa_app/constants/app_constants.dart';
import 'package:moa_app/constants/file_constants.dart';
import 'package:moa_app/models/folder_model.dart';
import 'package:moa_app/screens/home/folder_detail_view.dart';
import 'package:moa_app/screens/home/home.dart';
import 'package:moa_app/screens/home/widgets/add_folder_bottom_sheet.dart';
import 'package:moa_app/utils/general.dart';
import 'package:moa_app/utils/router_provider.dart';
import 'package:moa_app/widgets/folder_list.dart';
import 'package:moa_app/widgets/loading_indicator.dart';

class FolderTabView extends HookWidget {
  const FolderTabView(
      {super.key, required this.uniqueKey, required this.source});
  final Key uniqueKey;
  final FolderSource source;

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;

    void showAddFolderModal() {
      General.instance.showBottomSheet(
        context: context,
        child: const AddFolderBottomSheet(),
        isContainer: false,
      );
    }

    void goFolderDetailView(String title) {
      context.push(
        '${GoRoutes.home.fullPath}/${GoRoutes.folderDetail.path}/$title',
        extra: FolderDetailView(folderName: title),
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
              source.refresh(false);
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
              crossAxisCount: width > Breakpoints.md ? 4 : 2,
              childAspectRatio: 1.3,
              mainAxisSpacing: 20.0,
              crossAxisSpacing: 12.0,
            ),
            sourceList: source,
            indicatorBuilder: (context, status) {
              return const LoadingIndicator();
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
                      folder: item,
                      folderColor: folderColors[index % 4],
                      onPress: () => goFolderDetailView(item.title),
                    );
            },
          ),
        ),
      ),
    );
  }
}
