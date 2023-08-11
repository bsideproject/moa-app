import 'dart:async';

import 'package:moa_app/models/content_model.dart';
import 'package:moa_app/repositories/content_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'content_detail_provider.g.dart';

@riverpod
class ContentDetail extends _$ContentDetail {
  Future<ContentModel> fetchItem({required String contentId}) async {
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

    var data =
        await ContentRepository.instance.getContentDetail(contentId: contentId);
    return data;
  }

  @override
  Future<ContentModel?> build() async {
    return null;
  }

  Future<void> editContent({
    required String contentId,
    required String contentName,
    required String contentMemo,
    required String hashTagStringList,
  }) async {
    state = const AsyncValue.loading();

    state = await AsyncValue.guard(() async {
      await ContentRepository.instance.editContent(
        contentId: contentId,
        contentName: contentName,
        contentMemo: contentMemo,
        hashTagStringList: hashTagStringList,
      );
      var data = await fetchItem(contentId: contentId);
      return data;
    });
  }
}
