import 'dart:async';

import 'package:moa_app/models/hashtag_model.dart';
import 'package:moa_app/repositories/hashtag_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'hashtag_provider.g.dart';

/// AsyncNotifierProvider
// @Riverpod(keepAlive: true)
@riverpod
class Hashtag extends _$Hashtag {
  Future<List<HashtagModel>> fetchItem() async {
    var data = HashtagRepository.instance.getHashtagList();
    return data;
  }

  @override
  Future<List<HashtagModel>> build() async {
    return fetchItem();
  }

  Future<List<HashtagModel>?> addHashtag({
    required HashtagModel hashtag,
  }) async {
    state = const AsyncValue.loading();

    state = await AsyncValue.guard(() async {
      // await ItemRepository.instance.addItem(item: item);
      var data = await fetchItem();
      return [hashtag, ...data];
    });

    return state.value;
  }
}
