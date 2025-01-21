import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/provider/detail/restaurant_detail_provider.dart';
import 'package:restaurant_app/static/restaurant_detail_result_state.dart';
import 'package:restaurant_app/static/restaurant_image_resolution.dart';

class DetailScreen extends StatefulWidget {
  final String restaurantId;

  const DetailScreen({
    super.key,
    required this.restaurantId,
  });

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (mounted) {
        context
            .read<RestaurantDetailProvider>()
            .fetchRestaurantDetail(widget.restaurantId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            floating: false,
            pinned: true,
            backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
            expandedHeight: MediaQuery.of(context).size.height * 0.75,
            shadowColor: Theme.of(context).appBarTheme.shadowColor,
            leading: Padding(
              padding: const EdgeInsets.all(8),
              child: CircleAvatar(
                backgroundColor: Theme.of(context)
                    .appBarTheme
                    .foregroundColor
                    ?.withAlpha(128),
                child: IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Hero(
                tag: widget.restaurantId,
                child: Consumer<RestaurantDetailProvider>(
                    builder: (context, value, child) {
                  return switch (value.resultState) {
                    RestaurantDetailLoadingState() => const Center(
                        child: CircularProgressIndicator(),
                      ),
                    RestaurantDetailLoadedState(data: var restaurant) =>
                      CachedNetworkImage(
                        imageUrl: '${RestaurantImageResolution.large.url}'
                            '${restaurant.pictureId}',
                        placeholder: (context, url) => const Center(
                          child: CircularProgressIndicator(),
                        ),
                        fit: BoxFit.cover,
                        width: double.maxFinite,
                      ),
                    _ => Center(
                        child: Icon(
                          Icons.image_not_supported,
                          size: MediaQuery.of(context).size.width,
                        ),
                      ),
                  };
                }),
              ),
              title: Consumer<RestaurantDetailProvider>(
                builder: (context, value, child) {
                  return switch (value.resultState) {
                    RestaurantDetailLoadedState(data: var restaurant) => Text(
                        restaurant.name,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    _ => Text(
                        'Detail Restaurant',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                  };
                },
              ),
            ),
          ),
          SliverList.builder(
            itemCount: 1,
            itemBuilder: (context, index) {
              return Consumer<RestaurantDetailProvider>(
                builder: (context, value, child) {
                  return switch (value.resultState) {
                    RestaurantDetailLoadingState() => const Center(
                        child: CircularProgressIndicator(),
                      ),
                    RestaurantDetailLoadedState(data: var restaurant) =>
                      const Placeholder(),
                    RestaurantDetailErrorState(error: var message) => Center(
                        child: Text(message),
                      ),
                    _ => const SizedBox(),
                  };
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
