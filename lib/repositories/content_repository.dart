import 'package:dio/dio.dart';
import 'package:moa_app/models/content_model.dart';
import 'package:moa_app/repositories/token_repository.dart';
import 'package:moa_app/utils/api.dart';

enum AddContentType { image, url }

abstract class IContentRepository {
  Future<void> addContent({
    required AddContentType contentType,
    required ContentModel content,
    required String hashTagStringList,
  });

  Future<ContentModel> getContentDetail({
    required String contentId,
  });
}

class ContentRepository implements IContentRepository {
  const ContentRepository._();
  static ContentRepository instance = const ContentRepository._();

  @override
  Future<void> addContent({
    required AddContentType contentType,
    required ContentModel content,
    required String hashTagStringList,
  }) async {
    var token = await TokenRepository.instance.getToken();

    if (contentType == AddContentType.image) {
      /// 이미지 방식
      await dio.post(
        '/api/v1/content/create',
        data: {
          'folderId': content.contentId,
          'name': content.contentName,
          'memo': content.contentMemo,
          'hashTag': hashTagStringList,
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

    if (contentType == AddContentType.url) {
      /// 링크 방식
      await dio.post(
        '/api/v1/content/create',
        data: {
          'folderId': content.contentId,
          'name': content.contentName,
          'memo': content.contentMemo,
          'hashTag': hashTagStringList,
          'contentType': 'URL',
          'url': content.contentUrl,
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
  }

  @override
  Future<ContentModel> getContentDetail({required String contentId}) async {
    var token = await TokenRepository.instance.getToken();

    try {
      var res = await dio.get(
        '/api/v1/content/detail/view?contentId=$contentId',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      /// 백엔드 ContentModel 타입이 통일되지 않았으므로 임시로 타입 변환해서 넣어줌
      return ContentModel.fromJson({
        'contentId': '0',
        'contentImageUrl': res.data['data']['thumbnail_image_url'],
        'contentUrl': res.data['data']['contentUrl'] ?? '',
        'contentMemo': res.data['data']['memo'],
        'contentName': res.data['data']['contentName'],
        'contentHashTag': res.data['data']['hashTags'],
      });
    } catch (e) {
      rethrow;
    }
  }
}
