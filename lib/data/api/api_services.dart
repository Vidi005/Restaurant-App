import 'dart:convert';
import 'package:restaurant_app/data/model/customer_review_response.dart';
import 'package:restaurant_app/data/model/restaurant_detail_response.dart';
import 'package:restaurant_app/data/model/restaurant_list_response.dart';
import 'package:restaurant_app/data/model/restaurant_search_response.dart';
import 'package:http/http.dart' as http;

class ApiServices {
  var baseUrl = 'https://restaurant-api.dicoding.dev';

  Future<RestaurantListResponse> getRestaurantList() async {
    var response = await http.get(Uri.parse('$baseUrl/list'));
    if (response.statusCode == 200) {
      return RestaurantListResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load Restaurant List');
    }
  }

  Future<RestaurantSearchResponse> getRestaurantSearch(query) async {
    var response = await http.get(Uri.parse('$baseUrl/search?q=$query'));
    if (response.statusCode == 200) {
      return RestaurantSearchResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to search Restaurants');
    }
  }

  Future<RestaurantDetailResponse> getRestaurantDetail(id) async {
    var response = await http.get(Uri.parse('$baseUrl/detail/$id'));
    if (response.statusCode == 200) {
      return RestaurantDetailResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load Restaurant Detail');
    }
  }

  Future<CustomerReviewResponse> postCustomerReview(id, name, review) async {
    var encodedJsonData =
        'id=${Uri.encodeQueryComponent(id)}&name=${Uri.encodeQueryComponent(name)}&review=${Uri.encodeQueryComponent(review)}';
    var response = await http.post(
      Uri.parse('$baseUrl/review'),
      headers: <String, String>{
        'Content-Type': 'application/x-www-form-urlencoded'
      },
      body: encodedJsonData,
    );
    if (response.statusCode == 201) {
      return CustomerReviewResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to post Customer Review');
    }
  }
}
