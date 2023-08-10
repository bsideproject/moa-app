import 'package:moa_app/repositories/token_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'token_provider.g.dart';

@riverpod
class TokenState extends _$TokenState {
  @override
  Future<String?> build() async {
    return await TokenRepository.instance.getToken();
  }

  Future<String?> addToken(String token) async {
    state = const AsyncValue.loading();

    state = await AsyncValue.guard(() async {
      return token;
    });
    return null;
  }

  Future<void> removeToken() async {
    state = const AsyncValue.loading();

    state = await AsyncValue.guard(() async {
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
