import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:restaurant_app/data/api/api_services.dart';
import 'package:restaurant_app/data/model/customer_review.dart';
import 'package:restaurant_app/data/model/customer_review_response.dart';
import 'package:restaurant_app/provider/detail/customer_reviews_provider.dart';
import 'package:restaurant_app/static/customer_review_state.dart';

class MockApiServices extends Mock implements ApiServices {}

void main() {
  late ApiServices apiServices;
  late CustomerReviewsProvider customerReviewsProvider;
  const successErrorResponse = false;
  const successMessageResponse = 'success';
  const validRestaurantId = 'rqdv5juczeskfw1e867';
  const validInputName = 'Test Name';
  const validInputReview = 'Test Review';
  const invalidRestaurantId = 'xxxxx';
  const emptyErrorResponse = true;
  const emptyMessageResponse = 'restaurant tidak ditemukan';

  final successResponse = CustomerReviewResponse(
    error: successErrorResponse,
    message: successMessageResponse,
    customerReviews: [
      CustomerReview(
        name: 'Ahmad',
        review: 'Tidak rekomendasi untuk pelajar!',
        date: '13 November 2019',
      ),
    ],
  );
  final emptyResponse = CustomerReviewResponse(
    error: emptyErrorResponse,
    message: emptyMessageResponse,
    customerReviews: [],
  );

  setUp(() {
    apiServices = MockApiServices();
    customerReviewsProvider = CustomerReviewsProvider(apiServices);
  });

  group('post customer review provider unit test', () {
    test('should return CustomerReviewNoneState when provider initialize', () {
      final initState = customerReviewsProvider.resultState;
      expect(initState, isA<CustomerReviewNoneState>());
    });

    test('should return empty input name and review when provider initialize',
        () {
      final emptyInputName = customerReviewsProvider.inputName;
      final emptyInputReview = customerReviewsProvider.inputReview;
      expect(emptyInputName, '');
      expect(emptyInputReview, '');
    });

    test(
        'should return list of customer review when provider success post customer review',
        () async {
      customerReviewsProvider.onNameChanged(validInputName);
      customerReviewsProvider.onReviewChanged(validInputReview);
      when(() => apiServices.postCustomerReview(
            validRestaurantId,
            validInputName,
            validInputReview,
          )).thenAnswer((_) async => Future.value(successResponse));
      await customerReviewsProvider.fetchCustomerReviews(validRestaurantId);
      final resultState = customerReviewsProvider.resultState;
      expect(resultState, isA<CustomerReviewLoadedState>());
    });

    test(
        'should return CustomerReviewErrorState when provider post customer review with invalid id',
        () async {
      customerReviewsProvider.onNameChanged(validInputName);
      customerReviewsProvider.onReviewChanged(validInputReview);
      when(() => apiServices.postCustomerReview(
              invalidRestaurantId, validInputName, validInputReview))
          .thenAnswer((_) async => Future.value(emptyResponse));
      await customerReviewsProvider.fetchCustomerReviews(invalidRestaurantId);
      final resultState = customerReviewsProvider.resultState;
      expect(resultState, isA<CustomerReviewErrorState>());
    });
  });
}
