import 'package:flutter/material.dart';
import 'package:restaurant_app/restaurant_app.dart';
import 'data/local/local_notification_service.dart';
import 'static/navigation_route.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final notificationAppLaunchDetail =
      await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();
  var route = NavigationRoute.mainRoute.name;
  String? payload;
  if (notificationAppLaunchDetail?.didNotificationLaunchApp ?? false) {
    payload = notificationAppLaunchDetail?.notificationResponse?.payload;
    route = NavigationRoute.detailRoute.name;
  }
  runApp(RestaurantApp(
    initialRoute: route,
    payload: payload,
  ));
}
