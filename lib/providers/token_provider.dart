import 'package:moa_app/models/user_model.dart';
import 'package:moa_app/repositories/token_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'token_provider.g.dart';

@riverpod
class TokenState extends _$TokenState {
  @override
  Future<Object?> build() async {
    var token = await TokenRepository.instance.getToken();
    return token;
  }

  Future<Object?> addToken() async {
    state = const AsyncValue.loading();

    state = await AsyncValue.guard(() async {
      return await TokenRepository.instance.getToken();
    });
    return null;
  }

  Future<List<UserModel>?> getMe() async {
    return null;

    // var user = UserRepository.instance.getMe();
    // return user;
  }

  Future<void> removeToken() async {
    state = const AsyncValue.loading();

    state = await AsyncValue.guard(() async {
      await TokenRepository.instance.removeToken();
      return null;
    });
  }
}

/// NotifierProvider
// @riverpod
// class UserState extends _$UserState {
//   @override
//   UserModel? build() {
//     return null;
//   }

//   void addUsers({
//     required UserModel user,
//   }) {
//     state = user;
//   }

//   void remove() {
//     state = null;
//   }
// }
