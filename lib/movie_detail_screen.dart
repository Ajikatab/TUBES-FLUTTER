import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart'; // Untuk membuka link trailer

class MovieDetailScreen extends StatelessWidget {
  final String title;
  final String synopsis;
  final String trailerLink;

  MovieDetailScreen({
    required this.title,
    required this.synopsis,
    required this.trailerLink,
  });

  // Fungsi untuk membuka URL trailer di browser
  Future<void> _launchURL() async {
    if (await canLaunch(trailerLink)) {
      await launch(trailerLink);
    } else {
      throw 'Could not launch $trailerLink';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Synopsis',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(synopsis), // Menampilkan sinopsis film
            SizedBox(height: 20),
            Text(
              'Trailer',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            GestureDetector(
              onTap: _launchURL, // Membuka trailer ketika tapped
              child: Row(
                children: [
                  Icon(Icons.play_circle_outline, color: Colors.blue),
                  SizedBox(width: 8),
                  Text(
                    'Watch Trailer',
                    style: TextStyle(color: Colors.blue),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
