import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/data/api/api_services.dart';
import 'package:restaurant_app/data/model/restaurant_list.dart';
import 'package:restaurant_app/data/model/restaurant_search_response.dart';
import 'package:restaurant_app/provider/detail/customer_reviews_provider.dart';
import 'package:restaurant_app/provider/main/index_nav_provider.dart';
import 'package:restaurant_app/provider/search/search_list_provider.dart';
import 'package:restaurant_app/screen/search/search_screen.dart';
import 'package:restaurant_app/static/restaurant_list_result_state.dart';

class MockIndexNavProvider extends Mock implements IndexNavProvider {}

class MockApiServices extends Mock implements ApiServices {}

class MockSearchListProvider extends Mock implements SearchListProvider {}

class MockCustomerReviewsProvider extends Mock
    implements CustomerReviewsProvider {}

void main() {
  late IndexNavProvider indexNavProvider;
  late ApiServices apiServices;
  late SearchListProvider searchListProvider;
  late CustomerReviewsProvider customerReviewsProvider;
  late Widget widget;
  const successErrorResponse = false;
  const validRestaurantId = 'rqdv5juczeskfw1e867';
  const validRestaurantName = 'Melting Pot';
  const validRestaurantDescription = 'description';
  const validRestaurantPictureId = '14';
  const validRestaurantCity = 'Medan';
  const validRestaurantRating = 4.2;
  final successResponse = RestaurantSearchResponse(
    error: successErrorResponse,
    founded: 1,
    restaurants: [
      RestaurantList(
        id: validRestaurantId,
        name: validRestaurantName,
        description: validRestaurantDescription,
        pictureId: validRestaurantPictureId,
        city: validRestaurantCity,
        rating: validRestaurantRating,
      ),
    ],
  );
  final emptyResponse = RestaurantSearchResponse(
    error: successErrorResponse,
    founded: 0,
    restaurants: [],
  );

  setUp(() {
    indexNavProvider = MockIndexNavProvider();
    apiServices = MockApiServices();
    searchListProvider = MockSearchListProvider();
    customerReviewsProvider = MockCustomerReviewsProvider();
    widget = MaterialApp(
      home: MultiProvider(
        providers: [
          Provider<ApiServices>.value(value: apiServices),
          ChangeNotifierProvider<IndexNavProvider>.value(
              value: indexNavProvider),
          ChangeNotifierProvider<SearchListProvider>.value(
            value: searchListProvider,
          ),
          ChangeNotifierProvider<CustomerReviewsProvider>.value(
            value: customerReviewsProvider,
          ),
        ],
        child: const SearchScreen(),
      ),
    );
  });

  group('search screen widget test', () {
    testWidgets(
        'have every component, like AppBar, SearchBar, setting IconButton, and type search indicator when search screen first displayed',
        (tester) async {
      when(() => indexNavProvider.indexBottomNavBar).thenReturn(1);

      await tester.pumpWidget(widget);

      final appBarFinder = find.byType(AppBar);
      final iconButtonFinder = find.byType(IconButton);
      final settingIconFinder = find.descendant(
        of: iconButtonFinder,
        matching: find.byType(Icon),
      );
      final settingIcon = tester.widget<Icon>(settingIconFinder);
      final searchBarFinder = find.byType(SearchBar);
      final columnFinder = find.byKey(const Key('none state'));
      final manageSearchIconFinder = find.descendant(
        of: columnFinder,
        matching: find.byType(Icon),
      );
      final manageSearchIcon = tester.widget<Icon>(manageSearchIconFinder);
      final searchTextFinder = find.text('Type restaurant name to search');

      expect(appBarFinder, findsOneWidget);
      expect(settingIcon.icon, Icons.settings);
      expect(searchBarFinder, findsOneWidget);
      expect(manageSearchIcon.icon, Icons.manage_search_outlined);
      expect(searchTextFinder, findsOneWidget);
    });

    testWidgets('type text in search bar and show loading indicator',
        (tester) async {
      when(() => indexNavProvider.indexBottomNavBar).thenReturn(1);

      await tester.pumpWidget(widget);

      final searchBarFinder = find.byType(SearchBar);
      await tester.tap(searchBarFinder);

      when(() => apiServices.getRestaurantSearch(any()))
          .thenAnswer((_) async => successResponse);

      await tester.enterText(searchBarFinder, 'kafe');
      await tester.pump();

      when(() => searchListProvider.fetchSearchRestaurant(any()))
          .thenAnswer((_) async => Future.value());
      when(() => searchListProvider.resultState)
          .thenReturn(RestaurantListLoadingState());

      await tester.pumpWidget(widget);
      await tester.pump();

      final circularProgressIndicatorFinder =
          find.byType(CircularProgressIndicator);
      expect(circularProgressIndicatorFinder, findsOneWidget);
    });

    testWidgets('type text in search bar and show ListView', (tester) async {
      when(() => indexNavProvider.indexBottomNavBar).thenReturn(1);

      await tester.pumpWidget(widget);

      final searchBarFinder = find.byType(SearchBar);
      await tester.tap(searchBarFinder);

      when(() => apiServices.getRestaurantSearch(any()))
          .thenAnswer((_) async => successResponse);

      await tester.enterText(searchBarFinder, 'kafe');
      await tester.pump();

      when(() => searchListProvider.fetchSearchRestaurant(any()))
          .thenAnswer((_) async => Future.value());
      when(() => searchListProvider.resultState)
          .thenReturn(RestaurantListLoadedState(successResponse.restaurants));

      final listViewFinder = find.byType(ListView);
      expect(listViewFinder, findsOneWidget);
    });

    testWidgets('type text in search bar and show SnackBar error message',
        (tester) async {
      when(() => indexNavProvider.indexBottomNavBar).thenReturn(1);

      await tester.pumpWidget(widget);

      final searchBarFinder = find.byType(SearchBar);
      await tester.tap(searchBarFinder);

      when(() => apiServices.getRestaurantSearch(any()))
          .thenThrow(SocketException('No Internet Connection'));

      await tester.enterText(searchBarFinder, 'kafe');
      await tester.pump();

      when(() => searchListProvider.fetchSearchRestaurant(any()))
          .thenThrow(SocketException('No Internet Connection'));
      when(() => searchListProvider.resultState)
          .thenReturn(RestaurantListErrorState('No Internet Connection'));

      await tester.pumpAndSettle();

      final errorSnackbarFinder = find.byType(SnackBar);
      expect(errorSnackbarFinder, findsOneWidget);
    });

    testWidgets('type text in search bar and show empty indicator',
        (tester) async {
      when(() => indexNavProvider.indexBottomNavBar).thenReturn(1);

      await tester.pumpWidget(widget);

      final searchBarFinder = find.byType(SearchBar);
      await tester.tap(searchBarFinder);

      when(() => apiServices.getRestaurantSearch(any()))
          .thenAnswer((_) async => emptyResponse);

      await tester.enterText(searchBarFinder, 'xxxxx');
      await tester.pump();

      when(() => searchListProvider.fetchSearchRestaurant(any()))
          .thenAnswer((_) async => Future.value());
      when(() => searchListProvider.resultState)
          .thenReturn(RestaurantListEmptyState());

      await tester.pumpAndSettle();

      final columnFinder = find.byKey(const Key('empty state'));
      final emptyIconFinder = find.descendant(
        of: columnFinder,
        matching: find.byType(Icon),
      );
      final emptyIcon = tester.widget<Icon>(emptyIconFinder);
      final emptyTextFinder = find.text('No result found!');

      expect(emptyIcon.icon, Icons.playlist_remove);
      expect(emptyTextFinder, findsOneWidget);
    });
  });
}
