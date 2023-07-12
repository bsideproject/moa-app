import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:moa_app/constants/color_constants.dart';
import 'package:moa_app/constants/file_constants.dart';
import 'package:moa_app/constants/font_constants.dart';
import 'package:moa_app/models/folder_model.dart';

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
        borderRadius: BorderRadius.circular(12),
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

                        // todo 폴더 첫이미지 url
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
                    style: const Hash1TextStyle(),
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
              margin: const EdgeInsets.only(top: 25),
              child: Material(
                clipBehavior: Clip.antiAlias,
                borderRadius: BorderRadius.circular(25),
                color: Colors.transparent,
                child: IconButton(
                  iconSize: 24,
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
