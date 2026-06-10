import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/movie_controller.dart';
import 'detail_page.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final MovieController controller = Get.find<MovieController>();

    return Padding(
      padding: const EdgeInsetsGeometry.all(8.0),
      child: Obx(() {
        if (controller.favoriteMovies.isEmpty){
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.favorite_border, size: 64, color: Colors.grey),
                SizedBox(height: 16),
                Text(
                  'Ainda não foram favoritado nenhum filme',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                )
              ],
            ),
          );
        }
        return ListView.builder(
          itemCount: controller.favoriteMovies.length,
          itemBuilder: (context, index) {
            final movie = controller.favoriteMovies[index];

            return Card(
              elevation: 2,
              margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
              child: ListTile(
                contentPadding: const EdgeInsets.all(8),
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: Image.network(
                    movie.poster,
                    width: 50,
                    height: 75,
                    fit: BoxFit.cover,
                  ),
                ),
                title: Text(
                  movie.title,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text('${movie.year} • ${movie.type.capitalizeFirst}'),
                trailing: IconButton(
                  icon: const Icon(Icons.delete,color: Colors.red),
                  onPressed: () {
                    controller.toggleFavorite(movie);
                    Get.snackbar('Removido', '${movie.title} foi removido dos favoritos',
                    snackPosition: SnackPosition.BOTTOM,
                    duration: const Duration(seconds: 2)
                    );
                  },
                ),
                onTap: () {
                  Get.to(() => const DetailPage(), arguments: movie.imdbId);
                },
              ),
            );
          },
        );
      }
      ),
    );
  }
}