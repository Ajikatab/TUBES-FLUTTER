import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'movie_screen.dart'; // Import MovieScreen
import 'news_screen.dart'; // Import NewsScreen
import 'setting_screen.dart'; // Import SettingScreen
import 'maps_screen.dart'; // Import MapsScreen
import 'tweet_screen.dart'; // Import TweetScreen

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 2; // Set indeks awal ke 2 (TweetListScreen)

  final List<Widget> _screens = [
    const MovieScreen(), // Layar movie (indeks 0)
    const NewsScreen(), // Layar berita (indeks 1)
    const TweetListScreen(), // Layar tweet (indeks 2)
    const MapsScreen(), // Layar peta (indeks 3)
    const SettingScreen(), // Layar setting (indeks 4)
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //   appBar: AppBar(
      //   title: Row(
      //     children: [
      //       Icon(Icons.movie, color: Colors.grey[300]),
      //       const SizedBox(width: 10),
      //       const Text(
      //         'Silver Screen Saga',
      //         style: TextStyle(
      //           color: Color(0xFFE0E0E0),
      //           fontWeight: FontWeight.bold,
      //           fontSize: 24,
      //         ),
      //       ),
      //     ],
      //   ),
      //   backgroundColor: const Color(0xFF1E1E1E),
      //   elevation: 0,
      //   automaticallyImplyLeading: false,
      // ),
      backgroundColor: const Color(0xFF1E1E1E),
      body: _screens[_currentIndex],
      bottomNavigationBar: CurvedNavigationBar(
        index: _currentIndex,
        height: 60.0,
        items: const <Widget>[
          Icon(Icons.movie, size: 30, color: Colors.white), // Ikon untuk MovieScreen
          Icon(Icons.newspaper, size: 30, color: Colors.white), // Ikon untuk NewsScreen
          Icon(Icons.home, size: 30, color: Colors.white), // Ikon untuk TweetListScreen
          Icon(Icons.map, size: 30, color: Colors.white), // Ikon untuk MapsScreen
          Icon(Icons.settings, size: 30, color: Colors.white), // Ikon untuk SettingScreen
        ],
        color: const Color(0xFF1E1E1E),
        backgroundColor: Colors.transparent,
        buttonBackgroundColor: Colors.amber,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}