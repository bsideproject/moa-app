import 'dart:async';

import 'package:moa_app/models/content_model.dart';
import 'package:moa_app/repositories/hashtag_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'hashtag_view_provider.g.dart';

/// AsyncNotifierProvider
// @Riverpod(keepAlive: true)
@riverpod
class HashtagView extends _$HashtagView {
  Future<(List<ContentModel>, int)> fetchItem() async {
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

    var data = HashtagRepository.instance.getHashtagView();
    return data;
  }

  @override
  Future<(List<ContentModel>, int)> build() async {
    return fetchItem();
  }
}
