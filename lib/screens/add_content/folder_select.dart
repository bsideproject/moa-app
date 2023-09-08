import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
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

class FolderSelect extends HookConsumerWidget {
  const FolderSelect({super.key, this.receiveUrl});
  final String? receiveUrl;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    void selectFolder({required int index, required String folderId}) {
      if (receiveUrl != null) {
        context.push(
          '${GoRoutes.folderSelect.fullPath}/${GoRoutes.addLinkContent.path}',
          extra: AddLinkContent(
            folderId: folderId,
            receiveUrl: receiveUrl,
          ),
        );
        return;
      }
      alertDialog.select(
        context,
        title: '어떤 취향으로 저장하시겠어요?',
        content: '모으고 싶은 취향 유형을 선택해 주세요.',
        topText: '이미지',
        bottomText: '링크',
        onPressTop: () {
          context.push(
            '${GoRoutes.folderSelect.fullPath}/${GoRoutes.addImageContent.path}',
            extra: AddImageContent(folderId: folderId),
          );
        },
        onPressBottom: () {
          context.push(
            '${GoRoutes.folderSelect.fullPath}/${GoRoutes.addLinkContent.path}',
            extra: AddLinkContent(folderId: folderId),
          );
        },
      );
    }

    return Scaffold(
      appBar: AppBarBack(
        isBottomBorderDisplayed: false,
        title: '폴더 선택',
        onPressedBack: () {
          /// 외부 공유url 받아서 들어온 경우 뒤로가기가 안되기 떄문에 홈으로 이동
          if (receiveUrl != null) {
            context.go('/');
            return;
          }
          context.pop();
        },
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
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
                    crossAxisSpacing: 20,
                    mainAxisExtent: 137,
                  ),
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        SizedBox(
                          height: 77,
                          child: Ink(
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                fit: BoxFit.contain,
                                image: Assets.folder,
                                colorFilter: ColorFilter.mode(
                                  folderList[index].folderColor,
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
                        const SizedBox(height: 10),
                        Flexible(
                          child: Text(
                            folderList[index].folderName,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const H4TextStyle(),
                          ),
                        ),
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
