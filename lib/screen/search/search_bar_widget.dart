import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/provider/search/search_list_provider.dart';

class SearchBarWidget extends StatelessWidget {
  const SearchBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final searchListProvider = context.read<SearchListProvider>();
    return SearchBar(
      hintText: 'Search Restaurant',
      leading: const Icon(Icons.search),
      shadowColor: WidgetStatePropertyAll(
        Theme.of(context).appBarTheme.shadowColor,
      ),
      textStyle: WidgetStatePropertyAll(Theme.of(context).textTheme.bodyMedium),
      hintStyle: WidgetStatePropertyAll(Theme.of(context).textTheme.bodyMedium),
      shape: WidgetStatePropertyAll(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      onChanged: (value) => searchListProvider.fetchSearchRestaurant(value),
      onSubmitted: (value) => searchListProvider.fetchSearchRestaurant(value),
    );
  }
}
