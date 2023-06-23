import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:loading_more_list/loading_more_list.dart';
import 'package:moa_app/constants/app_constants.dart';
import 'package:moa_app/constants/color_constants.dart';
import 'package:moa_app/constants/file_constants.dart';
import 'package:moa_app/constants/font_constants.dart';
import 'package:moa_app/models/folder_model.dart';
import 'package:moa_app/screens/home/folder_detail_view.dart';
import 'package:moa_app/screens/home/home.dart';
import 'package:moa_app/utils/router_provider.dart';
import 'package:moa_app/widgets/loading_indicator.dart';

class FolderTabView extends HookWidget {
  const FolderTabView(
      {super.key, required this.uniqueKey, required this.source});
  final Key uniqueKey;
  final FolderSource source;

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;

    void addFolder() {}

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
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
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
                      onTap: addFolder,
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

class FolderList extends HookWidget {
  const FolderList({
    super.key,
    required this.folder,
    required this.folderColor,
    required this.onPress,
  });
  final FolderModel folder;
  final Color folderColor;
  final Function() onPress;

  @override
  Widget build(BuildContext context) {
    return Ink(
      decoration: BoxDecoration(
        image: DecorationImage(
          fit: BoxFit.contain,
          image: Assets.folder,
          colorFilter: ColorFilter.mode(
            folderColor,
            BlendMode.srcIn,
          ),
        ),
      ),
      child: InkWell(
        splashColor: Colors.transparent,
        borderRadius: BorderRadius.circular(15),
        onTap: onPress,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(top: 30),
                        width: 32,
                        height: 32,
                        child: const CircleAvatar(
                          radius: 30,
                          backgroundColor: AppColors.blackColor,
                          child: Icon(Icons.access_alarm),
                        ),
                      ),
                      Positioned(
                        top: 30,
                        left: 16,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 7, vertical: 3),
                          decoration: BoxDecoration(
                            color: AppColors.whiteColor,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            '+56',
                            style: const FolderSubTitleTextStyle()
                                .merge(const TextStyle(
                              fontWeight: FontWeight.bold,
                            )),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Text(
                    folder.title,
                    style: const FolderTitleTextStyle(),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    '최근 저장 23.05.30',
                    style: const FolderSubTitleTextStyle().merge(
                      const TextStyle(
                        color: AppColors.placeholder,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 25),
              child: Material(
                clipBehavior: Clip.antiAlias,
                borderRadius: BorderRadius.circular(25),
                color: Colors.transparent,
                child: IconButton(
                  iconSize: 24,
                  onPressed: () {},
                  icon: const Icon(
                    Icons.more_vert,
                    color: AppColors.blackColor,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
