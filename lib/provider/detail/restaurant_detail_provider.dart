import 'dart:async';
import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart';
import 'package:restaurant_app/data/api/api_services.dart';
import 'package:restaurant_app/static/restaurant_detail_result_state.dart';

class RestaurantDetailProvider extends ChangeNotifier {
  final ApiServices _apiServices;

  RestaurantDetailProvider(this._apiServices);

  RestaurantDetailResultState _resultState = RestaurantDetailNoneState();

  get resultState => _resultState;

  Future fetchRestaurantDetail(id) async {
    try {
      _resultState = RestaurantDetailLoadingState();
      notifyListeners();
      final result = await _apiServices.getRestaurantDetail(id);
      if (result.error) {
        _resultState = RestaurantDetailErrorState(result.message);
      } else {
        _resultState = RestaurantDetailLoadedState(result.restaurant);
      }
      notifyListeners();
    } catch (e) {
      if (e is SocketException || e is ClientException) {
        _resultState = RestaurantDetailErrorState('No Internet Connection');
      } else if (e is TimeoutException) {
        _resultState = RestaurantDetailErrorState('Request Timeout');
      } else if (e is FormatException) {
        _resultState = RestaurantDetailErrorState('Data Format is Invalid');
      } else {
        _resultState =
            RestaurantDetailErrorState('An unexpected error occurred: $e');
      }
      notifyListeners();
    }
  }
}
