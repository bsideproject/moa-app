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

  Future<void> editContent({
    required String contentId,
    required String contentName,
    required String contentMemo,
    required String hashTagStringList,
  });

  Future<void> deleteContent({
    required String contentId,
  });

  Future<void> changeContentFolder({
    required String contentId,
    required String changeFolderId,
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
          'image': content.thumbnailImageUrl == ''
              ? ''
              : 'image/png:base64:${content.thumbnailImageUrl}',
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
          'image': 'image/png:base64:${content.thumbnailImageUrl}',
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

      return ContentModel.fromJson(res.data['data']);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> editContent({
    required String contentId,
    required String contentName,
    required String contentMemo,
    required String hashTagStringList,
    String? changeContentUrl,
  }) async {
    var token = await TokenRepository.instance.getToken();

    await dio.put(
      '/api/v1/content/edit',
      data: {
        'contentId': contentId,
        'changeContentName': contentName,
        // 'changeContentUrl': changeContentUrl,
        'changeContentMemo': contentMemo,
        'hashTag': hashTagStringList,
      },
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
        },
      ),
    );
  }

  @override
  Future<void> deleteContent({required String contentId}) async {
    var token = await TokenRepository.instance.getToken();

    await dio.post(
      '/api/v1/content/delete',
      data: {
        'ids': [contentId]
      },
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
        },
      ),
    );
  }

  @override
  Future<void> changeContentFolder({
    required String contentId,
    required String changeFolderId,
  }) async {
    var token = await TokenRepository.instance.getToken();

    await dio.put(
      '/api/v1/content/folder-change',
      data: {'contentId': contentId, 'changeFolderId': changeFolderId},
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
        },
      ),
    );
  }
}
