import 'package:flutter/material.dart';
import 'movie.dart';
import 'movie_api.dart';

class MovieListScreen extends StatefulWidget {
  const MovieListScreen({super.key});

  @override
  _MovieListScreenState createState() => _MovieListScreenState();
}

class _MovieListScreenState extends State<MovieListScreen> {
  late Future<List<Movie>> movies;

  @override
  void initState() {
    super.initState();
    _fetchMovies();
  }

  void _fetchMovies() {
    setState(() {
      movies = MovieApi.fetchMovies(page: 1, category: 'now_playing');
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Movie>>(
      future: movies,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No movies found.'));
        }

        final movieList = snapshot.data!;
        return ListView.builder(
          itemCount: movieList.length,
          itemBuilder: (context, index) {
            final movie = movieList[index];
            return ListTile(
              title: Text(movie.title),
              // Tambahkan detail lainnya sesuai kebutuhan
            );
          },
        );
      },
    );
  }
} 