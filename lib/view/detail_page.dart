import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/movie_controller.dart';

class DetailPage extends StatelessWidget {
  const DetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    final MovieController controller = Get.find<MovieController>();

    final String imdbId = Get.arguments;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.fetchMovieDetails(imdbId);
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalhes'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: Obx(() {
        if (controller.isLoadingDetail.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final movie = controller.currentMovieDetail.value;

        if (movie == null) {
          return const Center(child: Text('Não foi possivel carregar os detalhes'));
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.network(
                    movie.poster,
                    height: 350,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      movie.title,
                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold) 
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: Colors.amber,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.star, size: 18, color: Colors.black),
                        const SizedBox(width: 4),
                        Text(
                          movie.imdbRating,
                          style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                        ),
                      ],
                    ),
                  )
                ],
              ),
              const SizedBox(height: 8),

              Text(
                '${movie.year} - ${movie.genre}',
                style: TextStyle(color: Colors.grey[600], fontSize: 16),
              ),
              const Divider(height: 30),

              const Text(
                'Sinopse',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                movie.plot,
                style: const TextStyle(fontSize: 16, height: 1.4),
              ),
              const Divider(height: 30),

              _buildInfoRow('Diretor: ', movie.director),
              const SizedBox(height: 8),
              _buildInfoRow('Elenco: ', movie.actors),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return RichText(
      text: TextSpan(
        style: const TextStyle(fontSize: 16, color: Colors.black87),
        children: [
          TextSpan(text: '$label ', style: const TextStyle(fontWeight: FontWeight.bold)),
          TextSpan(text: value)
        ]
      ),
    );
  }
}