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
    required String folderId,
    int? page,
    int? size,
  }) async {
    // todo 처음에 불러오는 page==1 일때 데이터만 캐싱하는 방법을 찾아보자
    var data = await FolderRepository.instance.getFolderDetailList(
      folderId: folderId,
      page: page,
      size: size,
    );
    return data;
  }

  @override
  Future<List<ContentModel>?> build({required String folderId}) async {
    return fetchItem(folderId: folderId);
  }

  Future<int> loadMore({
    required String folderId,
    required int page,
  }) async {
    List<ContentModel> res = [];

    state = await AsyncValue.guard(() async {
      res = await fetchItem(
        folderId: folderId,
        page: page,
      );

      return [...state.value!, ...res];
    });

    return res.length;
  }
}
