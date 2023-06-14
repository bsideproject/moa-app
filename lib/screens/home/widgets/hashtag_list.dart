import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:moa_app/constants/color_constants.dart';
import 'package:moa_app/constants/file_constants.dart';
import 'package:moa_app/constants/font_constants.dart';

class HashtagList extends HookWidget {
  const HashtagList({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          fit: BoxFit.contain,
          image: Assets.folder,
          colorFilter: const ColorFilter.mode(
            AppColors.folderColorECD8F3,
            BlendMode.srcIn,
          ),
        ),
      ),
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
                const Text(
                  '인테리어',
                  style: FolderTitleTextStyle(),
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
    );
  }
}
