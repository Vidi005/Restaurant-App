import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/provider/home/restaurant_list_provider.dart';
import 'package:restaurant_app/provider/main/index_nav_provider.dart';
import 'package:restaurant_app/screen/main/main_screen.dart';

class MockRestaurantListProvider extends Mock
    implements RestaurantListProvider {}

class MockIndexNavProvider extends Mock implements IndexNavProvider {}

void main() {
  late RestaurantListProvider restaurantListProvider;
  late IndexNavProvider indexNavProvider;
  late Widget widget;

  setUp(() {
    restaurantListProvider = MockRestaurantListProvider();
    indexNavProvider = MockIndexNavProvider();
    widget = MaterialApp(
      home: MultiProvider(
        providers: [
          ChangeNotifierProvider<RestaurantListProvider>.value(
            value: restaurantListProvider,
          ),
          ChangeNotifierProvider<IndexNavProvider>.value(
              value: indexNavProvider),
        ],
        child: const MainScreen(),
      ),
    );
  });

  group('main screen widget test', () {
    testWidgets(
        'have bottom navigation bar items like recommendation, search, and favorite of restaurant',
        (tester) async {
      when(() => restaurantListProvider.fetchRestaurantList())
          .thenAnswer((_) async => Future.value());
      when(() => indexNavProvider.indexBottomNavBar).thenReturn(0);

      await tester.pumpWidget(widget);
      await tester.pumpAndSettle();

      final bottomNavigationBar = find.byType(BottomNavigationBar);
      expect(bottomNavigationBar, findsOneWidget);

      final firstBottomNavigationBarItemFinder = find.text('Recommendation');
      final secondBottomNavigationBarItemFinder =
          find.text('Search Restaurant');
      final thirdBottomNavigationBarItemFinder =
          find.text('Favorite Restaurant');
      expect(firstBottomNavigationBarItemFinder, findsOneWidget);
      expect(secondBottomNavigationBarItemFinder, findsOneWidget);
      expect(thirdBottomNavigationBarItemFinder, findsOneWidget);
    });
  });
}
