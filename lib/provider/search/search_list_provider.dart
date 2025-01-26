import 'dart:async';
import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart';
import 'package:restaurant_app/data/api/api_services.dart';
import 'package:restaurant_app/static/restaurant_list_result_state.dart';

class SearchListProvider extends ChangeNotifier {
  final ApiServices _apiServices;

  SearchListProvider(this._apiServices);

  RestaurantListResultState _resultState = RestaurantListNoneState();

  get resultState => _resultState;

  Future fetchSearchRestaurant(query) async {
    try {
      if (query.toString().isEmpty) {
        _resultState = RestaurantListNoneState();
      } else {
        _resultState = RestaurantListLoadingState();
        notifyListeners();
        final result = await _apiServices.getRestaurantSearch(query);
        if (result.founded == 0) {
          _resultState = RestaurantListEmptyState();
        } else {
          _resultState = RestaurantListLoadedState(result.restaurants);
        }
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
