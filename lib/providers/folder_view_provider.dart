import 'dart:async';

import 'package:moa_app/models/folder_model.dart';
import 'package:moa_app/providers/token_provider.dart';
import 'package:moa_app/repositories/folder_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'folder_view_provider.g.dart';

/// AsyncNotifierProvider
// @Riverpod(keepAlive: true)
@riverpod
class FolderView extends _$FolderView {
  Future<List<FolderModel>> fetchItem() async {
    var token = ref.watch(tokenStateProvider).value;

    if (token == null) {
      return [];
    }
    // get the [KeepAliveLink]
    var link = ref.keepAlive();
    // a timer to be used by the callbacks below
    Timer? timer;
    // An object from package:dio that allows cancelling http requests
    // When the provider is destroyed, cancel the http request and the timer
    ref.onDispose(() {
      timer?.cancel();
    });
    // When the last listener is removed, start a timer to dispose the cached data
    ref.onCancel(() {
      // start a 30 second timer
      timer = Timer(const Duration(seconds: 30), () {
        // dispose on timeout
        link.close();
      });
    });
    // If the provider is listened again after it was paused, cancel the timer
    ref.onResume(() {
      timer?.cancel();
    });

    var data = await FolderRepository.instance.getFolderList(token: token);
    return data;
  }

  @override
  Future<List<FolderModel>> build() async {
    return fetchItem();
  }

  Future<void> addFolder({
    required String folderName,
  }) async {
    state = const AsyncValue.loading();

    state = await AsyncValue.guard(() async {
      // await FolderRepository.instance.addFolder(folderName: folderName);
      return fetchItem();
    });
  }

  Future<void> editFolderName({
    required String currentFolderName,
    required String editFolderName,
  }) async {
    state = const AsyncValue.loading();

    state = await AsyncValue.guard(() async {
      // await FolderRepository.instance.editFolderName(
      //   currentFolderName: currentFolderName,
      //   editFolderName: editFolderName,
      // );
      return fetchItem();
    });
  }

  Future<void> deleteFolder({required String folderName}) async {
    state = const AsyncValue.loading();

    state = await AsyncValue.guard(() async {
      // await FolderRepository.instance.deleteFolder(folderName: folderName);

      return fetchItem();
    });
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();

    state = await AsyncValue.guard(() async {
      return fetchItem();
    });
  }
}
