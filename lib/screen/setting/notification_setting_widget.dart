import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../provider/setting/shared_preference_provider.dart';

class NotificationSettingWidget extends StatelessWidget {
  const NotificationSettingWidget({super.key});

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 8,
        children: [
          Text(
            'Notification Setting',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          Consumer<SharedPreferenceProvider>(
            builder: (context, provider, child) => SwitchListTile.adaptive(
              title: const Text('Lunch Reminder at 11:00 AM'),
              value: provider.lunchNotification,
              contentPadding: const EdgeInsets.symmetric(horizontal: 8),
              onChanged: (value) {
                provider.saveLunchNotification(value).then((_) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(provider.message)),
                    );
                  }
                });
              },
            ),
          ),
        ],
      );
}
