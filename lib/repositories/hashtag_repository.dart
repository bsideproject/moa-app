import 'package:dio/dio.dart';
import 'package:moa_app/models/content_model.dart';
import 'package:moa_app/models/hashtag_model.dart';
import 'package:moa_app/repositories/token_repository.dart';
import 'package:moa_app/utils/api.dart';

abstract class IHashtagRepository {
  Future<(List<ContentModel>, int)> getHashtagView({
    int? page,
    int? size,
    String? tag,
  });
  Future<List<HashtagModel>> getHashtagList();
  Future<void> editHashtag({
    required String tagId,
    required String hashtags,
  });
}

class HashtagRepository implements IHashtagRepository {
  const HashtagRepository._();
  static HashtagRepository instance = const HashtagRepository._();

  @override
  Future<(List<ContentModel>, int)> getHashtagView({
    int? page = 0,
    int? size = 10,
    String? tag,
  }) async {
    var token = await TokenRepository.instance.getToken();

    var res = await dio.get(
      tag == null
          ? '/api/v1/hashtag/view?page=$page&size=$size'
          : '/api/v1/hashtag/view?tag=$tag&page=$page&size=$size',
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
        },
      ),
    );

    return (
      res.data['data']
          .map<ContentModel>(
            (e) => ContentModel.fromJson(e),
          )
          .toList() as List<ContentModel>,
      res.data['count'] as int
    );
  }

  @override
  Future<List<HashtagModel>> getHashtagList() async {
    var token = await TokenRepository.instance.getToken();

    var res = await dio.get(
      '/api/v1/hashtag',
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
        },
      ),
    );

    return res.data['data']['users']
        .map<HashtagModel>((e) => HashtagModel.fromJson(e))
        .toList();
  }

  @override
  Future<void> editHashtag({
    required String tagId,
    required String hashtags,
  }) async {
    var token = await TokenRepository.instance.getToken();

    await dio.post(
      '/api/v1/hashtag/edit',
      data: {
        'tagId': tagId,
        'hashtag': hashtags,
      },
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
        },
      ),
    );
  }
}
