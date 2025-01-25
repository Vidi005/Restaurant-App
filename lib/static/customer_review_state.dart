import 'package:restaurant_app/data/model/customer_review.dart';

sealed class CustomerReviewResultState {}

class CustomerReviewNoneState extends CustomerReviewResultState {}

class CustomerReviewLoadingState extends CustomerReviewResultState {}

class CustomerReviewErrorState extends CustomerReviewResultState {
  final String? error;
  CustomerReviewErrorState(this.error);
}

class CustomerReviewLoadedState extends CustomerReviewResultState {
  final List<CustomerReview> data;
  CustomerReviewLoadedState(this.data);
}
