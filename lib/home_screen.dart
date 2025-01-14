import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart'; // Import curved_navigation_bar
import 'movie_detail_screen.dart';
import 'movie.dart';
import 'movie_api.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<Movie>> movies;
  int _currentIndex = 0; // Menandai halaman ini sebagai halaman aktif
  int _currentPage = 1;
  String selectedCategory = 'now_playing';  // Default category

  @override
  void initState() {
    super.initState();
    _fetchMovies();
  }

  void _fetchMovies() {
    setState(() {
      movies = MovieApi.fetchMovies(page: _currentPage, category: selectedCategory);
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
    if (index == 1) {
      Navigator.pushReplacementNamed(context, '/news');
    } else if (index == 2) {
      Navigator.pushReplacementNamed(context, '/about');
    }
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

  Future<void> _refreshMovies() async {
    setState(() {
      _currentPage = 1;  // Reset to first page on refresh
      _fetchMovies();
    });
  }

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
      body: RefreshIndicator(
        onRefresh: _refreshMovies,
        child: Column(
          children: [
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
                          onPressed: _currentPage > 1 ? _loadPreviousPage : null,
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
            Expanded(
              child: FutureBuilder<List<Movie>>(
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
                    List<Movie> movieList = snapshot.data!;

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
                        Movie movie = movieList[index];
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MovieDetailScreen(
                                  title: movie.title,
                                  synopsis: movie.synopsis,
                                  trailerLink: movie.trailerUrl,
                                  posterUrl: movie.posterUrl,
                                ),
                              ),
                            );
                          },
                          child: Hero(
                            tag: movie.posterUrl,
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
                                        movie.posterUrl,
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
                                      movie.title,
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
          ],
        ),
      ),
      bottomNavigationBar: CurvedNavigationBar(
        index: _currentIndex, // Set the initial index
        height: 60.0,
        items: <Widget>[
          Icon(Icons.movie, size: 30, color: Colors.white), // Change color to white
          Icon(Icons.newspaper, size: 30, color: Colors.white), // Change color to white
          Icon(Icons.info, size: 30, color: Colors.white), // Change color to white
        ],
        color: const Color(0xFF1E1E1E), // Background color of the navigation bar
        backgroundColor: Colors.transparent, // Transparent background
        buttonBackgroundColor: Colors.amber, // Button color when selected
        onTap: _onItemTapped,
      ),
    );
  }
}
