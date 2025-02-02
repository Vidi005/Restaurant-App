import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/provider/main/index_nav_provider.dart';
import 'package:restaurant_app/screen/favorite/favorite_screen.dart';
import 'package:restaurant_app/screen/home/home_screen.dart';
import 'package:restaurant_app/screen/search/search_screen.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<IndexNavProvider>(
        builder: (context, value, child) {
          if (value.indexBottomNavBar == 0) {
            return const HomeScreen();
          } else if (value.indexBottomNavBar == 1) {
            return const SearchScreen();
          } else {
            return const FavoriteScreen();
          }
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: context.watch<IndexNavProvider>().indexBottomNavBar,
        onTap: (index) =>
            context.read<IndexNavProvider>().setIndexBottomNavBar = index,
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.home),
            label: 'Recommendation',
            tooltip: 'Recommendation',
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.search_sharp),
            label: 'Search Restaurant',
            tooltip: 'Search Restaurant',
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.favorite),
            label: 'Favorite Restaurant',
            tooltip: 'Favored Restaurant',
          ),
        ],
      ),
    );
  }
}
