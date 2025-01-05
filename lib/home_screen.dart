import 'package:flutter/material.dart';
import 'movie_detail_screen.dart';
import 'movie.dart'; // Import model movie
import 'movie_api.dart'; // Import MovieApi untuk fetch data dari API

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<Movie>> movies;

  @override
  void initState() {
    super.initState();
    movies =
        MovieApi.fetchMovies(); // Memanggil MovieApi untuk mengambil data film
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Latest Movies'),
      ),
      body: FutureBuilder<List<Movie>>(
        future: movies,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator()); // Menunggu data
          } else if (snapshot.hasError) {
            return Center(
                child: Text('Error: ${snapshot.error}')); // Jika error
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
                child: Text('No movies available')); // Jika tidak ada data
          } else {
            List<Movie> movieList = snapshot.data!;

            return ListView.builder(
              itemCount: movieList.length,
              itemBuilder: (context, index) {
                Movie movie = movieList[index];
                return Card(
                  margin: EdgeInsets.all(8),
                  child: ListTile(
                    title: Text(movie.title),
                    subtitle: Text(movie.synopsis),
                    trailing: Icon(Icons.arrow_forward),
                    onTap: () {
                      // Arahkan ke halaman detail film saat ditekan
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MovieDetailScreen(
                            title: movie.title,
                            synopsis: movie.synopsis,
                            trailerLink: movie.trailerUrl,
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
