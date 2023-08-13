import 'package:dio/dio.dart';
import 'package:moa_app/models/user_model.dart';
import 'package:moa_app/repositories/token_repository.dart';
import 'package:moa_app/utils/api.dart';

abstract class IUserRepository {
  Future<UserModel?> getUser({String? token});
  Future<void> withdrawUser();
  Future<void> editUserNickname({required String nickname});
}

class UserRepository implements IUserRepository {
  const UserRepository._();
  static UserRepository instance = const UserRepository._();

  @override
  Future<UserModel?> getUser({String? token}) async {
    var localToken = await TokenRepository.instance.getToken();
    if (localToken == null) {
      return null;
    }
    var res = await dio.get(
      '/api/v1/user/info',
      options: Options(
        headers: {
          'Authorization': 'Bearer ${token ?? localToken}',
        },
      ),
    );

    return UserModel(
        userId: res.data['userId'], email: '', nickname: res.data['nickName']);
  }

  @override
  Future<void> editUserNickname({required String nickname}) async {
    var token = await TokenRepository.instance.getToken();
    await dio.put(
      '/api/v1/user/edit/nickName?nickName=$nickname',
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
        },
      ),
    );
  }

  @override
  Future<void> withdrawUser() async {
    var token = await TokenRepository.instance.getToken();
    await dio.post(
      '/api/v1/user/withdrawal',
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
        },
      ),
    );
  }
}
