import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:moa_app/constants/color_constants.dart';
import 'package:moa_app/constants/file_constants.dart';
import 'package:moa_app/constants/font_constants.dart';
import 'package:moa_app/models/folder_model.dart';
import 'package:moa_app/widgets/image.dart';

class FolderList extends HookWidget {
  const FolderList({
    super.key,
    required this.folder,
    required this.folderColor,
    required this.onPress,
    required this.onPressMore,
  });
  final FolderModel folder;
  final Color folderColor;
  final Function() onPress;
  final Function() onPressMore;

  @override
  Widget build(BuildContext context) {
    print('folder.thumbnailUrl:${folder.thumbnailUrl}');
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
                        child: ImageOnNetwork(
                          border: Border.all(
                            color: AppColors.moaOpacity30,
                            width: 0.1,
                          ),
                          imageURL: folder.thumbnailUrl ?? '',
                          borderRadius: 30,
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
                            folder.count.toString(),
                            style: const Hash2TextStyle().merge(const TextStyle(
                              fontWeight: FontWeight.bold,
                            )),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Text(
                    folder.folderName,
                    style: const H4TextStyle(),
                  ),
                  const SizedBox(height: 3),
                  folder.updatedDate != null
                      ? Text(
                          '최근 저장 ${folder.updatedDate}',
                          style: const Hash2TextStyle().merge(
                            const TextStyle(
                              color: AppColors.placeholder,
                            ),
                          ),
                        )
                      : const SizedBox(),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 20),
              child: Material(
                clipBehavior: Clip.antiAlias,
                borderRadius: BorderRadius.circular(25),
                color: Colors.transparent,
                child: IconButton(
                  iconSize: 20,
                  onPressed: onPressMore,
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
