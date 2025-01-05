class Movie {
  final String id;
  final String title;
  final String synopsis;
  final String posterUrl;
  final String trailerUrl;

  // Constructor
  Movie({
    required this.id,
    required this.title,
    required this.synopsis,
    required this.posterUrl,
    required this.trailerUrl,
  });

  // Fungsi untuk mapping dari JSON ke objek Movie
  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      id: json['id']?.toString() ?? '', // ID film
      title: json['title'] ?? 'No Title', // Judul film
      synopsis: json['overview'] ?? 'No Synopsis', // Sinopsis film
      posterUrl: json['poster_path'] != null
          ? 'https://image.tmdb.org/t/p/w500${json['poster_path']}' // URL poster TMDB
          : '',
      trailerUrl: json['trailer_url'] ?? '', // URL trailer (opsional)
    );
  }

  // Fungsi untuk mapping dari objek Movie ke JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'overview': synopsis,
      'poster_path': posterUrl,
      'trailer_url': trailerUrl,
    };
  }
}
