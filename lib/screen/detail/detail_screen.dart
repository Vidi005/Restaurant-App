import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/provider/detail/favorite_icon_provider.dart';
import 'package:restaurant_app/provider/detail/restaurant_detail_provider.dart';
import 'package:restaurant_app/screen/detail/detail_content_widget.dart';
import 'package:restaurant_app/screen/detail/favorite_icon_widget.dart';
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
            expandedHeight: MediaQuery.of(context).size.width,
            shadowColor: Theme.of(context).appBarTheme.shadowColor,
            leading: Padding(
              padding: const EdgeInsets.all(8),
              child: CircleAvatar(
                backgroundColor:
                    Theme.of(context).colorScheme.onPrimary.withAlpha(128),
                child: IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ),
            flexibleSpace: LayoutBuilder(
              builder: (context, constraints) {
                final expandedHeight = constraints.biggest.height;
                final isCollapsed = expandedHeight <= kToolbarHeight;
                return Stack(
                  children: [
                    FlexibleSpaceBar(
                      background: Hero(
                        tag: widget.restaurantId,
                        child: Consumer<RestaurantDetailProvider>(
                            builder: (context, value, child) {
                          return switch (value.resultState) {
                            RestaurantDetailLoadingState() => const Center(
                                child: CircularProgressIndicator.adaptive(),
                              ),
                            RestaurantDetailLoadedState(data: var restaurant) =>
                              CachedNetworkImage(
                                imageUrl:
                                    '${RestaurantImageResolution.large.url}'
                                    '${restaurant.pictureId}',
                                placeholder: (context, url) => const Center(
                                  child: CircularProgressIndicator.adaptive(),
                                ),
                                fit: BoxFit.cover,
                                alignment: Alignment.center,
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
                      expandedTitleScale: 1.25,
                      title: Consumer<RestaurantDetailProvider>(
                        builder: (context, value, child) {
                          return switch (value.resultState) {
                            RestaurantDetailLoadedState(data: var restaurant) =>
                              Text(
                                restaurant.name,
                                style: Theme.of(context).textTheme.titleLarge,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            _ => Text(
                                'Detail Restaurant',
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                          };
                        },
                      ),
                    ),
                    ChangeNotifierProvider(
                      create: (context) => FavoriteIconProvider(),
                      child: Consumer<RestaurantDetailProvider>(
                        builder: (context, value, child) {
                          return switch (value.resultState) {
                            RestaurantDetailLoadedState(data: var restaurant) =>
                              Positioned(
                                top: isCollapsed ? 8 : null,
                                bottom: isCollapsed ? null : 8,
                                right: 8,
                                child:
                                    FavoriteIconWidget(restaurant: restaurant),
                              ),
                            _ => const SizedBox(),
                          };
                        },
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          SliverList.builder(
            itemCount: 1,
            itemBuilder: (context, index) {
              return Consumer<RestaurantDetailProvider>(
                builder: (context, value, child) {
                  return switch (value.resultState) {
                    RestaurantDetailLoadingState() => const Center(
                        child: CircularProgressIndicator.adaptive(),
                      ),
                    RestaurantDetailLoadedState(data: var restaurant) =>
                      DetailContentWidget(restaurant: restaurant),
                    RestaurantDetailErrorState(error: var message) =>
                      Builder(builder: (context) {
                        SchedulerBinding.instance.addPostFrameCallback((_) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Error: $message'),
                              duration: const Duration(seconds: 3),
                            ),
                          );
                        });
                        return const SizedBox();
                      }),
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
