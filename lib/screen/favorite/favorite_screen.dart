import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/provider/favorite/local_database_provider.dart';
import 'package:restaurant_app/static/navigation_route.dart';
import '../home/restaurant_card_widget.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key});

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  @override
  void initState() {
    Future.microtask(() {
      if (mounted) {
        context.read<LocalDatabaseProvider>().loadFavoredRestaurants();
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favored Restaurants'),
        actions: [
          IconButton(
            onPressed: () => Navigator.pushNamed(
              context,
              NavigationRoute.settingsRoute.name,
            ),
            icon: const Icon(Icons.settings),
            padding: const EdgeInsets.all(16),
          )
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
            child: Text(
              'Your favorite restaurants',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
          Expanded(
            child: Consumer<LocalDatabaseProvider>(
              builder: (context, value, child) {
                if (value.isLoading) {
                  return const Center(
                    child: CircularProgressIndicator.adaptive(),
                  );
                } else {
                  final restaurants =
                      value.restaurantList?.reversed.toList() ?? [];
                  return restaurants.isNotEmpty
                      ? ListView.builder(
                          itemCount: restaurants.length,
                          itemBuilder: (context, index) => RestaurantCardWidget(
                            restaurant: restaurants[index],
                            onTap: () => Navigator.pushNamed(
                              context,
                              NavigationRoute.detailRoute.name,
                              arguments: restaurants[index].id,
                            ),
                          ),
                        )
                      : Column(
                          children: [
                            Expanded(
                              child: const Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.playlist_remove, size: 96),
                                    SizedBox(height: 8),
                                    Text('No favored restaurant'),
                                  ],
                                ),
                              ),
                            ),
                            Builder(builder: (context) {
                              if (value.message.toString().isNotEmpty) {
                                SchedulerBinding.instance
                                    .addPostFrameCallback((_) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(value.message),
                                      duration: const Duration(seconds: 3),
                                    ),
                                  );
                                });
                              }
                              return const SizedBox.shrink();
                            })
                          ],
                        );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
