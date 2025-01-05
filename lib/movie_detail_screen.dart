import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class MovieDetailScreen extends StatelessWidget {
  final String title;
  final String synopsis;
  final String trailerLink;
  final String posterUrl;

  const MovieDetailScreen({
    super.key,
    required this.title,
    required this.synopsis,
    required this.trailerLink,
    required this.posterUrl,
  });

  Future<void> _launchURL() async {
    final Uri url = Uri.parse(trailerLink);
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not launch $trailerLink';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: Colors.black87,
            expandedHeight: 400,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                title,
                style: const TextStyle(
                  color: Colors.amber,
                  fontWeight: FontWeight.bold,
                  shadows: [
                    Shadow(
                      blurRadius: 10.0,
                      color: Colors.black,
                      offset: Offset(2.0, 2.0),
                    ),
                  ],
                ),
              ),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    posterUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.grey[900],
                        child: const Icon(
                          Icons.movie,
                          size: 100,
                          color: Colors.amber,
                        ),
                      );
                    },
                  ),
                  DecoratedBox(
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
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Card(
                    elevation: 8,
                    color: Colors.grey[900],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.amber.withOpacity(0.3),
                            spreadRadius: 1,
                            blurRadius: 5,
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Synopsis',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.amber,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              synopsis,
                              style: const TextStyle(
                                fontSize: 16,
                                height: 1.5,
                                color: Colors.white,
                              ),
                              textAlign: TextAlign.justify,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Card(
                    elevation: 8,
                    color: Colors.grey[900],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: InkWell(
                      onTap: _launchURL,
                      borderRadius: BorderRadius.circular(15),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.amber.withOpacity(0.3),
                              spreadRadius: 1,
                              blurRadius: 5,
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              const Text(
                                'Watch Trailer',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.amber,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                  horizontal: 24,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.amber,
                                  borderRadius: BorderRadius.circular(30),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.2),
                                      spreadRadius: 2,
                                      blurRadius: 5,
                                      offset: const Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: const Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.play_circle_filled,
                                      color: Colors.black87,
                                      size: 28,
                                    ),
                                    SizedBox(width: 8),
                                    Text(
                                      'Play Trailer',
                                      style: TextStyle(
                                        color: Colors.black87,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
