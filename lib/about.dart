import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

class AboutScreen extends StatefulWidget {
  const AboutScreen({super.key});

  @override
  _AboutScreenState createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About'),
        automaticallyImplyLeading: false,
      ),
      body: const Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Text(
            'Aplikasi ini dibuat untuk memberikan informasi terkini tentang film yang sedang tayang. '
            'Nikmati pengalaman menonton yang lebih baik dengan fitur-fitur yang kami sediakan.',
            style: TextStyle(fontSize: 16),
            textAlign: TextAlign.center,
          ),
        ),
      ),
      bottomNavigationBar: CurvedNavigationBar(
        index: 2,  // The initial index for 'About' screen
        height: 60.0,
        items: const <Widget>[
          Icon(Icons.movie, size: 30, color: Colors.white),  // Set color to white
          Icon(Icons.newspaper, size: 30, color: Colors.white),  // Set color to white
          Icon(Icons.info, size: 30, color: Colors.white),  // Set color to white
        ],
        color: const Color(0xFF1E1E1E), // Background color of the navigation bar
        backgroundColor: Colors.transparent, // Transparent background
        buttonBackgroundColor: Colors.amber, // Selected button background color
        onTap: (index) {
          if (index == 0) {
            Navigator.pushReplacementNamed(context, '/home');
          } else if (index == 1) {
            Navigator.pushReplacementNamed(context, '/news');
          }
        },
      ),
    );
  }
}
