import 'dart:async';

import 'package:moa_app/models/hashtag_model.dart';
import 'package:moa_app/repositories/hashtag_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'hashtag_provider.g.dart';

/// AsyncNotifierProvider
// @Riverpod(keepAlive: true)
@riverpod
class Hashtag extends _$Hashtag {
  Future<(List<HashtagModel>, List<HashtagModel>)> fetchItem() async {
    var data = HashtagRepository.instance.getHashtagList();
    return data;
  }

  @override
  Future<(List<HashtagModel>, List<HashtagModel>)> build() async {
    return fetchItem();
  }

  Future<void> editHashtag({
    required String tagId,
    required String hashtags,
  }) async {
    state = const AsyncValue.loading();

    state = await AsyncValue.guard(() async {
      // await HashtagRepository.instance.editHashtag(
      //   tagId: tagId,
      //   hashtags: hashtags,
      // );
      var data = await fetchItem();
      return data;
    });
  }

  Future<void> deleteHashtag({
    required List<String> tagIds,
  }) async {
    state = const AsyncValue.loading();

    state = await AsyncValue.guard(() async {
      // await HashtagRepository.instance.deleteHashtag(
      //   tagIds: tagIds,
      // );
      var data = await fetchItem();
      return data;
    });
  }

  Future<void> addHashtag({
    required String hashtag,
  }) async {
    state = const AsyncValue.loading();

    state = await AsyncValue.guard(() async {
      await HashtagRepository.instance.addHashtag(hashTag: hashtag);
      var data = await fetchItem();
      return data;
    });
    return;

    // return state.value;
  }
}
