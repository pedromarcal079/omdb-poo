class MovieModel {
  final String _title;
  final String _year;
  final String _imdbId;
  final String _type;
  final String _poster;

  MovieModel({
    required String title,
    required String year,
    required String imdbId,
    required String type,
    required String poster,
  })  : _title = title,
        _year = year,
        _imdbId = imdbId,
        _type = type,
        _poster = poster;

  String get title => _title;
  String get year => _year;
  String get imdbId => _imdbId;
  String get type => _type;
  String get poster => _poster;

  factory MovieModel.fromJson(Map<String, dynamic> json) {
    return MovieModel(
      title: json['Title'] ?? 'Sem título', 
      year: json['Year'] ?? 'Ano desconhecido', 
      imdbId: json['imdbID'] ?? '', 
      type: json['Type'] ?? 'Desconhedido', 
      poster: json['Poster'] == 'N/A'
        ? 'https://upload.wikimedia.org/wikipedia/commons/thumb/6/65/No-Image-Placeholder.svg/1920px-No-Image-Placeholder.svg.png'
        : json['Poster'],
    );
  }

}