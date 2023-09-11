import 'dart:async';

import 'package:moa_app/models/content_model.dart';
import 'package:moa_app/repositories/folder_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'folder_detail_provider.g.dart';

/// AsyncNotifierProvider
// @Riverpod(keepAlive: true)
@riverpod
class FolderDetail extends _$FolderDetail {
  Future<List<ContentModel>> fetchItem({
    required String folderName,
    int? page,
    int? size,
  }) async {
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

    var data = await FolderRepository.instance.getFolderDetailList(
      folderName: folderName,
      page: page,
      size: size,
    );
    return data;
  }

  @override
  Future<List<ContentModel>?> build() async {
    return null;
  }

  Future<void> refresh({required String folderName}) async {
    state = const AsyncValue.loading();

    state = await AsyncValue.guard(() async {
      return fetchItem(folderName: folderName);
    });
  }
}
