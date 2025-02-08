import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/provider/setting/shared_preference_provider.dart';
import 'package:restaurant_app/static/theme_state.dart';

class ThemeSettingWidget extends StatelessWidget {
  const ThemeSettingWidget({super.key});

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 8,
        children: [
          Text(
            'Theme Setting',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          ...ThemeState.values.map(
            (mode) => Consumer<SharedPreferenceProvider>(
              builder: (context, provider, child) => RadioListTile.adaptive(
                key: ValueKey(mode.name),
                title: Text(mode.name),
                value: mode.name,
                groupValue: provider.themeMode,
                contentPadding: const EdgeInsets.all(0),
                onChanged: (value) => provider.saveThemeMode(value).then((_) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(provider.message),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  }
                }),
              ),
            ),
          ),
        ],
      );
}
