// NotifierProvider
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'button_click_provider.g.dart';

@riverpod
class ButtonClickState extends _$ButtonClickState {
  @override
  bool build() {
    ref.keepAlive();
    return false;
  }

  void isClick({
    required bool click,
  }) {
    state = click;
  }
}
