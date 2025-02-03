import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:restaurant_app/data/local/local_notification_service.dart';

class LocalNotificationProvider extends ChangeNotifier {
  final LocalNotificationService localNotificationService;

  LocalNotificationProvider(this.localNotificationService);

  var _notificationId = 0;
  var _notificationPermission = false;
  get notificationPermission => _notificationPermission;

  var pendingNotificationRequests = <PendingNotificationRequest>[];

  Future requestPermissions() async {
    _notificationPermission =
        await localNotificationService.requestPermissions();
    notifyListeners();
  }

  scheduleDailyElevenAMNotification() {
    _notificationId = DateTime.now().millisecondsSinceEpoch.hashCode;
    localNotificationService.scheduleDailyElevenAMNotification(
      id: _notificationId,
      title: 'Daily Lunch Reminder',
      body: "It's time for lunch",
      payload: '11:00 AM',
    );
  }

  checkPendingNotificationsRequests() async {
    pendingNotificationRequests =
        await localNotificationService.pendingNotificationRequests();
    notifyListeners();
  }

  cancelAllNotifications() async =>
      await localNotificationService.cancelAllNotifications();
}
