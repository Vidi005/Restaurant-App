import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/data/model/restaurant_detail.dart';
import 'package:restaurant_app/data/model/restaurant_list.dart';
import '../../provider/detail/favorite_icon_provider.dart';
import '../../provider/favorite/local_database_provider.dart';

class FavoriteIconWidget extends StatefulWidget {
  final RestaurantDetail restaurant;

  const FavoriteIconWidget({
    super.key,
    required this.restaurant,
  });

  @override
  State<FavoriteIconWidget> createState() => _FavoriteIconWidgetState();
}

class _FavoriteIconWidgetState extends State<FavoriteIconWidget> {
  late LocalDatabaseProvider localDatabaseProvider;
  late FavoriteIconProvider favoriteIconProvider;

  @override
  void initState() {
    localDatabaseProvider = context.read<LocalDatabaseProvider>();
    favoriteIconProvider = context.read<FavoriteIconProvider>();
    Future.microtask(() async {
      await localDatabaseProvider.loadRestaurantById(widget.restaurant.id);
      final value =
          localDatabaseProvider.checkFavoredRestaurant(widget.restaurant.id);
      favoriteIconProvider.isFavored = value;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final restaurantData = RestaurantList(
      id: widget.restaurant.id,
      name: widget.restaurant.name,
      description: widget.restaurant.description,
      pictureId: widget.restaurant.pictureId,
      city: widget.restaurant.city,
      rating: widget.restaurant.rating,
    );
    return IconButton.filled(
      color: Theme.of(context).colorScheme.onPrimary,
      onPressed: () async {
        localDatabaseProvider = context.read<LocalDatabaseProvider>();
        favoriteIconProvider = context.read<FavoriteIconProvider>();
        final isFavored = favoriteIconProvider.isFavored;
        isFavored
            ? await localDatabaseProvider
                .deleteRestaurantById(widget.restaurant.id)
            : await localDatabaseProvider.saveRestaurant(restaurantData);
        favoriteIconProvider.isFavored = !isFavored;
        localDatabaseProvider.loadFavoredRestaurants();
      },
      icon: Icon(
        context.watch<FavoriteIconProvider>().isFavored
            ? Icons.favorite_rounded
            : Icons.favorite_outline_rounded,
      ),
    );
  }
}
