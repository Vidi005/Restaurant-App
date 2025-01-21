import 'package:restaurant_app/data/model/restaurant_list.dart';

class RestaurantListResponse {
  final bool error;
  final String message;
  final int count;
  final List<RestaurantList> restaurants;

  RestaurantListResponse({
    required this.error,
    required this.message,
    required this.count,
    required this.restaurants,
  });

  factory RestaurantListResponse.fromJson(Map<String, dynamic> json) {
    return RestaurantListResponse(
      error: json['error'],
      message: json['message'],
      count: json['count'],
      restaurants: json['restaurants'] != null
          ? List.from(json['restaurants'])
              .map((x) => RestaurantList.fromJson(x))
              .toList()
          : [],
    );
  }
}
