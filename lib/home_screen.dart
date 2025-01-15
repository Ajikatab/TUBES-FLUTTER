import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'movie_detail_screen.dart';
import 'movie_api.dart';
import 'maps_screen.dart'; // Import MapsScreen
import 'news_screen.dart'; // Import NewsScreen
import 'about.dart'; // Import AboutScreen

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0; // Marks this page as the active page

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Icon(Icons.movie, color: Colors.grey[300]),
            const SizedBox(width: 10),
            const Text(
              'Silver Screen Saga',
              style: TextStyle(
                color: Color(0xFFE0E0E0),
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
          ],
        ),
        backgroundColor: const Color(0xFF1E1E1E),
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      backgroundColor: const Color(0xFF1E1E1E),
      body: IndexedStack(
        index: _currentIndex,
        children: const [
          MovieListScreen(), // Layar utama dengan daftar film (indeks 0)
          NewsScreen(), // Layar berita (indeks 1)
          AboutScreen(), // Layar tentang (sekarang di indeks 2)
          MapsScreen(), // Layar peta (sekarang di indeks 3)
        ],
      ),
      bottomNavigationBar: CurvedNavigationBar(
        index: _currentIndex, // Set the initial index
        height: 60.0,
        items: const <Widget>[
          Icon(Icons.movie, size: 30, color: Colors.white), // Change color to white
          Icon(Icons.newspaper, size: 30, color: Colors.white), // Change color to white
          Icon(Icons.info, size: 30, color: Colors.white), // Info icon (sekarang di indeks 2)
          Icon(Icons.map, size: 30, color: Colors.white), // Map icon (sekarang di indeks 3)
        ],
        color: const Color(0xFF1E1E1E), // Background color of the navigation bar
        backgroundColor: Colors.transparent, // Transparent background
        buttonBackgroundColor: Colors.amber, // Button color when selected
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}

class MovieListScreen extends StatefulWidget {
  const MovieListScreen({super.key});

  @override
  _MovieListScreenState createState() => _MovieListScreenState();
}

class _MovieListScreenState extends State<MovieListScreen> {
  int _currentPage = 1; // State untuk halaman saat ini
  late Future<List<dynamic>> movies; // Future untuk daftar film

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

  // Fungsi untuk refresh data tanpa reset halaman
  Future<void> _onRefresh() async {
    _fetchMovies(); // Hanya memuat ulang data di halaman yang sedang aktif
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Bagian UI yang tidak perlu diperbarui
        Container(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Now Showing',
                style: TextStyle(
                  color: Colors.grey[300],
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey[900],
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.amber, width: 1),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Row(
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
            ],
          ),
        ),
        // Bagian yang perlu diperbarui (daftar film) dengan RefreshIndicator
        Expanded(
          child: RefreshIndicator(
            onRefresh: _onRefresh, // Fungsi yang dipanggil saat refresh
            color: Colors.amber, // Warna indikator refresh
            child: FutureBuilder<List<dynamic>>(
              key: ValueKey<int>(_currentPage), // Gunakan Key untuk memastikan FutureBuilder diperbarui
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
                          // Fetch detailed movie information
                          final movieDetails = await MovieApi.fetchMovieDetails(movie['id']);

                          // Navigate to MovieDetailScreen
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
        ),
      ],
    );
  }
}