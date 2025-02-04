import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:restaurant_app/data/api/api_services.dart';
import 'package:restaurant_app/provider/home/restaurant_list_provider.dart';
import 'package:restaurant_app/static/restaurant_list_result_state.dart';

class MockApiServices extends Mock implements ApiServices {}

void main() {
  late ApiServices apiServices;
  late RestaurantListProvider restaurantListProvider;

  setUp(() {
    apiServices = MockApiServices();
    restaurantListProvider = RestaurantListProvider(apiServices);
  });

  group('restaurant list provider unit test', () {
    test('should return none when provider initialize', () {
      final initState = restaurantListProvider.resultState;
      expect(initState, isA<RestaurantListNoneState>());
    });
  });
}
