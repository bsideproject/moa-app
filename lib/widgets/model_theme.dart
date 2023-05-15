import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:moa_app/widgets/my_theme_preferences.dart';

class ModelTheme extends ChangeNotifier {
  ModelTheme() {
    _isDark = false;
    _preferences = MyThemePreferences();
    getPreferences();
  }
  late bool _isDark;
  late MyThemePreferences _preferences;
  bool get isDark => _isDark;

  void toggleTheme() {
    _isDark = !_isDark;
    _preferences.setTheme(!_isDark);
    notifyListeners();
  }

  set isDark(bool value) {
    _isDark = value;
    _preferences.setTheme(value);
    notifyListeners();
  }

  Future<void> getPreferences() async {
    var schedulerBinding = SchedulerBinding.instance;
    var brightness = schedulerBinding.platformDispatcher.platformBrightness;
    var isDarkMode = brightness == Brightness.dark;
    if (isDarkMode) {
      _isDark = isDarkMode;
      await _preferences.setTheme(isDarkMode);
      notifyListeners();
      return;
    }

    _isDark = await _preferences.getTheme();
    notifyListeners();
  }
}

final modelProvider = ChangeNotifierProvider<ModelTheme>((ref) {
  return ModelTheme();
});
