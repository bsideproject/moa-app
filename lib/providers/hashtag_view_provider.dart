import 'dart:async';

import 'package:moa_app/models/content_model.dart';
import 'package:moa_app/repositories/content_repository.dart';
import 'package:moa_app/repositories/hashtag_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'hashtag_view_provider.g.dart';

/// AsyncNotifierProvider
// @Riverpod(keepAlive: true)
@riverpod
class HashtagView extends _$HashtagView {
  Future<(List<ContentModel>, int)> fetchItem() async {
    // // get the [KeepAliveLink]
    // var link = ref.keepAlive();
    // // a timer to be used by the callbacks below
    // Timer? timer;
    // // An object from package:dio that allows cancelling http requests
    // // When the provider is destroyed, cancel the http request and the timer
    // ref.onDispose(() {
    //   timer?.cancel();
    // });
    // // When the last listener is removed, start a timer to dispose the cached data
    // ref.onCancel(() {
    //   // start a 30 second timer
    //   timer = Timer(const Duration(seconds: 30), () {
    //     // dispose on timeout
    //     link.close();
    //   });
    // });
    // // If the provider is listened again after it was paused, cancel the timer
    // ref.onResume(() {
    //   timer?.cancel();
    // });

    var data = await HashtagRepository.instance.getHashtagView();
    return data;
  }

  @override
  Future<(List<ContentModel>, int)> build() async {
    return fetchItem();
  }

  Future<void> deleteContent({required String contentId, required}) async {
    state = const AsyncValue.loading();

    state = await AsyncValue.guard(() async {
      await ContentRepository.instance.deleteContent(contentId: contentId);
      var value = state.value;
      if (value != null) {
        var (list, count) = value;
        var filteredList =
            list.where((element) => element.contentId != contentId).toList();

        return (filteredList, count);
      }

      return value!;
    });
  }

  Future<(List<ContentModel>, int)> loadMoreData({
    int? page,
    int? size,
  }) async {
    state = const AsyncValue.loading();

    state = await AsyncValue.guard(() async {
      var data = await HashtagRepository.instance
          .getHashtagView(page: page, size: size);
      return data;
    });

    return state.value!;
  }
}
