import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/movie_controller.dart';
import 'search_view.dart';
import 'favorites_page.dart';
import 'stats_page.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final MovieController controller = Get.put(MovieController());

    final List<Widget> screens = [
      const SearchView(),
      const FavoritesPage(),
      const StatsPage(),
    ];

    return Obx(() => Scaffold(
      appBar: AppBar(
        title: Text(controller.currentTabIndex.value == 0
          ? 'Catalogo OMDb'
          : controller.currentTabIndex.value == 1 
          ? 'Favoritos'
          : 'Estatísticas'),
        centerTitle: true,
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),

      body: screens[controller.currentTabIndex.value],

      bottomNavigationBar: NavigationBar(
        selectedIndex: controller.currentTabIndex.value,
        onDestinationSelected:(index) => controller.changeTab(index),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.movie_filter_outlined),
            selectedIcon: Icon(Icons.movie_filter),
            label: 'Filmes',
          ),
          NavigationDestination(
            icon: Icon(Icons.favorite_border),
            selectedIcon: Icon(Icons.favorite),
            label: 'Favoritos'
          ),
          NavigationDestination(
            icon: Icon(Icons.bar_chart_outlined), 
            selectedIcon: Icon(Icons.bar_chart),
            label: 'Stats',
          ),
        ],
      ),
    ),
    );
  }
}