import 'dart:async';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:restaurant_app/data/api/api_services.dart';
import 'package:restaurant_app/data/model/restaurant_list.dart';
import 'package:restaurant_app/static/restaurant_image_resolution.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import '../model/received_notification.dart';

final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

final didReceiveLocalNotificationStream =
    StreamController<ReceivedNotification>.broadcast();

final selectNotificationStream = StreamController<String?>.broadcast();

class LocalNotificationService {
  final ApiServices _apiServices;

  LocalNotificationService(this._apiServices);

  Future init() async {
    final initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon');
    final initializationSettingsIOS = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );
    final initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );
    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (notificationResponse) {
        final payload = notificationResponse.payload;
        if (payload != null && payload.isNotEmpty) {
          selectNotificationStream.add(payload);
        }
      },
    );
  }

  Future _isAndroidPermissionGranted() async =>
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.areNotificationsEnabled() ??
      false;

  Future _requestExactAlarmsPermission() async =>
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.requestExactAlarmsPermission() ??
      false;

  Future requestPermissions() async {
    if (defaultTargetPlatform == TargetPlatform.iOS) {
      final iOSImplementation =
          flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin>();
      return await iOSImplementation?.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );
    } else if (defaultTargetPlatform == TargetPlatform.android) {
      final androidImplementation =
          flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>();
      final requestNotificationsPermission =
          await androidImplementation?.requestNotificationsPermission();
      final notificationEnabled = await _isAndroidPermissionGranted();
      final requestAlarmEnabled = await _requestExactAlarmsPermission();
      return (requestNotificationsPermission ?? false) &&
          notificationEnabled &&
          requestAlarmEnabled;
    } else {
      return false;
    }
  }

  Future configureLocalTimeZone() async {
    tz.initializeTimeZones();
    final timeZoneName = await FlutterTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(timeZoneName));
  }

  _nextInstanceOfElevenAM() {
    final now = tz.TZDateTime.now(tz.local);
    var scheduledDate =
        tz.TZDateTime(tz.local, now.year, now.month, now.day, 11);
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    return scheduledDate;
  }

  Future<RestaurantList> _getRandomRestaurantItem() async {
    try {
      final response = await _apiServices.getRestaurantList();
      return response
          .restaurants[Random().nextInt(response.restaurants.length)];
    } catch (e) {
      return RestaurantList(
        id: '',
        name: 'It\'s time for lunch',
        description: '',
        pictureId: '',
        city: '',
        rating: 0.0,
      );
    }
  }

  Future scheduleDailyElevenAMNotification({
    required int id,
    required String title,
    required String body,
    required String payload,
    final channelId = '1',
    final channelName = 'Daily Lunch Reminder',
  }) async {
    final randomRestaurantItem = await _getRandomRestaurantItem();
    final smallImagePath = await _apiServices.downloadAndSaveImageFile(
      '${RestaurantImageResolution.small.url}${randomRestaurantItem.pictureId}',
      'smallIcon',
    );
    final mediumImagePath = await _apiServices.downloadAndSaveImageFile(
      '${RestaurantImageResolution.medium.url}${randomRestaurantItem.pictureId}',
      'mediumPicture.jpg',
    );

    final bigPictureStyleInformation = BigPictureStyleInformation(
      FilePathAndroidBitmap(mediumImagePath),
      largeIcon: FilePathAndroidBitmap(smallImagePath),
      contentTitle: '<b>Recommended Restaurant for You!</b>',
      htmlFormatContentTitle: true,
      summaryText: '${randomRestaurantItem.name}, ${randomRestaurantItem.city}',
      htmlFormatSummaryText: true,
    );

    final androidPlatformChannelSpecifics = AndroidNotificationDetails(
      channelId,
      channelName,
      importance: Importance.max,
      priority: Priority.high,
      styleInformation: bigPictureStyleInformation,
      playSound: true,
      ticker: 'ticker',
    );

    final iOSPlatformChannelSpecifics = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
      attachments: [
        DarwinNotificationAttachment(
          mediumImagePath,
          hideThumbnail: false,
        )
      ],
    );

    final notificationDetails = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
    );

    await flutterLocalNotificationsPlugin.zonedSchedule(
      id,
      randomRestaurantItem.id.isNotEmpty
          ? 'Recommended Restaurant for You!'
          : title,
      randomRestaurantItem.id.isNotEmpty
          ? '${randomRestaurantItem.name}, ${randomRestaurantItem.city}'
          : body,
      _nextInstanceOfElevenAM(),
      notificationDetails,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.wallClockTime,
      payload: randomRestaurantItem.id,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  Future pendingNotificationRequests() async {
    final pendingNotificationRequests =
        await flutterLocalNotificationsPlugin.pendingNotificationRequests();
    return pendingNotificationRequests;
  }

  Future cancelAllNotifications() async {
    _apiServices
      ..deleteImageFile('smallIcon')
      ..deleteImageFile('mediumPicture.jpg');
    await flutterLocalNotificationsPlugin.cancelAll();
  }
}
