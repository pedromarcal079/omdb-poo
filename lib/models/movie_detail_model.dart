class MovieDetailModel {
  final String title;
  final String year;
  final String genre;
  final String director;
  final String actors;
  final String plot;
  final String poster;
  final String imdbRating;

  MovieDetailModel({
    required this.title,
    required this.year,
    required this.genre,
    required this.director,
    required this.actors,
    required this.plot,
    required this.poster,
    required this.imdbRating,
  });

  factory MovieDetailModel.fromJson(Map<String, dynamic> json) {
    return MovieDetailModel(
      title: json['Title']?.toString() ?? 'Sem título',
      year: json['Year']?.toString() ?? 'N/A',
      genre: json['Genre']?.toString() ?? 'N/A',
      director: json['Director']?.toString() ?? 'N/A',
      actors: json['Actors']?.toString() ?? 'N/A',
      plot: json['Plot']?.toString() ?? 'Sem sinopse disponível.',
      imdbRating: json['imdbRating']?.toString() ?? 'N/A',
      poster: (json['Poster'] == null || json['Poster'] == 'N/A')
          ? 'https://via.placeholder.com/300x450.png?text=Sem+Imagem' 
          : json['Poster'].toString(),
    );
  }
}