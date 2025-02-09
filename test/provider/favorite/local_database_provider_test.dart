import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:restaurant_app/data/local/local_database_service.dart';
import 'package:restaurant_app/data/model/restaurant_list.dart';
import 'package:restaurant_app/provider/favorite/local_database_provider.dart';

class MockLocalDatabaseService extends Mock implements LocalDatabaseService {}

void main() {
  late MockLocalDatabaseService localDatabaseService;
  late LocalDatabaseProvider localDatabaseProvider;
  const validRestaurantId = 'rqdv5juczeskfw1e867';
  const validRestaurantName = 'Melting Pot';
  const validRestaurantDescription = 'Dummy description';
  const validRestaurantPictureId = '14';
  const validRestaurantCity = 'Medan';
  const validRestaurantRating = 4.2;
  const nullRestaurantId = null;
  final validValue = RestaurantList(
    id: validRestaurantId,
    name: validRestaurantName,
    description: validRestaurantDescription,
    pictureId: validRestaurantPictureId,
    city: validRestaurantCity,
    rating: validRestaurantRating,
  );
  final nullValue = null;
  const successInsertMessage = 'Restaurant has been favored';
  const failedInsertMessage = 'Failed to favorite restaurant';
  const failedLoadRestaurantsMessage = 'Failed to load favored restaurants';
  const failedLoadRestaurantMessage = 'Failed to load restaurant';
  const successDeleteMessage = 'Restaurant has been unfavored';
  const failedDeleteMessage = 'Failed to unfavored restaurant';

  setUp(() {
    localDatabaseService = MockLocalDatabaseService();
    localDatabaseProvider = LocalDatabaseProvider(localDatabaseService);
  });

  group('local database provider unit test', () {
    test('should return null RestaurantList when provider initialize', () {
      final initState = localDatabaseProvider.restaurant;
      expect(initState, null);
    });

    test('should return success message when the inserted value is valid',
        () async {
      when(() => localDatabaseService.insertItem(validValue))
          .thenAnswer((_) => Future.value(1));
      await localDatabaseProvider.saveRestaurant(validValue);
      expect(localDatabaseProvider.message, equals(successInsertMessage));
    });

    test('should return failed message when the inserted value is null',
        () async {
      await localDatabaseProvider.saveRestaurant(nullValue);
      expect(localDatabaseProvider.message, equals(failedInsertMessage));
    });

    test('should return list of restaurant when favored restaurant is loaded',
        () async {
      when(() => localDatabaseService.getAllItems())
          .thenAnswer((_) => Future.value([validValue]));
      await localDatabaseProvider.loadFavoredRestaurants();
      expect(localDatabaseProvider.restaurantList, equals([validValue]));
    });

    test('should return failed message when favored restaurant is not loaded',
        () async {
      when(() => localDatabaseService.getAllItems())
          .thenAnswer((_) => Future.value([nullValue]));
      await localDatabaseProvider.loadFavoredRestaurants();
      expect(
          localDatabaseProvider.message, equals(failedLoadRestaurantsMessage));
    });

    test('should return a favored restaurant when the id is valid', () async {
      when(() => localDatabaseService.getItemById(validRestaurantId))
          .thenAnswer((_) => Future.value(validValue));
      await localDatabaseProvider.loadRestaurantById(validRestaurantId);
      expect(localDatabaseProvider.restaurant, equals(validValue));
    });

    test('should return failed message when the id is null', () async {
      when(() => localDatabaseService.getItemById(nullRestaurantId))
          .thenAnswer((_) => Future.value(0));
      await localDatabaseProvider.loadRestaurantById(nullRestaurantId);
      expect(
          localDatabaseProvider.message, equals(failedLoadRestaurantMessage));
    });

    test('should return success message when the id is valid', () async {
      when(() => localDatabaseService.deleteItemById(validRestaurantId))
          .thenAnswer((_) => Future.value(1));
      await localDatabaseProvider.deleteRestaurantById(validRestaurantId);
      expect(localDatabaseProvider.message, equals(successDeleteMessage));
    });
    
    test('should return failed message when the id is null', () async {
      when(() => localDatabaseService.deleteItemById(nullRestaurantId))
          .thenAnswer((_) => Future.value(0));
      await localDatabaseProvider.deleteRestaurantById(nullRestaurantId);
      expect(localDatabaseProvider.message, equals(failedDeleteMessage));
    });
  });
}
