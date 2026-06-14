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

  var selectedGenre = 'Todos'.obs;
  final List<String> genresList = ['Todos', 'Action', 'Comedy', 'Drama', 'Horror', 'Sci-Fi','Animation','Adventure', 'Musical', 'Sport'];

  Map<String, int> get genreStatistics {
    final Map<String, int> countMap = {};

    for (var movie in favoriteMovies) {
      for (var genre in movie.genres) {
        if (genre == 'Todos') continue; // Ignorar o gênero "Todos"
        countMap[genre] = (countMap[genre] ?? 0) + 1;
      }
    }

    final sortedEntries = countMap.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value)); // Ordenar por contagem decrescente
    return Map.fromEntries(sortedEntries);
  } 

  List<MovieModel> get filteredMovies {
    if (selectedGenre.value == 'Todos') {
      return movies;
    }
    return movies.where((movie) => movie.genres.contains(selectedGenre.value)).toList();
  }

  void fetchMovies(String query) async {
    if (query.trim().isEmpty) {
    movies.clear();
    return;
  }

    try {
      isLoading.value = true;
      final result = await _omdbService.searchMovies(query);
      movies.assignAll(result);

      _loadGenresForLoadedMovies();
    } finally {
      isLoading.value = false;
    }
  }

  void _loadGenresForLoadedMovies() async {
    final List<MovieModel> currentList = List.from(movies);

    for (var movie in currentList) {
      final detail = await _omdbService.fetchMovieDetail(movie.imdbId);

      if (detail != null && detail.genre != 'N/A') {
        List<String> realGenres = detail.genre.split(', ').toList();
        movie.genres.addAll(realGenres);
      }
    }

    movies.refresh();
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

  void changeGenre(String genre) {
    selectedGenre.value = genre;
  }
}