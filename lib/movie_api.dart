import 'dart:convert';
import 'package:http/http.dart' as http;
import 'movie.dart';

class MovieApi {
  // Replace with your actual API key
  static const String apiKey = '40e32983b0bc5a9d24bce1ff7c45fa1a';
  static const String apiUrl = 'https://api.themoviedb.org/3/movie/';

  // Fetch movies based on 'page' and 'category' parameters
  static Future<List<Movie>> fetchMovies({int page = 1, String category = 'now_playing'}) async {
    final url = Uri.parse('$apiUrl$category?api_key=$apiKey&page=$page');
    final response = await http.get(url);

    print('Fetching movies from: $url');
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonResponse = json.decode(response.body);
      List<dynamic> jsonData = jsonResponse['results']; // 'results' contains the list of movies
      return jsonData.map((movie) => Movie.fromJson(movie)).toList();
    } else {
      // Log the error
      print('Error fetching movies: ${response.statusCode} - ${response.body}');
      throw Exception('Failed to load movies');
    }
  }
}
