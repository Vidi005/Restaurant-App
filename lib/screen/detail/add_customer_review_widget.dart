import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/provider/detail/customer_reviews_provider.dart';
import 'package:restaurant_app/static/customer_review_state.dart';

class AddCustomerReviewWidget extends StatelessWidget {
  final String restaurantId;

  const AddCustomerReviewWidget({
    super.key,
    required this.restaurantId,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<CustomerReviewsProvider>(
      builder: (context, value, child) {
        return AlertDialog(
          title: Text(
            'Add Review',
            textAlign: TextAlign.center,
          ),
          titleTextStyle: Theme.of(context).textTheme.headlineSmall,
          scrollable: true,
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 8,
            children: [
              TextField(
                decoration: InputDecoration(
                  hintText: 'Enter your name here...',
                  labelText: 'Name',
                  hintStyle: Theme.of(context).textTheme.bodyMedium,
                  labelStyle: Theme.of(context).textTheme.labelMedium,
                  prefixIcon: const Icon(Icons.person_pin_rounded),
                ),
                onChanged: (value) =>
                    context.read<CustomerReviewsProvider>().inputName = value,
              ),
              Text(
                "* Name can't be empty",
                style: Theme.of(context)
                    .textTheme
                    .labelSmall
                    ?.copyWith(color: Colors.red),
              ),
              TextField(
                decoration: InputDecoration(
                  hintText: 'Enter your review here...',
                  labelText: 'Review',
                  hintStyle: Theme.of(context).textTheme.bodyMedium,
                  labelStyle: Theme.of(context).textTheme.labelMedium,
                  prefixIcon: const Icon(Icons.comment_rounded),
                ),
                onChanged: (value) =>
                    context.read<CustomerReviewsProvider>().inputReview = value,
              ),
              Text(
                "* Review can't be empty",
                style: Theme.of(context)
                    .textTheme
                    .labelSmall
                    ?.copyWith(color: Colors.red),
              ),
            ],
          ),
          actionsAlignment: MainAxisAlignment.spaceAround,
          alignment: Alignment.center,
          actions: [
            ElevatedButton(
              child: Text(
                'Cancel',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              onPressed: () {
                if (value.resultState is! CustomerReviewLoadingState) {
                  Navigator.pop(context);
                }
              },
            ),
            ElevatedButton.icon(
              icon: value.resultState is CustomerReviewLoadingState
                  ? const CircularProgressIndicator()
                  : const Icon(Icons.send_rounded),
              label: Text(
                'Submit',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              onPressed: () {
                if (value.resultState is! CustomerReviewEmptyState) {
                  context
                      .read<CustomerReviewsProvider>()
                      .fetchCustomerReviews(restaurantId)
                      .then((_) {
                    if (value.resultState is! CustomerReviewErrorState) {
                      if (context.mounted) {
                        Navigator.pop(context);
                      }
                    }
                  });
                }
              },
            ),
          ],
        );
      },
    );
  }
}
