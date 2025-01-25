import 'package:flutter/widgets.dart';
import 'package:restaurant_app/data/api/api_services.dart';
import 'package:restaurant_app/static/customer_review_state.dart';

class CustomerReviewsProvider extends ChangeNotifier {
  final ApiServices _apiServices;

  CustomerReviewsProvider(this._apiServices);

  CustomerReviewResultState _resultState = CustomerReviewNoneState();

  get resultState => _resultState;

  var inputName = '';
  var inputReview = '';

  onNameChanged(value) {
    inputName = value;
    notifyListeners();
  }

  onReviewChanged(value) {
    inputReview = value;
    notifyListeners();
  }

  resetState() {
    _resultState = CustomerReviewNoneState();
    notifyListeners();
  }

  Future fetchCustomerReviews(id) async {
    try {
      if (inputName.isNotEmpty && inputReview.isNotEmpty) {
        _resultState = CustomerReviewLoadingState();
        notifyListeners();
        var result =
            await _apiServices.postCustomerReview(id, inputName, inputReview);
        if (result.error) {
          _resultState = CustomerReviewErrorState(result.message);
        } else {
          _resultState = CustomerReviewLoadedState(result.customerReviews);
          inputName = '';
          inputReview = '';
        }
        notifyListeners();
      }
    } catch (e) {
      _resultState = CustomerReviewErrorState('$e');
      notifyListeners();
    }
  }
}
