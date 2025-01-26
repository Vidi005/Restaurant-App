import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/data/api/api_services.dart';
import 'package:restaurant_app/provider/search/search_list_provider.dart';
import 'package:restaurant_app/screen/home/restaurant_card_widget.dart';
import 'package:restaurant_app/screen/search/search_bar_widget.dart';
import 'package:restaurant_app/static/navigation_route.dart';
import 'package:restaurant_app/static/restaurant_list_result_state.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Restaurant'),
      ),
      body: ChangeNotifierProvider(
        create: (context) => SearchListProvider(context.read<ApiServices>()),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            Padding(
              padding: const EdgeInsets.all(8),
              child: SearchBarWidget(),
            ),
            Expanded(
              child: Consumer<SearchListProvider>(
                  builder: (context, value, child) {
                return switch (value.resultState) {
                  RestaurantListNoneState() => Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.manage_search_outlined, size: 96),
                          const SizedBox(height: 8),
                          const Text('Type restaurant name to search'),
                        ],
                      ),
                    ),
                  RestaurantListLoadingState() => const Center(
                      child: CircularProgressIndicator.adaptive(),
                    ),
                  RestaurantListErrorState(error: var message) => Builder(
                      builder: (context) {
                        SchedulerBinding.instance.addPostFrameCallback((_) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Error: $message'),
                              duration: const Duration(seconds: 3),
                            ),
                          );
                        });
                        return const SizedBox();
                      },
                    ),
                  RestaurantListLoadedState(data: var restaurants) =>
                    ListView.builder(
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
                  RestaurantListEmptyState() => Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.playlist_remove, size: 96),
                          const SizedBox(height: 8),
                          const Text('No results found!'),
                        ],
                      ),
                    ),
                  _ => const SizedBox(),
                };
              }),
            ),
          ],
        ),
      ),
    );
  }
}
