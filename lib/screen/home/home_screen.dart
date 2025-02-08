import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/provider/home/restaurant_list_provider.dart';
import 'package:restaurant_app/screen/home/restaurant_card_widget.dart';
import 'package:restaurant_app/static/navigation_route.dart';
import 'package:restaurant_app/static/restaurant_list_result_state.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (mounted) {
        context.read<RestaurantListProvider>().fetchRestaurantList();
      }
    });
  }

  @override
  Widget build(BuildContext parentContext) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Restaurant App'),
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
              'Recommendation restaurant for you!',
              style: Theme.of(parentContext).textTheme.bodyMedium,
              textAlign: TextAlign.justify,
            ),
          ),
          Expanded(
            child: Consumer<RestaurantListProvider>(
                builder: (context, value, child) {
              return switch (value.resultState) {
                RestaurantListLoadingState() => const Center(
                    child: CircularProgressIndicator.adaptive(),
                  ),
                RestaurantListErrorState(error: var message) => Builder(
                    builder: (context) {
                      SchedulerBinding.instance.addPostFrameCallback((_) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Error: $message')),
                        );
                      });
                      return const SizedBox();
                    },
                  ),
                RestaurantListLoadedState(data: var restaurants) =>
                  ListView.builder(
                    key: const ValueKey('restaurantListView'),
                    itemCount: restaurants.length,
                    itemBuilder: (context, index) {
                      final restaurant = restaurants[index];
                      return RestaurantCardWidget(
                        restaurant: restaurant,
                        onTap: () => Navigator.pushNamed(
                          context,
                          NavigationRoute.detailRoute.name,
                          arguments: restaurant.id,
                        ),
                      );
                    },
                  ),
                _ => const SizedBox(),
              };
            }),
          ),
        ],
      ),
    );
  }
}
