import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/movie_model.dart';

class ApiService {
  static const String baseUrl = 'https://tpm-api-responsi-a-h-872136705893.us-central1.run.app/api/v1/movies';

  static Future<List<FilmData>> getFilms() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonData = jsonDecode(response.body);
      final List<dynamic> filmList = jsonData['data']; // akses list film
      return filmList
          .map((e) => FilmData.fromJson(e))
          .toList(); // konversi ke List<FilmData>
    } else {
      throw Exception('Failed to load films');
    }
  }

  static Future<FilmData> getFilmById(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/$id'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonData = jsonDecode(response.body);
      return FilmData.fromJson(jsonData['data']);
    } else {
      throw Exception('Failed to load film');
    }
  }

  static Future<Map<String,dynamic>> post(FilmData filmdata) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(filmdata.toJson()),
    );
        return jsonDecode(response.body);
  }

  static Future<Map<String, dynamic>> updateFilm(FilmData updateFilm) async {
    final response = await http.patch(
      Uri.parse("$baseUrl/${updateFilm.id}"),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(updateFilm.toJson()), // <- fix di sini
    );
      return jsonDecode(response.body);
  }

  static Future<bool> deleteMovie(int id) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/movies/$id'),
    );

    return response.statusCode == 200;
  }


}