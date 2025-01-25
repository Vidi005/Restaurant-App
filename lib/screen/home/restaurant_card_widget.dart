import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/data/model/restaurant_list.dart';
import 'package:restaurant_app/provider/detail/customer_reviews_provider.dart';
import 'package:restaurant_app/static/restaurant_image_resolution.dart';

class RestaurantCardWidget extends StatelessWidget {
  final RestaurantList restaurant;
  final Function() onTap;

  const RestaurantCardWidget({
    super.key,
    required this.restaurant,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shadowColor: Theme.of(context).appBarTheme.shadowColor,
      margin: EdgeInsets.all(8),
      elevation: 4,
      child: Consumer<CustomerReviewsProvider>(
        builder: (context, value, child) {
          return InkWell(
            onTap: () {
              context.read<CustomerReviewsProvider>().resetState();
              onTap();
            },
            child: Row(
              children: [
                ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxHeight: 100,
                    minHeight: 100,
                    maxWidth: 120,
                    minWidth: 120,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Hero(
                      tag: restaurant.id,
                      child: CachedNetworkImage(
                        imageUrl: '${RestaurantImageResolution.small.url}'
                            '${restaurant.pictureId}',
                        placeholder: (context, url) => const Center(
                          child: CircularProgressIndicator(),
                        ),
                        fadeInDuration: Duration(milliseconds: 500),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.max,
                      spacing: 4,
                      children: [
                        Text(
                          restaurant.name,
                          style: Theme.of(context).textTheme.titleMedium,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          spacing: 4,
                          children: [
                            const Icon(Icons.location_pin),
                            Expanded(
                              child: Text(
                                restaurant.city,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          spacing: 4,
                          children: [
                            const Icon(Icons.star),
                            Text(
                              '${restaurant.rating}',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
