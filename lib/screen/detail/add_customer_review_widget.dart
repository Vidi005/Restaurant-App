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
        return AlertDialog.adaptive(
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
                  border: const OutlineInputBorder(),
                  hintStyle: Theme.of(context).textTheme.bodyMedium,
                  labelStyle: Theme.of(context).textTheme.labelMedium,
                  prefixIcon: const Icon(Icons.person_pin_rounded),
                ),
                onChanged: (value) => context
                    .read<CustomerReviewsProvider>()
                    .onNameChanged(value),
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
                  border: const OutlineInputBorder(),
                  hintStyle: Theme.of(context).textTheme.bodyMedium,
                  labelStyle: Theme.of(context).textTheme.labelMedium,
                  prefixIcon: const Icon(Icons.comment_rounded),
                ),
                onChanged: (value) => context
                    .read<CustomerReviewsProvider>()
                    .onReviewChanged(value),
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
            ElevatedButton.icon(
              icon: const Icon(Icons.cancel_rounded),
              label: Text(
                'Cancel',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              onPressed: () {
                if (value.resultState is! CustomerReviewLoadingState) {
                  context.read<CustomerReviewsProvider>().onNameChanged('');
                  context.read<CustomerReviewsProvider>().onReviewChanged('');
                  Navigator.pop(context);
                }
              },
            ),
            ElevatedButton.icon(
              icon: value.resultState is CustomerReviewLoadingState
                  ? SizedBox(
                      height: 16,
                      width: 16,
                      child: const CircularProgressIndicator.adaptive(
                          strokeWidth: 2),
                    )
                  : const Icon(Icons.send_rounded),
              label: Text(
                'Submit',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              onPressed: () {
                if (value.resultState is! CustomerReviewLoadingState &&
                    context
                        .read<CustomerReviewsProvider>()
                        .inputName
                        .isNotEmpty &&
                    context
                        .read<CustomerReviewsProvider>()
                        .inputReview
                        .isNotEmpty) {
                  context
                      .read<CustomerReviewsProvider>()
                      .fetchCustomerReviews(restaurantId)
                      .then((_) {
                    if (value.resultState is CustomerReviewErrorState) {
                      final message =
                          (value.resultState as CustomerReviewErrorState).error;
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Error: $message'),
                          ),
                        );
                      }
                    } else {
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
