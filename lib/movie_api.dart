import 'package:http/http.dart' as http;
import 'dart:convert';
import 'movie.dart'; // Pastikan model Movie sudah ada

class MovieApi {
  static Future<List<Movie>> fetchMovies() async {
    // URL TMDB API untuk mengambil daftar film terbaru
    final url =
        'https://api.themoviedb.org/3/movie/now_playing?api_key=YOUR_API_KEY&page=1';

    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Authorization':
            'Bearer YOUR_BEARER_TOKEN', // Ganti dengan Bearer Token Anda
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body)['results'];
      return data.map((json) => Movie.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load movies');
    }
  }
}
