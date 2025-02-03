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
  late LocalNotificationProvider localNotificationProvider;
  late SharedPreferenceProvider sharedPreferenceProvider;
  late ThemeMode themeMode;

  _initializeLunchNotificationState() {
    localNotificationProvider.checkPendingNotificationsRequests();
    sharedPreferenceProvider.getLunchNotificationValue();
    if (sharedPreferenceProvider.lunchNotification == null) {
      if (mounted && sharedPreferenceProvider.message.toString().isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(sharedPreferenceProvider.message),
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  _initializeThemeState() {
    sharedPreferenceProvider.getThemeValue();
    if (sharedPreferenceProvider.themeMode == null) {
      if (mounted && sharedPreferenceProvider.message.toString().isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(sharedPreferenceProvider.message),
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  @override
  void initState() {
    super.initState();
    localNotificationProvider = context.read<LocalNotificationProvider>();
    sharedPreferenceProvider = context.read<SharedPreferenceProvider>();
    Future.microtask(() async {
      _initializeThemeState();
      await localNotificationProvider.requestPermissions().then((_) {
        if (localNotificationProvider.notificationPermission) {
          _initializeLunchNotificationState();
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<LocalNotificationProvider, SharedPreferenceProvider>(
      builder: (context, notificationValue, prefsValue, child) {
        final isNotificationRequestEmpty =
            context.select<LocalNotificationProvider, bool>(
                (value) => value.pendingNotificationRequests.isEmpty);
        final isNotificationEnabled =
            context.select<SharedPreferenceProvider, bool>(
                (value) => value.lunchNotification);
        if (isNotificationEnabled && isNotificationRequestEmpty) {
          notificationValue.scheduleDailyElevenAMNotification();
        }
        final themeModeName = context.select<SharedPreferenceProvider, String>(
            (value) => value.themeMode.toString());
        if (themeModeName == ThemeState.light.name) {
          themeMode = ThemeMode.light;
        } else if (themeModeName == ThemeState.dark.name) {
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
}
