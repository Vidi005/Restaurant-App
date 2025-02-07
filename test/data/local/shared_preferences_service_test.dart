import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:restaurant_app/data/local/shared_preferences_service.dart';
import 'package:restaurant_app/static/theme_state.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  late MockSharedPreferences preference;
  late SharedPreferencesService sharedPreferencesService;
  final correctThemeModeValue = ThemeState.system.name;
  const correctLunchNotificationValue = true;
  const incorrectThemeModeValue = 0;
  const incorrectLunchNotificationValue = 'false';
  const thrownOfErrorThemeMode =
      "Shared Preferences can't save the theme mode.";
  const thrownOfErrorLunchNotification =
      "Shared Preferences can't save the lunch notification.";

  setUp(() {
    preference = MockSharedPreferences();
    sharedPreferencesService = SharedPreferencesService(preference);
  });

  group('shared preferences service unit test', () {
    test('should return none when the theme mode value is correct', () async {
      when(() => preference.setString(any(), any()))
          .thenAnswer((_) async => true);
      evalFunc() async =>
          await sharedPreferencesService.saveThemeMode(correctThemeModeValue);
      expect(evalFunc, returnsNormally);
    });

    test('should return $thrownOfErrorThemeMode when the theme mode value is incorrect', () async {
      when(() => preference.setString(any(), any()))
          .thenAnswer((_) async => true);
      evalFunc() async =>
          await sharedPreferencesService.saveThemeMode(incorrectThemeModeValue);
      expect(
        evalFunc,
        throwsA(isA<Exception>().having(
          (e) => e.toString(),
          'message',
          contains(thrownOfErrorThemeMode),
        )),
      );
    });

    test('should return none when the lunch notification value is correct',
        () async {
      when(() => preference.setBool(any(), any()))
          .thenAnswer((_) async => true);
      evalFunc() async => await sharedPreferencesService
          .saveLunchNotification(correctLunchNotificationValue);
      expect(evalFunc, returnsNormally);
    });

    test('should return $thrownOfErrorLunchNotification when the lunch notification value is incorrect',
        () {
      when(() => preference.setBool(any(), any()))
          .thenAnswer((_) async => true);
      evalFunc() async => await sharedPreferencesService
          .saveLunchNotification(incorrectLunchNotificationValue);
      expect(
        evalFunc,
        throwsA(isA<Exception>().having(
          (e) => e.toString(),
          'message',
          contains(thrownOfErrorLunchNotification),
        )),
      );
    });
  });
}
