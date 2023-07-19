import 'package:dio/dio.dart';
import 'package:moa_app/models/content_model.dart';
import 'package:moa_app/repositories/token_repository.dart';
import 'package:moa_app/utils/api.dart';

enum ContentType { image, url }

abstract class IContentRepository {
  Future<void> addContent(
      {required ContentType contentType, required ContentModel content});
}

class ContentRepository implements IContentRepository {
  const ContentRepository._();
  static ContentRepository instance = const ContentRepository._();

  @override
  Future<void> addContent(
      {required ContentType contentType, required ContentModel content}) async {
    var token = await TokenRepository.instance.getToken();

    late FormData formData = FormData.fromMap({});

    if (contentType == ContentType.image) {
      /// image 방식
      formData = FormData.fromMap({
        'body': {
          'folderId': content.contentId,
          'name': content.name,
          'memo': content.memo,
          'hashTag': content.hashTags,
          'contentType': 'IMAGE',
        },
        'image': '/Users/a60156077/Downloads/모아조.png'
      });
    }
    if (contentType == ContentType.url) {
      /// 링크 방식
      formData = FormData.fromMap({
        'folderId': 'folderId',
        'name': 'folderName',
        'memo': 'memo',
        'url': 'url',
        'hashTag': 'hashTag',
        'contentType': 'URL', //
      });
    }

    await dio.post(
      '/api/v1/content/create',
      data: formData,
      options: Options(
        headers: {
          'Content-type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      ),
    );
  }
}
