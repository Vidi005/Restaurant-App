import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:readmore/readmore.dart';
import 'package:restaurant_app/data/model/restaurant_detail.dart';
import 'package:restaurant_app/provider/detail/customer_reviews_provider.dart';
import 'package:restaurant_app/screen/detail/add_customer_review_widget.dart';
import 'package:restaurant_app/screen/detail/customer_reviews_widget.dart';
import 'package:restaurant_app/static/customer_review_state.dart';

class DetailContentWidget extends StatelessWidget {
  final RestaurantDetail restaurant;

  const DetailContentWidget({
    super.key,
    required this.restaurant,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        spacing: 4,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            spacing: 4,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 4,
                  children: [
                    Text(
                      restaurant.name,
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 4,
                      children: [
                        const Icon(Icons.location_pin),
                        Expanded(
                          child: Text(
                            '${restaurant.address}, ${restaurant.city}',
                            softWrap: true,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                spacing: 6,
                children: [
                  const Icon(Icons.star, size: 36),
                  Text(
                    '${restaurant.rating}',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 4),
          Wrap(
            direction: Axis.horizontal,
            spacing: 12,
            runSpacing: 8,
            children: restaurant.categories.isNotEmpty
                ? restaurant.categories.map(
                    (category) {
                      return Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Theme.of(context).colorScheme.primary,
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(8),
                          color: Theme.of(context)
                              .colorScheme
                              .primary
                              .withAlpha(64),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        child: Text(
                          category.name,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      );
                    },
                  ).toList()
                : const [SizedBox()],
          ),
          Divider(color: Theme.of(context).colorScheme.primary),
          Text(
            'Description',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          ReadMoreText(
            restaurant.description,
            trimMode: TrimMode.Line,
            trimLines: 5,
            trimCollapsedText: 'Show More',
            trimExpandedText: '\nShow Less',
            colorClickableText: Theme.of(context).colorScheme.primary,
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.justify,
          ),
          Divider(color: Theme.of(context).colorScheme.primary),
          Text(
            'Menus',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          Text(
            'Foods',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          SizedBox(
            height: 35,
            child: ListView.builder(
              itemCount: restaurant.menu.foods.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                final food = restaurant.menu.foods[index];
                return Card(
                  color: Theme.of(context).colorScheme.primary.withAlpha(64),
                  shadowColor: Theme.of(context).appBarTheme.shadowColor,
                  margin: EdgeInsets.symmetric(horizontal: 4),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                  elevation: 4,
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      child: Text(
                        food.name,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Text(
            'Beverages',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          SizedBox(
            height: 35,
            child: ListView.builder(
              itemCount: restaurant.menu.drinks.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                final drink = restaurant.menu.drinks[index];
                return Card(
                  color: Theme.of(context).colorScheme.primary.withAlpha(64),
                  shadowColor: Theme.of(context).appBarTheme.shadowColor,
                  margin: EdgeInsets.symmetric(horizontal: 4),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                  elevation: 4,
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      child: Text(
                        drink.name,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Divider(color: Theme.of(context).colorScheme.primary),
          Text(
            'Customers Review',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          Center(
            child: ElevatedButton.icon(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AddCustomerReviewWidget(
                    restaurantId: restaurant.id,
                  ),
                );
              },
              icon: const Icon(Icons.add_circle),
              label: Text(
                'Add Your Review',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
          ),
          Consumer<CustomerReviewsProvider>(
            builder: (context, value, child) {
              return switch (value.resultState) {
                CustomerReviewLoadedState(data: var customerReviews) =>
                  CustomerReviewsWidget(
                    customerReviews: customerReviews,
                  ),
                _ => CustomerReviewsWidget(
                    customerReviews: restaurant.customerReviews,
                  ),
              };
            },
          ),
        ],
      ),
    );
  }
}
