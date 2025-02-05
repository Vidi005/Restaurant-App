import 'package:flutter/widgets.dart';
import 'package:restaurant_app/data/model/restaurant_list.dart';
import '../../data/local/local_database_service.dart';

class LocalDatabaseProvider extends ChangeNotifier {
  final LocalDatabaseService _service;

  LocalDatabaseProvider(this._service);

  var _isLoading = true;
  get isLoading => _isLoading;

  var _message = '';
  get message => _message;

  List<RestaurantList>? _restaurantList;
  List<RestaurantList>? get restaurantList => _restaurantList;

  RestaurantList? _restaurant;
  get restaurant => _restaurant;

  Future saveRestaurant(value) async {
    try {
      final result = await _service.insertItem(value);
      if (result == 0) {
        _message = 'Failed to favorite restaurant';
      } else {
        _message = 'Restaurant has been favored';
      }
    } catch (e) {
      _message = 'Failed to favorite restaurant';
    }
    notifyListeners();
  }

  Future loadFavoredRestaurants() async {
    try {
      _isLoading = true;
      _message = '';
      notifyListeners();
      _restaurantList = await _service.getAllItems();
      _restaurant = null;
      _isLoading = false;
    } catch (e) {
      _isLoading = false;
      _message = 'Failed to load favored restaurants';
    }
    notifyListeners();
  }

  Future loadRestaurantById(id) async {
    try {
      _message = '';
      _restaurant = await _service.getItemById(id);
    } catch (e) {
      _message = 'Failed to load restaurant';
    }
    notifyListeners();
  }

  Future deleteRestaurantById(id) async {
    try {
      await _service.deleteItemById(id);
      _message = 'Restaurant has been unfavored';
    } catch (e) {
      _message = 'Failed to unfavored restaurant';
    }
    notifyListeners();
  }

  checkFavoredRestaurant(id) {
    final isSameFavoredRestaurant = _restaurant?.id == id;
    return isSameFavoredRestaurant;
  }
}
