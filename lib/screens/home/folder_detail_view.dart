import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:moa_app/constants/file_constants.dart';
import 'package:moa_app/widgets/app_bar.dart';

class FolderDetailView extends HookWidget {
  const FolderDetailView({super.key, required this.folderName});
  final String folderName;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBarBack(
          title: Text(folderName),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: Image(
                width: 36,
                height: 36,
                image: Assets.menu,
              ),
            ),
          ],
        ),
        body: const Text('hello'));
  }
}
