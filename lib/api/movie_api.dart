import 'dart:convert';
import 'package:http/http.dart' as http;

class MovieApi {
  // Replace with your actual API key
  static const String apiKey = '40e32983b0bc5a9d24bce1ff7c45fa1a';
  static const String apiUrl = 'https://api.themoviedb.org/3/movie/';

  // Fetch movies based on 'page' and 'category' parameters
  static Future<List<Map<String, dynamic>>> fetchMovies({int page = 1, String category = 'now_playing'}) async {
    final url = Uri.parse('$apiUrl$category?api_key=$apiKey&page=$page&language=en-US');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = json.decode(response.body);
      final List<dynamic> jsonData = jsonResponse['results'];
      return jsonData.cast<Map<String, dynamic>>(); // Kembalikan data JSON mentah
    } else {
      throw Exception('Failed to load movies');
    }
  }

  // Fetch detailed information for a specific movie
  static Future<Map<String, dynamic>> fetchMovieDetails(int movieId) async {
    final url = Uri.parse('$apiUrl$movieId?api_key=$apiKey&language=en-US');
    print('Fetching movie details from: $url');

    try {
      final response = await http.get(url);

      print('Response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        return jsonResponse; // Return the raw JSON data
      } else {
        // Log the error
        print('Error fetching movie details: ${response.statusCode} - ${response.body}');
        throw Exception('Failed to load movie details: ${response.statusCode}');
      }
    } catch (e) {
      // Handle network or parsing errors
      print('Exception occurred: $e');
      throw Exception('Failed to load movie details: $e');
    }
  }
}