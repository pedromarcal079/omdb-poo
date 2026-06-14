import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:miniprojeto/view/detail_page.dart';
import '../controllers/movie_controller.dart';

class SearchView extends StatelessWidget {
  const SearchView({super.key});

  @override
  Widget build(BuildContext context) {
    final MovieController controller = Get.find<MovieController>();
    final TextEditingController searchController = TextEditingController();

    void launchSearch() {
      FocusScope.of(context).unfocus();
      controller.changeGenre('Todos');
      controller.fetchMovies(searchController.text);
    }

    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: searchController,
                  decoration: InputDecoration(
                    hintText: 'Digite o nome do filme...',
                    prefixIcon: const Icon(Icons.movie_outlined),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        searchController.clear();
                        controller.fetchMovies('');
                      },
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onSubmitted: (_) => launchSearch(), 
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigo,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.all(16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: launchSearch,
                child: const Icon(Icons.search),
              ),
            ],
          ),
          const SizedBox(height: 16),

          SizedBox(
          height: 40,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: controller.genresList.length,
            itemBuilder: (context, index) {
              final genre = controller.genresList[index];
              return Obx(() {
                final isSelected = controller.selectedGenre.value == genre;
                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: FilterChip(
                    label: Text(genre),
                    selected: isSelected,
                    selectedColor: Colors.indigo,
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : Colors.black87,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                    onSelected: (bool selected) {
                      controller.changeGenre(genre);
                    },
                  ),
                );
              });
            },
          ),
        ),

          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              if (controller.filteredMovies.isEmpty) {
                return const Center(
                  child: Text('Nenhum filme corresponde ao filtro selecionado.'),
                );
              }

              return GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.7,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  ),
                itemCount: controller.filteredMovies.length,
                itemBuilder: (context, index) {
                  final movie = controller.filteredMovies[index];

                  return GestureDetector(
                    onTap: () {
                      Get.to(() => const DetailPage(), arguments: movie.imdbId);
                    },
                    child: Card(
                      clipBehavior: Clip.antiAlias,
                      elevation: 4,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12),
                      ),
                      child: Stack(
                        children: [
                          Positioned.fill(
                            child: Image.network(
                              movie.poster,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Positioned.fill(
                            child: Container(
                              decoration: const BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [Colors.transparent, Colors.black87],
                                ),
                              ),
                            )
                          ),
                          Positioned(
                            bottom: 8,
                            left: 8,
                            right: 8,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  movie.title,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      movie.year,
                                      style: const TextStyle(color: Colors.white70),
                                    ),
                                    Obx(() => IconButton(
                                      constraints: const BoxConstraints(),
                                      padding: EdgeInsets.zero,
                                      icon: Icon(
                                        controller.isFavorite(movie)
                                          ? Icons.favorite
                                          : Icons.favorite_border,
                                        color: Colors.red,
                                      ),
                                      onPressed: () => controller.toggleFavorite(movie),
                                    )),
                                  ],
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                },
              );
              }
            ),
          )
        ],
      ),
    );
  }
}