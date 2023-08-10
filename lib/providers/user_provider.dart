import 'dart:async';

import 'package:moa_app/models/user_model.dart';
import 'package:moa_app/providers/token_provider.dart';
import 'package:moa_app/repositories/user_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'user_provider.g.dart';

@riverpod
class UserState extends _$UserState {
  Future<UserModel?> fetchItem() async {
    var token = ref.watch(tokenStateProvider).value;
    // get the [KeepAliveLink]
    ref.keepAlive();

    var data = await UserRepository.instance.getUser(token: token);
    return data;
  }

  @override
  Future<UserModel?> build() async {
    return fetchItem();
  }

  Future<void> editUserName({required String nickname}) async {
    state = const AsyncValue.loading();

    state = await AsyncValue.guard(() async {
      await UserRepository.instance.editUserNickname(nickname: nickname);
      return fetchItem();
    });
  }
}
