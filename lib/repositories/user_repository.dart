import 'package:dio/dio.dart';
import 'package:moa_app/models/user_model.dart';
import 'package:moa_app/repositories/token_repository.dart';
import 'package:moa_app/utils/api.dart';

abstract class IUserRepository {
  Future<UserModel?> getUser({required String userId});
}

class UserRepository implements IUserRepository {
  const UserRepository._();
  static UserRepository instance = const UserRepository._();

  @override
  Future<UserModel?> getUser({required String userId}) async {
    var token = await TokenRepository.instance.getToken();

    var res = await dio.get(
      '/api/v1/profile',
      data: {
        'userId': userId,
      },
      options: Options(
        headers: {'oauth-token': token},
      ),
    );

    return res.data;
  }
}
