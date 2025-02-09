import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

class EvaluateRobot {
  final WidgetTester tester;

  EvaluateRobot(this.tester);

  final restaurantListViewKey = ValueKey('restaurantListView');
  final searchBarKey = ValueKey('searchBar');
  final favoredRestaurantsListViewKey = ValueKey('favoredRestaurantListView');
  final noFavoredRestaurantIndicatorKey =
      ValueKey('noFavoredRestaurantIndicator');
  final firstRestaurantNameItem = 'Melting Pot';
  final firstRestaurantCity = 'Medan';
  final firstRestaurantRating = 4.2;
  final emptyFavoredRestaurant = 'No favored restaurant';

  Future loadUI(widget) async {
    await tester.pumpAndSettle();
    await tester.pumpWidget(widget);
    await tester.pumpAndSettle();
  }

  Future scrollToBottom(valueKey) async {
    var reachedBottom = false;
    while (!reachedBottom) {
      final beforeScrollOffset = tester.getTopLeft(find.byKey(valueKey)).dy;
      await tester.drag(find.byKey(valueKey), const Offset(0, -1000));
      await tester.pumpAndSettle();
      final afterScrollOffset = tester.getTopLeft(find.byKey(valueKey)).dy;
      reachedBottom = beforeScrollOffset == afterScrollOffset;
    }
  }

  Future scrollToTop(valueKey) async {
    var reachedTop = false;
    while (!reachedTop) {
      final beforeScrollOffset = tester.getTopLeft(find.byKey(valueKey)).dy;
      await tester.drag(find.byKey(valueKey), const Offset(0, 1000));
      await tester.pumpAndSettle();
      final afterScrollOffset = tester.getTopLeft(find.byKey(valueKey)).dy;
      reachedTop = beforeScrollOffset == afterScrollOffset;
    }
  }

  Future tapItem(valueKey) async {
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(valueKey).first);
    await tester.pumpAndSettle();
  }

  Future tapButton(valueKey) async {
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(valueKey));
    await tester.pumpAndSettle();
  }

  Future tapBackButton() async {
    await tester.pumpAndSettle();
    await tester.tap(find.backButton());
    await tester.pumpAndSettle();
  }

  Future checkFirstRestaurantListItem(name, city, rating) async {
    await tester.pumpAndSettle();
    final restaurantListFinder = find.byKey(restaurantListViewKey);
    final firstItemFinder = find
        .descendant(
          of: restaurantListFinder,
          matching: find.byType(Card),
        )
        .first;
    final restaurantNameFinder = find
        .descendant(
          of: firstItemFinder,
          matching: find.byType(Text),
        )
        .at(0);
    final restaurantName = tester.widget<Text>(restaurantNameFinder);
    final restaurantCityFinder = find
        .descendant(
          of: firstItemFinder,
          matching: find.byType(Text),
        )
        .at(1);
    final restaurantCity = tester.widget<Text>(restaurantCityFinder);
    final restaurantRatingFinder = find
        .descendant(
          of: firstItemFinder,
          matching: find.byType(Text),
        )
        .at(2);
    final restaurantRating = tester.widget<Text>(restaurantRatingFinder);
    expect(restaurantName.data, equals(name));
    expect(restaurantCity.data, equals(city));
    expect(restaurantRating.data, equals(rating.toString()));
    await tester.pumpAndSettle();
  }

  Future typeSearchRestaurant(query) async {
    final searchBarFinder = find.byKey(searchBarKey);
    await tester.tap(searchBarFinder);
    await tester.enterText(searchBarFinder, query);
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pumpAndSettle();
  }

  Future checkFavoredRestaurantList() async {
    await tester.pumpAndSettle();
    final favoredRestaurantListFinder =
        find.byKey(favoredRestaurantsListViewKey);
    final favoredRestaurantList =
        tester.widget<ListView>(favoredRestaurantListFinder);
    expect(favoredRestaurantList, isA<ListView>());
    await tester.pumpAndSettle();
  }

  Future checkEmptyFavoredRestaurant() async {
    await tester.pumpAndSettle();
    final columnFinder = find.byKey(noFavoredRestaurantIndicatorKey);
    final emptyIconFinder = find.descendant(
      of: columnFinder,
      matching: find.byType(Icon),
    );
    final emptyIcon = tester.widget<Icon>(emptyIconFinder);
    final emptyTextFinder = find.descendant(
      of: columnFinder,
      matching: find.byType(Text),
    );
    final emptyText = tester.widget<Text>(emptyTextFinder);
    expect(emptyIcon.icon, Icons.playlist_remove);
    expect(emptyText.data, equals(emptyFavoredRestaurant));
    await tester.pumpAndSettle();
  }

  Future checkThemeSetting(mode) async {
    await tester.pumpAndSettle();
    final themeModeFinder = find.byType(SnackBar);
    final themeTextFinder = find.descendant(
      of: themeModeFinder,
      matching: find.byType(Text),
    );
    final themeMode = tester.widget<Text>(themeTextFinder);
    expect(
      themeMode.data,
      equals('Theme mode has been changed to $mode theme'),
    );
    await tester.pumpAndSettle(const Duration(seconds: 3));
  }

  Future checkNotificationSetting(isEnabled) async {
    await tester.pumpAndSettle();
    final notificationFinder = find.byType(SnackBar);
    final notificationTextFinder = find.descendant(
      of: notificationFinder,
      matching: find.byType(Text),
    );
    final notification = tester.widget<Text>(notificationTextFinder);
    expect(
      notification.data,
      equals(
        'Lunch notification reminder has been ${isEnabled ? 'enabled' : 'disabled'}',
      ),
    );
    await tester.pumpAndSettle(const Duration(seconds: 3));
  }
}
