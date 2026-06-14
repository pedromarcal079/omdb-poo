import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/movie_controller.dart';

class StatsPage extends StatelessWidget {
  const StatsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final MovieController movieController = Get.find<MovieController>();

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Obx(() {
        final stats = movieController.genreStatistics;

        if (stats.isEmpty){
          return const Center(
            child: Text(
              "Nenhum filme favorito adicionado ainda.",
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
          );
        }

        final totalGenresCount = stats.values.fold(0, (sum,item) => sum + item);
        final totalMoviesCount = movieController.favoriteMovies.length;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Seu perfil de cinema',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            Text(
              'Você tem $totalMoviesCount filmes favoritos em $totalGenresCount gêneros diferentes.',
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: stats.length,
                itemBuilder: (context,index){
                  final String genre = stats.keys.elementAt(index);
                  final int count = stats.values.elementAt(index);
                  final double percentage = totalMoviesCount > 0 ? (count / totalMoviesCount) * 100 : 0;

                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              genre,
                              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                            ),
                            Text(
                              '$count filme${count > 1 ? 's' : ''} (${percentage.toStringAsFixed(1)}%)',
                              style: const TextStyle(fontSize: 14, color: Colors.grey),
                            ),
                          ]
                        ),
                        const SizedBox(height: 4),
                        LinearProgressIndicator(
                          value: percentage,
                          backgroundColor: Colors.grey[300],
                          color: Colors.blueAccent,
                          minHeight: 8,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ]
                    )
                  );
                }),
            )
          ]
        );
      }),
    );
  }
}