import 'package:flutter/material.dart';

class MovieDetailScreen extends StatelessWidget {
  final String title;
  final String synopsis;
  final String posterUrl;
  final String releaseDate;
  final double? voteAverage; // Biarkan nullable jika diperlukan
  final int runtime; // Tambahkan runtime
  final List<String> genres; // Tambahkan genres

  const MovieDetailScreen({
    super.key,
    required this.title,
    required this.synopsis,
    required this.posterUrl,
    required this.releaseDate,
    this.voteAverage, // Biarkan nullable
    required this.runtime, // Wajib
    required this.genres, // Wajib
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E1E1E),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: Colors.transparent,
            expandedHeight: 450,
            pinned: true,
            leading: IconButton(
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Icon(Icons.arrow_back, color: Colors.grey[300]),
              ),
              onPressed: () => Navigator.pop(context),
            ),
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                title,
                style: TextStyle(
                  color: Colors.grey[300],
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  shadows: const [
                    Shadow(
                      blurRadius: 12.0,
                      color: Colors.black,
                      offset: Offset(2.0, 2.0),
                    ),
                  ],
                ),
                textAlign: TextAlign.center,
              ),
              background: Hero(
                tag: posterUrl,
                child: Stack(
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
                            size: 120,
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
                            Colors.black.withOpacity(0.8),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Release Date
                  _buildDetailCard(
                    icon: Icons.calendar_today,
                    title: 'Release Date',
                    content: releaseDate,
                  ),
                  const SizedBox(height: 24),

                  // Rating
                  _buildDetailCard(
                    icon: Icons.star,
                    title: 'Rating',
                    content: voteAverage != null ? '$voteAverage/10' : 'N/A',
                  ),
                  const SizedBox(height: 24),

                  // Runtime
                  _buildDetailCard(
                    icon: Icons.timer,
                    title: 'Runtime',
                    content: '$runtime minutes', // Tampilkan runtime
                  ),
                  const SizedBox(height: 24),

                  // Genres
                  _buildDetailCard(
                    icon: Icons.category,
                    title: 'Genres',
                    content: genres.join(', '), // Tampilkan genres
                  ),
                  const SizedBox(height: 24),

                  // Synopsis
                  _buildDetailCard(
                    icon: Icons.description,
                    title: 'Synopsis',
                    content: synopsis,
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Helper method to build a detail card
  Widget _buildDetailCard({
    required IconData icon,
    required String title,
    required String content,
  }) {
    return Card(
      elevation: 12,
      color: Colors.grey[900],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.grey[900]!,
              Colors.grey[850]!,
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.amber.withOpacity(0.4),
              spreadRadius: 1,
              blurRadius: 8,
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    icon,
                    color: Colors.amber,
                    size: 28,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.amber,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                content,
                style: const TextStyle(
                  fontSize: 16,
                  height: 1.6,
                  color: Colors.white,
                  letterSpacing: 0.5,
                ),
                textAlign: TextAlign.justify,
              ),
            ],
          ),
        ),
      ),
    );
  }
}