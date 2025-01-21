import 'package:flutter/widgets.dart';
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
        var result = await _apiServices.getRestaurantSearch(query);
        if (result.founded == 0) {
          _resultState = RestaurantListEmptyState();
        } else {
          _resultState = RestaurantListLoadedState(result.restaurants);
        }
      }
      notifyListeners();
    } catch (e) {
      _resultState = RestaurantListErrorState('$e');
      notifyListeners();
    }
  }
}
