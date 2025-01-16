import 'package:flutter/material.dart';
import '../api/news_api.dart';
import '../detailscreen/news_detail.dart';

class NewsScreen extends StatefulWidget {
  const NewsScreen({super.key});

  @override
  _NewsScreenState createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  late Future<List<dynamic>> newsArticles;
  String selectedSource = 'antara'; // Default news source
  String selectedCategory = 'terbaru'; // Default category

  // Define categories for each source
  final Map<String, List<String>> categories = {
    'antara': ['terbaru', 'politik', 'hukum', 'ekonomi', 'bola', 'olahraga', 'humaniora', 'lifestyle', 'hiburan', 'dunia', 'tekno', 'otomotif'],
    'cnbc': ['terbaru', 'investment', 'news', 'market', 'entrepreneur', 'syariah', 'tech', 'lifestyle', 'opini', 'profil'],
    'cnn': ['terbaru', 'nasional', 'internasional', 'ekonomi', 'olahraga', 'teknologi', 'hiburan', 'gayahidup'],
    'jpnn': ['terbaru'],
    'kumparan': ['terbaru'],
    'merdeka': ['terbaru', 'jakarta', 'dunia', 'gaya', 'olahraga', 'teknologi', 'otomotif', 'khas', 'sehat', 'jateng'],
    'okezone': ['terbaru', 'celebrity', 'sports', 'otomotif', 'economy', 'techno', 'lifestyle', 'bola'],
    'republika': ['terbaru', 'news', 'daerah', 'khazanah', 'islam', 'internasional', 'bola', 'leisure'],
    'sindonews': ['terbaru', 'nasional', 'metro', 'ekbis', 'international', 'daerah', 'sports', 'otomotif', 'tekno', 'sains', 'edukasi', 'lifestyle', 'kalam'],
  };

  @override
  void initState() {
    super.initState();
    _fetchNews();
  }

  void _fetchNews() {
    if (!categories[selectedSource]!.contains(selectedCategory)) {
      selectedCategory = categories[selectedSource]![0];
    }
    setState(() {
      newsArticles = NewsApi().fetchNews(selectedSource, selectedCategory).catchError((error) {
        // Handle error and return an empty list
        return [];
      });
    });
  }

  // Refresh the news articles
  Future<void> _onRefresh() async {
    _fetchNews(); // Refresh the news by fetching the data again
  }

  void _updateCategory(String source) {
    setState(() {
      if (!categories[source]!.contains(selectedCategory)) {
        selectedCategory = categories[source]![0]; // Set ke kategori pertama jika tidak valid
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('News'),
        backgroundColor: const Color(0xFF1E1E1E),
        automaticallyImplyLeading: false, // Remove the back button
      ),
      backgroundColor: const Color(0xFF1E1E1E),
      body: Column(
        children: [
          // Dropdown for selecting news source and category
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.grey[800],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: DropdownButton<String>(
                      value: selectedSource,
                      dropdownColor: Colors.grey[800],
                      style: const TextStyle(color: Colors.white),
                      icon: const Icon(Icons.arrow_drop_down, color: Colors.amber),
                      isExpanded: true,
                      onChanged: (value) {
                        setState(() {
                          selectedSource = value!;
                          _updateCategory(selectedSource); // Ensure category is valid
                          _fetchNews();
                        });
                      },
                      items: const [
                        DropdownMenuItem(value: 'antara', child: Text('Antara')),
                        DropdownMenuItem(value: 'cnbc', child: Text('CNBC')),
                        DropdownMenuItem(value: 'cnn', child: Text('CNN')),
                        DropdownMenuItem(value: 'jpnn', child: Text('JPNN')),
                        DropdownMenuItem(value: 'kumparan', child: Text('Kumparan')),
                        DropdownMenuItem(value: 'merdeka', child: Text('Merdeka')),
                        DropdownMenuItem(value: 'okezone', child: Text('Okezone')),
                        DropdownMenuItem(value: 'republika', child: Text('Republika')),
                        DropdownMenuItem(value: 'sindonews', child: Text('Sindonews')),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.grey[800],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: DropdownButton<String>(
                      value: categories[selectedSource]!.contains(selectedCategory) 
                            ? selectedCategory 
                            : categories[selectedSource]![0],
                      dropdownColor: Colors.grey[800],
                      style: const TextStyle(color: Colors.white),
                      icon: const Icon(Icons.arrow_drop_down, color: Colors.amber),
                      isExpanded: true,
                      onChanged: (value) {
                        setState(() {
                          selectedCategory = value!;
                          _fetchNews();
                        });
                      },
                      items: categories[selectedSource]!
                          .map((category) => DropdownMenuItem<String>(
                                value: category,
                                child: Text(category),
                              ))
                          .toList(),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: _onRefresh, // Set the refresh function
              color: Colors.amber, // Spinner color when refreshing
              child: FutureBuilder<List<dynamic>>(
                future: newsArticles,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.amber),
                      ),
                    );
                  } else if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) {
                    // Handle error or empty data
                    return const Center(
                      child: Text(
                        'No news',
                        style: TextStyle(color: Colors.white),
                      ),
                    );
                  } else {
                    List<dynamic> newsList = snapshot.data!;
                    return ListView.builder(
                      padding: const EdgeInsets.all(8.0),
                      itemCount: newsList.length,
                      itemBuilder: (context, index) {
                        var news = newsList[index];
                        return Card(
                          color: Colors.grey[900],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          margin: const EdgeInsets.symmetric(vertical: 8.0),
                          child: ListTile(
                            contentPadding: const EdgeInsets.all(8.0),
                            leading: ClipRRect(
                              borderRadius: BorderRadius.circular(8.0),
                              child: Image.network(
                                news['thumbnail'] ?? '',
                                width: 80,
                                height: 80,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    width: 80,
                                    height: 80,
                                    color: Colors.grey[800],
                                    child: const Icon(
                                      Icons.error,
                                      color: Colors.amber,
                                    ),
                                  );
                                },
                              ),
                            ),
                            title: Text(
                              news['title'] ?? 'No Title',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            subtitle: Text(
                              news['description'] ?? 'No Description',
                              style: TextStyle(
                                color: Colors.grey[400],
                                fontSize: 12,
                              ),
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => NewsDetail(
                                    title: news['title'] ?? 'No Title',
                                    description: news['description'] ?? 'No Description',
                                    imageUrl: news['thumbnail'] ?? '',
                                    newsLink: news['link'],
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
            ),
          ),
        ],
      ),
    );
  }
}