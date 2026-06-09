import 'dart:convert';
import 'package:get/get_connect.dart';
import 'package:http/http.dart' as http;
import '../models/movie_model.dart';
import '../models/movie_detail_model.dart';

class OmdbService {
  final String _baseUrl = 'http://www.omdbapi.com/';
  final String _apiKey = ''; // minha chave api

  // pesquisa lista de filmes por texto
  Future<List<MovieModel>> searchMovies(String query) async {
    if (query.trim().isEmpty) return [];

    final uri = Uri.parse('$_baseUrl?s=${Uri.encodeComponent(query)}&apikey=$_apiKey');

    try {
      final response = await http.get(uri);

      if (response.statusCode == 200) { // 200 = OK
        final Map<String,dynamic> data =jsonDecode(response.body);

        if (data['Response'] == 'True') {
          final List<dynamic> searchResults = data['Search'];

          return searchResults.map((json) => MovieModel.fromJson(json)).toList();
        }
      }
      return [];
    } catch (e) {
      // ignore: avoid_print
      print("ERRO AO BUSCAR FILMES: $e");
      return [];
    }
  }

  Future<MovieDetailModel?> fetchMovieDetail(String imdbId) async {
    final uri = Uri.parse('$_baseUrl?i=$imdbId&plot=full&apikey=$_apiKey');

    try {
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        if (data['Response'] == 'True') {
          return MovieDetailModel.fromJson(data);
        }
      }
      return null;
    } catch (e) {
      // ignore: avoid_print
      print("Erro ao buscar detalhes do filme: $e");
      return null;
    }
  }
}