import 'dart:convert';
import 'package:http/http.dart' as http;

class NewsApi {
  final String baseUrl = 'https://api-berita-indonesia.vercel.app';

  /// Fetch news from a specific source and category
  /// [source] can be antara, cnbc, cnn, jpnn, etc.
  /// [category] depends on the source, like terbaru, politik, ekonomi, etc.
  Future<List<dynamic>> fetchNews(String source, String category) async {
    final url = Uri.parse('$baseUrl/$source/$category');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['data']['posts']; // Adjust based on the actual API response structure
      } else {
        throw Exception(
            'Failed to load news: ${response.statusCode} ${response.reasonPhrase}');
      }
    } catch (e) {
      throw Exception('Error fetching news: $e');
    }
  }
}
