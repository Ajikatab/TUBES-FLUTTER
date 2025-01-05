import 'package:flutter/material.dart';
import 'movie_detail_screen.dart';
import 'movie.dart';
import 'movie_api.dart';
import 'shop_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<Movie>> movies;
  int _selectedIndex = 0;
  int _currentPage = 1;

  @override
  void initState() {
    super.initState();
    movies = MovieApi.fetchMovies();
  }

  void _onItemTapped(int index) {
    if (index == 2) {
      // Jika tombol Shop ditekan (index 2)
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const ShopScreen()),
      );
      return;
    }
    
    setState(() {
      _selectedIndex = index;
      _currentPage = 1; // Reset halaman saat tab berubah
      movies = MovieApi.fetchMovies(); // Muat ulang film
    });
  }

  void _loadNextPage() {
    setState(() {
      _currentPage++;
      movies = MovieApi.fetchMovies(); // Hapus parameter page karena belum didefinisikan
    });
  }

  void _loadPreviousPage() {
    if (_currentPage > 1) {
      setState(() {
        _currentPage--;
        movies = MovieApi.fetchMovies(); // Hapus parameter page karena belum didefinisikan
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            Icon(Icons.movie, color: Colors.amber),
            SizedBox(width: 10),
            Text(
              'Cinema XXI',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
          ],
        ),
        backgroundColor: Colors.black87,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.amber),
            onPressed: () {},
          ),
        ],
      ),
      backgroundColor: Colors.black87,
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _selectedIndex == 0 ? 'Now Showing' : 
                  _selectedIndex == 1 ? 'Category' : 
                  'Shop',
                  style: const TextStyle(
                    color: Colors.amber,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios, color: Colors.amber),
                      onPressed: _loadPreviousPage,
                    ),
                    Text(
                      'Page $_currentPage',
                      style: const TextStyle(color: Colors.amber),
                    ),
                    IconButton(
                      icon: const Icon(Icons.arrow_forward_ios, color: Colors.amber),
                      onPressed: _loadNextPage,
                    ),
                  ],
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
                    padding: const EdgeInsets.all(16),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.65,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
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
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[900],
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.amber.withOpacity(0.3),
                                spreadRadius: 1,
                                blurRadius: 5,
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Expanded(
                                flex: 5,
                                child: ClipRRect(
                                  borderRadius: const BorderRadius.vertical(
                                    top: Radius.circular(15),
                                  ),
                                  child: Stack(
                                    fit: StackFit.expand,
                                    children: [
                                      Image.network(
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
                                      Container(
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            begin: Alignment.topCenter,
                                            end: Alignment.bottomCenter,
                                            colors: [
                                              Colors.transparent,
                                              Colors.black.withOpacity(0.7),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.all(12),
                                child: Text(
                                  movie.title,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
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
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.movie),
            label: 'Now Showing',
            backgroundColor: Colors.black87,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.category),
            label: 'Category',
            backgroundColor: Colors.black87,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Shop',
            backgroundColor: Colors.black87,
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
      ),
    );
  }
}
