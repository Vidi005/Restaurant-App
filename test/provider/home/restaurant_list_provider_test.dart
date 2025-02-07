import 'dart:async';
import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:restaurant_app/data/api/api_services.dart';
import 'package:restaurant_app/data/model/restaurant_list.dart';
import 'package:restaurant_app/data/model/restaurant_list_response.dart';
import 'package:restaurant_app/provider/home/restaurant_list_provider.dart';
import 'package:restaurant_app/static/restaurant_list_result_state.dart';

class MockApiServices extends Mock implements ApiServices {}

void main() {
  late ApiServices apiServices;
  late RestaurantListProvider restaurantListProvider;
  const successErrorResponse = false;
  const successMessageResponse = 'success';
  const validRestaurantId = 'rqdv5juczeskfw1e867';
  const validRestaurantName = 'Melting Pot';
  const validRestaurantDescription = 'description';
  const validRestaurantPictureId = '14';
  const validRestaurantCity = 'Medan';
  const validRestaurantRating = 4.2;

  final successResponse = RestaurantListResponse(
    error: successErrorResponse,
    message: successMessageResponse,
    count: 1,
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
  final nullResponse = null;

  setUp(() {
    apiServices = MockApiServices();
    restaurantListProvider = RestaurantListProvider(apiServices);
  });

  group('restaurant list provider unit test', () {
    test('should return none when provider initialize', () {
      final initState = restaurantListProvider.resultState;
      expect(initState, isA<RestaurantListNoneState>());
    });

    test(
        'should return RestaurantListLoadedState when provider success fetched data',
        () async {
      when(() => apiServices.getRestaurantList())
          .thenAnswer((_) async => Future.value(successResponse));
      await restaurantListProvider.fetchRestaurantList();
      final resultState = restaurantListProvider.resultState;
      expect(resultState, isA<RestaurantListLoadedState>());
    });

    test('should return list of restaurant when provider success fetched data',
        () async {
      when(() => apiServices.getRestaurantList())
          .thenAnswer((_) async => Future.value(successResponse));
      await restaurantListProvider.fetchRestaurantList();
      final resultState = restaurantListProvider.resultState;
      expect(resultState.data,
          equals(RestaurantListLoadedState(successResponse.restaurants).data));
    });

    test(
        'should return RestaurantListErrorState when provider failed to fetch data',
        () async {
      when(() => apiServices.getRestaurantList())
          .thenAnswer((_) async => Future.value(nullResponse));
      await restaurantListProvider.fetchRestaurantList();
      final resultState = restaurantListProvider.resultState;
      expect(resultState, isA<RestaurantListErrorState>());
    });

    test('should return "No Internet Connection" when Error "SocketException"',
        () async {
      when(() => apiServices.getRestaurantList())
          .thenThrow(SocketException('No Internet Connection'));
      await restaurantListProvider.fetchRestaurantList();
      final resultState = restaurantListProvider.resultState;
      expect(resultState.error,
          equals(RestaurantListErrorState('No Internet Connection').error));
    });

    test('should return "Request Timeout" when Error "TimeoutException"',
        () async {
      when(() => apiServices.getRestaurantList())
          .thenThrow(TimeoutException('Request Timeout'));
      await restaurantListProvider.fetchRestaurantList();
      final resultState = restaurantListProvider.resultState;
      expect(resultState.error,
          equals(RestaurantListErrorState('Request Timeout').error));
    });

    test('should return "Data Format is Invalid" when Error "FormatException"',
        () async {
      when(() => apiServices.getRestaurantList())
          .thenThrow(FormatException('Data Format is Invalid'));
      await restaurantListProvider.fetchRestaurantList();
      final resultState = restaurantListProvider.resultState;
      expect(resultState.error,
          equals(RestaurantListErrorState('Data Format is Invalid').error));
    });

    test(
        'should return "An unexpected error occurred: Exception: " when Error "FormatException"',
        () async {
      when(() => apiServices.getRestaurantList()).thenThrow(Exception(''));
      await restaurantListProvider.fetchRestaurantList();
      final resultState = restaurantListProvider.resultState;
      expect(
        resultState.error,
        equals(RestaurantListErrorState(
                'An unexpected error occurred: Exception: ')
            .error),
      );
    });
  });
}
