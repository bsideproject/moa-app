import 'package:dio/dio.dart';
import 'package:moa_app/models/content_model.dart';
import 'package:moa_app/repositories/token_repository.dart';
import 'package:moa_app/utils/api.dart';

enum AddContentType { image, url }

abstract class IContentRepository {
  Future<void> addContent(
      {required AddContentType contentType, required ContentModel content});
}

class ContentRepository implements IContentRepository {
  const ContentRepository._();
  static ContentRepository instance = const ContentRepository._();

  @override
  Future<void> addContent({
    required AddContentType contentType,
    required ContentModel content,
  }) async {
    var token = await TokenRepository.instance.getToken();

    if (contentType.name == AddContentType.image.name) {
      await dio.post(
        '/api/v1/content/create',
        data: {
          'folderId': content.contentId,
          'name': content.contentName,
          'memo': content.contentMemo,
          'hashTag': '임시, 어드민',
          'contentType': 'IMAGE',
          'originalFileName': '${content.contentName}.png',
          'image': 'image/png:base64:${content.contentImageUrl}',
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );
    }

    if (contentType.name == AddContentType.url.name) {
      /// 링크 방식
    }
  }
}


// 'Content-type': 'multipart/form-data',