import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/data/api/api_services.dart';
import 'package:restaurant_app/data/local/local_database_service.dart';
import 'package:restaurant_app/data/local/local_notification_service.dart';
import 'package:restaurant_app/data/local/shared_preferences_service.dart';
import 'package:restaurant_app/provider/detail/customer_reviews_provider.dart';
import 'package:restaurant_app/provider/detail/restaurant_detail_provider.dart';
import 'package:restaurant_app/provider/favorite/local_database_provider.dart';
import 'package:restaurant_app/provider/home/restaurant_list_provider.dart';
import 'package:restaurant_app/provider/main/index_nav_provider.dart';
import 'package:restaurant_app/provider/setting/shared_preference_provider.dart';
import 'package:restaurant_app/screen/detail/detail_screen.dart';
import 'package:restaurant_app/screen/main/main_screen.dart';
import 'package:restaurant_app/static/navigation_route.dart';
import 'package:restaurant_app/static/theme_state.dart';
import 'package:restaurant_app/style/theme/restaurant_theme.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'provider/notification/local_notification_provider.dart';
import 'screen/favorite/favorite_screen.dart';
import 'screen/setting/setting_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  runApp(
    MultiProvider(
      providers: [
        Provider(
          create: (context) => LocalNotificationService()
            ..init()
            ..configureLocalTimeZone(),
        ),
        ChangeNotifierProvider(
          create: (context) => LocalNotificationProvider(
            context.read<LocalNotificationService>()..requestPermissions(),
          ),
        ),
        Provider(
          create: (context) => SharedPreferencesService(prefs),
        ),
        ChangeNotifierProvider(
          create: (context) => SharedPreferenceProvider(
              context.read<SharedPreferencesService>()),
        ),
        ChangeNotifierProvider(create: (context) => IndexNavProvider()),
        Provider(create: (context) => ApiServices()),
        ChangeNotifierProvider(
          create: (context) =>
              RestaurantListProvider(context.read<ApiServices>()),
        ),
        ChangeNotifierProvider(
          create: (context) =>
              RestaurantDetailProvider(context.read<ApiServices>()),
        ),
        ChangeNotifierProvider(
          create: (context) =>
              CustomerReviewsProvider(context.read<ApiServices>()),
        ),
        Provider(create: (context) => LocalDatabaseService()),
        ChangeNotifierProvider(
            create: (context) =>
                LocalDatabaseProvider(context.read<LocalDatabaseService>()))
      ],
      child: const MainApp(),
    ),
  );
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  late SharedPreferenceProvider sharedPreferenceProvider;
  late ThemeMode themeMode;

  _initializeLunchNotificationState(
      LocalNotificationProvider localNotifProvider,
      SharedPreferenceProvider sharedPrefProvider) {
    sharedPrefProvider.getLunchNotificationValue();
    final isLunchNotificationEnabled = sharedPrefProvider.lunchNotification;
    if (isLunchNotificationEnabled == null) {
      if (mounted && sharedPrefProvider.message.toString().isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(sharedPrefProvider.message),
            duration: const Duration(seconds: 3),
          ),
        );
      }
    } else if (isLunchNotificationEnabled &&
        localNotifProvider.pendingNotificationRequests.isEmpty) {
      localNotifProvider.scheduleDailyElevenAMNotification();
    }
  }

  _initializeThemeState(SharedPreferenceProvider provider) {
    final themeMode = provider.getThemeValue();
    if (themeMode == null) {
      if (mounted && provider.message.toString().isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(provider.message),
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  @override
  void initState() {
    super.initState();
    final localNotificationProvider = context.read<LocalNotificationProvider>();
    final sharedPreferenceProvider = context.read<SharedPreferenceProvider>();
    Future.microtask(() async {
      _initializeThemeState(sharedPreferenceProvider);
      await localNotificationProvider.requestPermissions().then((_) =>
          _initializeLunchNotificationState(
              localNotificationProvider, sharedPreferenceProvider));
    });
  }

  @override
  Widget build(BuildContext context) => Consumer<SharedPreferenceProvider>(
        builder: (context, value, child) {
          if (value.themeMode == ThemeState.light.name) {
            themeMode = ThemeMode.light;
          } else if (value.themeMode == ThemeState.dark.name) {
            themeMode = ThemeMode.dark;
          } else {
            themeMode = ThemeMode.system;
          }
          return MaterialApp(
            title: 'Restaurant App',
            theme: RestaurantTheme.lightTheme,
            darkTheme: RestaurantTheme.darkTheme,
            themeMode: themeMode,
            initialRoute: NavigationRoute.mainRoute.name,
            routes: {
              NavigationRoute.mainRoute.name: (context) => const MainScreen(),
              NavigationRoute.detailRoute.name: (context) => DetailScreen(
                    restaurantId:
                        ModalRoute.of(context)?.settings.arguments as String,
                  ),
              NavigationRoute.favoriteRoute.name: (context) =>
                  const FavoriteScreen(),
              NavigationRoute.settingsRoute.name: (context) =>
                  const SettingScreen(),
            },
          );
        },
      );
}
