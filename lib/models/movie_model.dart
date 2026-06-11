class MovieModel {
  final String _title;
  final String _year;
  final String _imdbId;
  final String _type;
  final String _poster;
  List<String> genres;

  MovieModel({
    required this._title,
    required this._year,
    required this._imdbId,
    required this._type,
    required this._poster,
    required this.genres,
  });

  String get title => _title;
  String get year => _year;
  String get imdbId => _imdbId;
  String get type => _type;
  String get poster => _poster;
  // List<String> get genres => genres;

  factory MovieModel.fromJson(Map<String, dynamic> json) {
    return MovieModel(
      title: json['Title'] ?? 'Sem título', 
      year: json['Year'] ?? 'Ano desconhecido', 
      imdbId: json['imdbID'] ?? '', 
      type: json['Type'] ?? 'Desconhedido', 
      poster: json['Poster'] == 'N/A'
        ? 'https://upload.wikimedia.org/wikipedia/commons/thumb/6/65/No-Image-Placeholder.svg/1920px-No-Image-Placeholder.svg.png'
        : json['Poster'],
      genres: ['Todos'],
    );
  }

}