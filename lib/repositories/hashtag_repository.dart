import 'package:dio/dio.dart';
import 'package:moa_app/models/content_model.dart';
import 'package:moa_app/models/hashtag_model.dart';
import 'package:moa_app/repositories/token_repository.dart';
import 'package:moa_app/utils/api.dart';

abstract class IHashtagRepository {
  Future<(List<ContentModel>, int)> getHashtagView({
    int? page,
    int? size,
  });
  Future<List<HashtagModel>> getHashtagList();
}

class HashtagRepository implements IHashtagRepository {
  const HashtagRepository._();
  static HashtagRepository instance = const HashtagRepository._();

  @override
  Future<(List<ContentModel>, int)> getHashtagView({
    int? page = 0,
    int? size = 10,
  }) async {
    var token = await TokenRepository.instance.getToken();

    var res = await dio.get(
      '/api/v1/hashtag/view?page=$page&size=$size',
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
        },
      ),
    );

    /// 백엔드 ContentModel 타입이 통일되지 않았으므로 임시로 타입 변환해서 넣어줌
    return (
      res.data['data']
          .map<ContentModel>(
            (e) => ContentModel.fromJson({
              'contentId': e['contentId'],
              'contentImageUrl': e['imageUrl'],
              'contentUrl': e['contentUrl'] ?? '',
              'contentMemo': e['memo'],
              'contentName': e['name'],
              'contentHashTag': e['hashTags'],
            }),
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
}
