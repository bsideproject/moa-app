import 'package:dio/dio.dart';
import 'package:moa_app/models/content_model.dart';
import 'package:moa_app/repositories/token_repository.dart';
import 'package:moa_app/utils/api.dart';

abstract class IHashtagRepository {
  Future<(List<ContentModel>, int)> getHashtagList();
}

class HashtagRepository implements IHashtagRepository {
  const HashtagRepository._();
  static HashtagRepository instance = const HashtagRepository._();

  @override
  Future<(List<ContentModel>, int)> getHashtagList() async {
    var token = await TokenRepository.instance.getToken();

    var res = await dio.get(
      '/api/v1/hashtag/view',
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
        },
      ),
    );

    return (
      res.data['data']
          .map<ContentModel>((e) => ContentModel.fromJson(e))
          .toList() as List<ContentModel>,
      res.data['count'] as int
    );
  }
}
