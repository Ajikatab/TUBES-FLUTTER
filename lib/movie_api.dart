import 'package:http/http.dart' as http;
import 'dart:convert';
import 'movie.dart'; // Pastikan model Movie sudah ada

class MovieApi {
  static Future<List<Movie>> fetchMovies() async {
    // URL TMDB API untuk mengambil daftar film terbaru
    const url =
        'https://api.themoviedb.org/3/movie/now_playing?api_key=40e32983b0bc5a9d24bce1ff7c45fa1a&page=2';

    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Authorization':
            'Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI0MGUzMjk4M2IwYmM1YTlkMjRiY2UxZmY3YzQ1ZmExYSIsIm5iZiI6MTY4NDk5NTEwMS4xODcsInN1YiI6IjY0NmVmYzFkZTIyZDI4MTZiMDk0NWIxNCIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.l8UN7wbrGd5IMcIZbFvBqG3QjYf5k0Gk46nb_q35374', // Ganti dengan Bearer Token Anda
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
