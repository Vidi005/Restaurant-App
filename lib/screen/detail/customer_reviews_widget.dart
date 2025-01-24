import 'package:flutter/material.dart';
import 'package:restaurant_app/data/model/customer_review.dart';

class CustomerReviewsWidget extends StatelessWidget {
  final List<CustomerReview> customerReviews;

  const CustomerReviewsWidget({
    super.key,
    required this.customerReviews,
  });

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: customerReviews.isNotEmpty
            ? customerReviews.reversed.map((review) {
                return ListTile(
                  leading: Icon(Icons.person_pin, size: 48),
                  title: Text(
                    review.name,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        review.review,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      Text(
                        review.date,
                        style: Theme.of(context)
                            .textTheme
                            .labelMedium
                            ?.copyWith(fontStyle: FontStyle.italic),
                      )
                    ],
                  ),
                );
              }).toList()
            : const [SizedBox()],
      );
}
