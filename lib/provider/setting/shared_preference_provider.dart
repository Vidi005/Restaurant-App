import 'package:flutter/widgets.dart';
import 'package:restaurant_app/data/local/shared_preferences_service.dart';

class SharedPreferenceProvider extends ChangeNotifier {
  final SharedPreferencesService _service;

  SharedPreferenceProvider(this._service);

  var _message = '';
  get message => _message;

  String? _themeMode;
  get themeMode => _themeMode;

  bool? _lunchNotification;
  get lunchNotification => _lunchNotification;

  Future saveThemeMode(theme) async {
    try {
      await _service.saveThemeMode(theme);
      _themeMode = theme;
      _message = 'Theme mode has been changed to $_themeMode theme';
    } catch (e) {
      _message = 'Failed to change theme mode';
    }
    notifyListeners();
  }

  Future saveLunchNotification(notification) async {
    try {
      await _service.saveLunchNotification(notification);
      _lunchNotification = notification;
      if (notification) {
        _message = 'Lunch notification reminder has been enabled';
      } else {
        _message = 'Lunch notification reminder has been disabled';
      }
    } catch (e) {
      _message = 'Failed to enable lunch notification';
    }
    notifyListeners();
  }

  getThemeValue() async {
    try {
      _message = '';
      _themeMode = await _service.getThemeMode();
    } catch (e) {
      _message = 'Failed to get theme value';
    }
    notifyListeners();
  }

  getLunchNotificationValue() async {
    try {
      _message = '';
      _lunchNotification = await _service.getLunchNotification();
    } catch (e) {
      _message = 'Failed to get lunch notification value';
    }
    notifyListeners();
  }
}
