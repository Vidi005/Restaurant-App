import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/provider/notification/local_notification_provider.dart';
import '../../provider/setting/shared_preference_provider.dart';

class NotificationSettingWidget extends StatelessWidget {
  const NotificationSettingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 8,
      children: [
        Text(
          'Notification Setting',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        Consumer2<LocalNotificationProvider, SharedPreferenceProvider>(
          builder: (context, localNotifProvider, sharedPrefProvider, child) {
            localNotifProvider
              ..requestPermissions()
              ..checkPendingNotificationsRequests();
            return SwitchListTile.adaptive(
              title: const Text('Lunch Reminder at 11:00 AM'),
              value: sharedPrefProvider.lunchNotification &&
                  localNotifProvider.pendingNotificationRequests.isNotEmpty,
              contentPadding: const EdgeInsets.symmetric(horizontal: 8),
              onChanged: (value) {
                sharedPrefProvider.saveLunchNotification(value).then((_) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(sharedPrefProvider.message)),
                    );
                  }
                });
                if (value) {
                  localNotifProvider.scheduleDailyElevenAMNotification();
                } else {
                  localNotifProvider.cancelAllNotifications();
                }
              },
            );
          },
        ),
      ],
    );
  }
}
