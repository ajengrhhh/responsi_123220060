import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/movie_model.dart';

class ApiService {
  static const String baseUrl = 'https://tpm-api-responsi-a-h-872136705893.us-central1.run.app/api/v1';

  static Future<List<Movie>> fetchMovies() async {
    final response = await http.get(Uri.parse('$baseUrl/movies'));
    final List jsonData = jsonDecode(response.body)['data'];
    return jsonData.map((json) => Movie.fromJson(json)).toList();
  }

  static Future<bool> addMovie(Movie movie) async {
    final response = await http.post(
      Uri.parse('$baseUrl/movies'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(movie.toJson()),
    );
    return response.statusCode == 201;
  }

  static Future<bool> updateMovie(int id, Movie movie) async {
    final response = await http.put(
      Uri.parse('$baseUrl/movies/$id'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(movie.toJson()),
    );
    return response.statusCode == 200;
  }

  static Future<bool> deleteMovie(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/movies/$id'));
    return response.statusCode == 200;
  }
}
