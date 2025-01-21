import 'package:flutter/widgets.dart';
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
      var result = await _apiServices.getRestaurantDetail(id);
      if (result.error) {
        _resultState = RestaurantDetailErrorState(result.message);
      } else {
        _resultState = RestaurantDetailLoadedState(result.restaurant);
      }
      notifyListeners();
    } catch (e) {
      _resultState = RestaurantDetailErrorState('$e');
      notifyListeners();
    }
  }
}
