import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:restaurant_app/restaurant_app.dart';
import 'package:restaurant_app/static/navigation_route.dart';
import 'package:restaurant_app/static/theme_state.dart';
import 'robot/evaluate_robot.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('integrate all feature', (tester) async {
    final evaluateRobot = EvaluateRobot(tester);

    // Load UI
    await evaluateRobot.loadUI(
      RestaurantApp(initialRoute: NavigationRoute.mainRoute.name),
    );

    // Check the first Restaurant List item and scroll to bottom
    await evaluateRobot.checkFirstRestaurantListItem(
        'Melting Pot', 'Medan', 4.2);
    await evaluateRobot.scrollToBottom(ValueKey('restaurantListView'));

    // Scroll to top
    await evaluateRobot.scrollToTop(ValueKey('restaurantListView'));

    // Tap Search Button and search restaurant
    await evaluateRobot.tapItem(ValueKey('Search Restaurant'));
    await evaluateRobot.tapButton(ValueKey('searchBar'));
    await evaluateRobot.typeSearchRestaurant('melting');

    // Tap first Search Restaurant item and click Favorite Button
    await evaluateRobot.tapItem(ValueKey('rqdv5juczeskfw1e867'));
    await evaluateRobot.tapButton(ValueKey('favoriteButton'));
    await evaluateRobot.tapButton(Key('backButton'));

    // Tap Favored Button and check favored restaurant list
    await evaluateRobot.tapItem(ValueKey('Favorite Restaurant'));
    await evaluateRobot.checkFavoredRestaurantList();

    // Tap first Favored Restaurant item and click Unfavorite Button
    await evaluateRobot.tapItem(ValueKey('rqdv5juczeskfw1e867'));
    await evaluateRobot.tapButton(ValueKey('favoriteButton'));
    await evaluateRobot.tapButton(Key('backButton'));

    // Check empty favored restaurant list
    await evaluateRobot.checkEmptyFavoredRestaurant();

    // Check theme setting
    await evaluateRobot.tapButton(ValueKey('settingButton'));
    await evaluateRobot.tapItem(ValueKey(ThemeState.dark.name));
    await evaluateRobot.checkThemeSetting(ThemeState.dark.name);

    // Check notification setting
    await evaluateRobot.tapItem(ValueKey('notificationSwitch'));
    await evaluateRobot.checkNotificationSetting(true);
    await evaluateRobot.tapItem(ValueKey('notificationSwitch'));
    await evaluateRobot.checkNotificationSetting(false);
    await evaluateRobot.tapBackButton();
  });
}
