import 'dart:async';
import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart';
import 'package:restaurant_app/data/api/api_services.dart';
import 'package:restaurant_app/static/restaurant_list_result_state.dart';

class RestaurantListProvider with ChangeNotifier {
  final ApiServices _apiServices;

  RestaurantListProvider(this._apiServices);

  RestaurantListResultState _resultState = RestaurantListNoneState();

  get resultState => _resultState;

  Future fetchRestaurantList() async {
    try {
      _resultState = RestaurantListLoadingState();
      notifyListeners();
      final result = await _apiServices.getRestaurantList();
      if (result.error) {
        _resultState = RestaurantListErrorState(result.message);
      } else {
        _resultState = RestaurantListLoadedState(result.restaurants);
      }
      notifyListeners();
    } catch (e) {
      if (e is SocketException || e is ClientException) {
        _resultState = RestaurantListErrorState('No Internet Connection');
      } else if (e is TimeoutException) {
        _resultState = RestaurantListErrorState('Request Timeout');
      } else if (e is FormatException) {
        _resultState = RestaurantListErrorState('Data Format is Invalid');
      } else {
        _resultState =
            RestaurantListErrorState('An unexpected error occurred: $e');
      }
      notifyListeners();
    }
  }
}
