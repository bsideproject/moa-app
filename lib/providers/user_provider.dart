import 'package:moa_app/models/user_model.dart';
import 'package:moa_app/repositories/user_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'user_provider.g.dart';

@riverpod
class UserState extends _$UserState {
  Future<List<UserModel>?> getMe() async {
    var user = UserRepository.instance.getMe();
    return user;
  }

  @override
  Future<List<UserModel>?> build() async {
    var me = UserRepository.instance.getMe();
    return me;
  }

  Future<void> removeUser() async {
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
