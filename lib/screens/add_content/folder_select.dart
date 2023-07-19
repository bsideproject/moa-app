import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:moa_app/constants/app_constants.dart';
import 'package:moa_app/constants/file_constants.dart';
import 'package:moa_app/constants/font_constants.dart';
import 'package:moa_app/models/folder_model.dart';
import 'package:moa_app/repositories/folder_repository.dart';
import 'package:moa_app/screens/add_content/add_image_content.dart';
import 'package:moa_app/screens/add_content/add_link_content.dart';
import 'package:moa_app/utils/router_provider.dart';
import 'package:moa_app/widgets/alert_dialog.dart';
import 'package:moa_app/widgets/app_bar.dart';
import 'package:moa_app/widgets/loading_indicator.dart';

class FolderSelect extends HookWidget {
  const FolderSelect({super.key});

  @override
  Widget build(BuildContext context) {
    // void editFolder() {}

    void selectFolder({required int index, required String folderId}) {
      alertDialog.select(
        context,
        title: '선택',
        content: '이미지로 추가하시겠습니까?\n아니면 링크를 추가하시겠습니까?',
        leftText: '이미지',
        rightText: '링크',
        onPressRight: () {
          context.push(
            '${GoRoutes.folderSelect.fullPath}/${GoRoutes.addLinkContent.path}',
            extra: AddLinkContent(folderId: folderId),
          );
        },
        onPressLeft: () {
          context.push(
            '${GoRoutes.folderSelect.fullPath}/${GoRoutes.addImageContent.path}',
            extra: AddImageContent(folderId: folderId),
          );
        },
      );
    }

    return Scaffold(
      appBar: const AppBarBack(
        isBottomBorderDisplayed: false,
        title: '폴더 선택',
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: FutureBuilder<List<FolderModel>>(
            future: FolderRepository.instance.getFolderList(),
            builder: (context, snapshot) {
              var folderList = snapshot.data ?? [];
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const LoadingIndicator();
              }

              if (snapshot.hasData) {
                return GridView.builder(
                  itemCount: folderList.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    childAspectRatio: 1.3,
                    mainAxisSpacing: 30.0,
                    crossAxisSpacing: 20.0,
                    mainAxisExtent: 115,
                  ),
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            SizedBox(
                              height: 85,
                              child: Ink(
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    fit: BoxFit.contain,
                                    image: Assets.folder,
                                    colorFilter: ColorFilter.mode(
                                      folderColors[index % 4],
                                      BlendMode.srcIn,
                                    ),
                                  ),
                                ),
                                child: InkWell(
                                  splashColor: Colors.transparent,
                                  borderRadius: BorderRadius.circular(8),
                                  onTap: () => selectFolder(
                                      index: index,
                                      folderId: folderList[index].folderId),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text(
                          folderList[index].folderName,
                          style: const H4TextStyle(),
                        )
                      ],
                    );
                  },
                );
              }
              return const SizedBox();
            },
          ),
        ),
      ),
    );
  }
}
