import 'package:flutter/material.dart';
import '../detailscreen/movie_detail.dart';
import '../api/movie_api.dart';

class MovieScreen extends StatelessWidget {
  const MovieScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Now Showing'),
        backgroundColor: const Color(0xFF1E1E1E),
        automaticallyImplyLeading: false, // Remove the back button
      ),
      backgroundColor: const Color(0xFF1E1E1E),
      body: const MovieListScreen(),
    );
  }
}

class MovieListScreen extends StatefulWidget {
  const MovieListScreen({super.key});

  @override
  _MovieListScreenState createState() => _MovieListScreenState();
}

class _MovieListScreenState extends State<MovieListScreen> {
  int _currentPage = 1;
  late Future<List<dynamic>> movies;

  @override
  void initState() {
    super.initState();
    _fetchMovies();
  }

  void _fetchMovies() {
    setState(() {
      movies = MovieApi.fetchMovies(page: _currentPage, category: 'now_playing');
    });
  }

  void _loadPreviousPage() {
    if (_currentPage > 1) {
      setState(() {
        _currentPage--;
        _fetchMovies();
      });
    }
  }

  void _loadNextPage() {
    setState(() {
      _currentPage++;
      _fetchMovies();
    });
  }

  Future<void> _onRefresh() async {
    _fetchMovies();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        RefreshIndicator(
          onRefresh: _onRefresh,
          color: Colors.amber,
          child: FutureBuilder<List<dynamic>>(
            key: ValueKey<int>(_currentPage),
            future: movies,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.amber),
                  ),
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Text(
                    'Error: ${snapshot.error}',
                    style: const TextStyle(color: Colors.red),
                  ),
                );
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(
                  child: Text(
                    'No movies available',
                    style: TextStyle(color: Colors.white),
                  ),
                );
              } else {
                List<dynamic> movieList = snapshot.data!;
                return GridView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.7,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  itemCount: movieList.length,
                  itemBuilder: (context, index) {
                    var movie = movieList[index];
                    return GestureDetector(
                      onTap: () async {
                        final movieDetails = await MovieApi.fetchMovieDetails(movie['id']);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MovieDetailScreen(
                              title: movieDetails['title'],
                              synopsis: movieDetails['overview'],
                              posterUrl: 'https://image.tmdb.org/t/p/w500${movieDetails['poster_path']}',
                              releaseDate: movieDetails['release_date'],
                              voteAverage: movieDetails['vote_average']?.toDouble(),
                              runtime: movieDetails['runtime'],
                              genres: (movieDetails['genres'] as List)
                                  .map((genre) => genre['name'].toString())
                                  .toList(),
                            ),
                          ),
                        );
                      },
                      child: Hero(
                        tag: 'https://image.tmdb.org/t/p/w500${movie['poster_path']}',
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[900],
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.amber.withOpacity(0.2),
                                spreadRadius: 1,
                                blurRadius: 3,
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Expanded(
                                flex: 4,
                                child: ClipRRect(
                                  borderRadius: const BorderRadius.vertical(
                                    top: Radius.circular(12),
                                  ),
                                  child: Image.network(
                                    'https://image.tmdb.org/t/p/w500${movie['poster_path']}',
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Container(
                                        color: Colors.grey[800],
                                        child: const Icon(
                                          Icons.error,
                                          color: Colors.amber,
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8),
                                child: Text(
                                  movie['title'],
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              }
            },
          ),
        ),
        // Tombol pagination di tengah bawah
        Positioned(
          bottom: 16, // Jarak dari bawah
          left: 0,
          right: 0,
          child: Center(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey[900],
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.amber, width: 1),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                mainAxisSize: MainAxisSize.min, // Agar tidak memenuhi layar
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios, color: Colors.grey, size: 18),
                    onPressed: _loadPreviousPage,
                    splashRadius: 20,
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.amber,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      'Page $_currentPage',
                      style: TextStyle(
                        color: Colors.grey[900],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 18),
                    onPressed: _loadNextPage,
                    splashRadius: 20,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}