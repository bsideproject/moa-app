import 'package:shared_preferences/shared_preferences.dart';

class MyThemePreferences {
  static const themeKey = 'theme_key';

  Future<void> setTheme(bool value) async {
    var sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setBool(themeKey, value);
  }

  Future<bool> getTheme() async {
    var sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getBool(themeKey) ?? false;
  }
}
