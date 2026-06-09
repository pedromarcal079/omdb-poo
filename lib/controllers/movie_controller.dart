import 'package:get/get.dart';
import '../models/movie_model.dart';
import '../data/omdb_service.dart';
import '../models/movie_detail_model.dart';

class MovieController extends GetxController {
  final OmdbService _omdbService = OmdbService();

  var movies = <MovieModel>[].obs;
  var isLoading = false.obs;
  var favoriteMovies = <MovieModel>[].obs;

  var currentMovieDetail = Rxn<MovieDetailModel>();
  var isLoadingDetail = false.obs;

  void fetchMovies(String query) async {
    try {
      isLoading.value = true;
      final result = await _omdbService.searchMovies(query);
      movies.assignAll(result);
    } finally {
      isLoading.value = false;
    }
  }

  void toggleFavorite(MovieModel movie) {
    if (isFavorite(movie)) {
      favoriteMovies.removeWhere((m) => m.imdbId == movie.imdbId);
    } else {
      favoriteMovies.add(movie);
    }
  }

  void fetchMovieDetails(String imdbId) async {
    try {
      isLoadingDetail.value = true;
      currentMovieDetail.value = null;

      final result = await _omdbService.fetchMovieDetail(imdbId);
      currentMovieDetail.value = result;
    } finally {
      isLoadingDetail.value = false;
    }
  }

  bool isFavorite(MovieModel movie) {
    return favoriteMovies.any((m) => m.imdbId == movie.imdbId);
  }

  var currentTabIndex = 0.obs; // Controla o índice da barra inferior (0 = Busca, 1 = Favoritos)
  void changeTab(int index) {
    currentTabIndex.value = index;
  }
}