import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:restaurant_app/data/model/customer_review_response.dart';
import 'package:restaurant_app/data/model/restaurant_detail_response.dart';
import 'package:restaurant_app/data/model/restaurant_list_response.dart';
import 'package:restaurant_app/data/model/restaurant_search_response.dart';
import 'package:http/http.dart' as http;

class ApiServices {
  final baseUrl = 'https://restaurant-api.dicoding.dev';

  Future<RestaurantListResponse> getRestaurantList() async {
    final response = await http
        .get(Uri.parse('$baseUrl/list'))
        .timeout(const Duration(seconds: 30));
    if (response.statusCode == 200) {
      return RestaurantListResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load Restaurant List');
    }
  }

  Future<RestaurantSearchResponse> getRestaurantSearch(query) async {
    final response = await http
        .get(Uri.parse('$baseUrl/search?q=$query'))
        .timeout(const Duration(seconds: 30));
    if (response.statusCode == 200) {
      return RestaurantSearchResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to search Restaurants');
    }
  }

  Future<RestaurantDetailResponse> getRestaurantDetail(id) async {
    final response = await http
        .get(Uri.parse('$baseUrl/detail/$id'))
        .timeout(const Duration(seconds: 30));
    if (response.statusCode == 200) {
      return RestaurantDetailResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load Restaurant Detail');
    }
  }

  Future<CustomerReviewResponse> postCustomerReview(id, name, review) async {
    final encodedJsonData =
        'id=${Uri.encodeQueryComponent(id)}&name=${Uri.encodeQueryComponent(name)}&review=${Uri.encodeQueryComponent(review)}';
    final response = await http
        .post(
          Uri.parse('$baseUrl/review'),
          headers: <String, String>{
            'Content-Type': 'application/x-www-form-urlencoded'
          },
          body: encodedJsonData,
        )
        .timeout(const Duration(seconds: 30));
    if (response.statusCode == 201) {
      return CustomerReviewResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to post Customer Review');
    }
  }

  Future getByteArrayFromUrl(url) async {
    final response =
        await http.get(Uri.parse(url)).timeout(const Duration(seconds: 30));
    return response.bodyBytes;
  }

  Future downloadAndSaveImageFile(url, fileName) async {
    try {
      final bytes = await getByteArrayFromUrl(url);
      final directory = await getApplicationDocumentsDirectory();
      final filePath = '${directory.path}/$fileName';
      final file = File(filePath);
      await file.writeAsBytes(bytes);
      return filePath;
    } catch (e) {
      return '';
    }
  }

  Future deleteImageFile(fileName) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final filePath = '${directory.path}/$fileName';
      final file = File(filePath);
      await file.exists() ? file.delete() : null;
    } catch (e) {
      throw Exception('Failed to delete image file');
    }
  }
}
