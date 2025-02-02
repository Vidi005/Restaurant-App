import 'package:restaurant_app/static/notification_state.dart';
import 'package:restaurant_app/static/theme_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesService {
  final SharedPreferences _preference;

  SharedPreferencesService(this._preference);

  static const keyThemeMode = 'THEME_MODE';
  static const keyLunchNotification = 'LUNCH_NOTIFICATION';

  Future saveThemeMode(theme) async {
    try {
      await _preference.setString(keyThemeMode, theme);
    } catch (e) {
      throw Exception('Shared Preferences can\'t save the theme mode.');
    }
  }

  Future saveLunchNotification(notification) async {
    try {
      await _preference.setBool(keyLunchNotification, notification);
    } catch (e) {
      throw Exception('Shared Preferences can\'t save the lunch notification.');
    }
  }

  getThemeMode() async =>
      _preference.getString(keyThemeMode) ?? ThemeState.system.name;

  getLunchNotification() async =>
      _preference.getBool(keyLunchNotification) ??
      NotificationState.enable.isEnable;
}
