import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'news_api.dart';
import 'news_detail.dart';

class NewsScreen extends StatefulWidget {
  const NewsScreen({super.key});

  @override
  _NewsScreenState createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  late Future<List<dynamic>> newsArticles;
  String selectedSource = 'antara'; // Default news source
  String selectedCategory = 'terbaru'; // Default category

  @override
  void initState() {
    super.initState();
    _fetchNews();
  }

  // Fetch news based on selected source and category
  void _fetchNews() {
    setState(() {
      newsArticles = NewsApi().fetchNews(selectedSource, selectedCategory);
    });
  }

  // Refresh the news articles
  Future<void> _onRefresh() async {
    _fetchNews(); // Refresh the news by fetching the data again
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
                          selectedCategory = 'terbaru'; // Reset category
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
                      value: selectedCategory,
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
                      items: const [
                        DropdownMenuItem(value: 'terbaru', child: Text('Latest')),
                        DropdownMenuItem(value: 'politik', child: Text('Politics')),
                        DropdownMenuItem(value: 'ekonomi', child: Text('Economy')),
                        DropdownMenuItem(value: 'hukum', child: Text('Law')),
                        DropdownMenuItem(value: 'teknologi', child: Text('Technology')),
                        DropdownMenuItem(value: 'olahraga', child: Text('Sports')),
                      ],
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
                        'No news available',
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
      bottomNavigationBar: CurvedNavigationBar(
        index: 1, // Set the initial index for 'News' screen
        height: 60.0,
        items: const <Widget>[
          Icon(Icons.movie, size: 30, color: Colors.white),
          Icon(Icons.newspaper, size: 30, color: Colors.white),
          Icon(Icons.info, size: 30, color: Colors.white),
        ],
        color: const Color(0xFF1E1E1E), // Background color of the navigation bar
        backgroundColor: Colors.transparent, // Transparent background
        buttonBackgroundColor: Colors.amber, // Selected button background color
        onTap: (index) {
          if (index == 0) {
            Navigator.pushReplacementNamed(context, '/home');
          } else if (index == 2) {
            Navigator.pushReplacementNamed(context, '/about');
          }
        },
      ),
    );
  }
}
