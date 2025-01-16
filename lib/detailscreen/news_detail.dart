import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_html/flutter_html.dart';

class NewsDetail extends StatefulWidget {
  final String title;
  final String description;
  final String imageUrl;
  final String? newsLink;

  const NewsDetail({
    super.key,
    required this.title,
    required this.description,
    required this.imageUrl,
    this.newsLink,
  });

  @override
  _NewsDetailState createState() => _NewsDetailState();
}

class _NewsDetailState extends State<NewsDetail> {
  String? _htmlContent;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    if (widget.newsLink != null) {
      _fetchHtmlContent(widget.newsLink!);
    } else {
      _isLoading = false;
    }
  }

  // Fetch HTML content from the news link
  Future<void> _fetchHtmlContent(String url) async {
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        setState(() {
          _htmlContent = response.body;
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load content: ${response.statusCode}')),
        );
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('News Detail'),
        backgroundColor: Colors.black87,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        elevation: 0,
      ),
      backgroundColor: const Color(0xFF121212),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Image with rounded corners and shadow
            Hero(
              tag: widget.imageUrl,
              child: Container(
                height: 250,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Image.network(
                    widget.imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 200,
                        color: Colors.grey[800],
                        child: const Icon(
                          Icons.error,
                          color: Colors.amber,
                          size: 50,
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Title of the news article
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                widget.title,
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  height: 1.3,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 12),
            // Description of the news article
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                widget.description,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[300],
                  height: 1.7,
                ),
                textAlign: TextAlign.justify,
              ),
            ),
            const SizedBox(height: 20),
            // Display HTML content if available
            if (_isLoading)
              const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.amber),
                ),
              )
            else if (_htmlContent != null)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Html(
                  data: _htmlContent,
                  style: {
                    "body": Style(
                      color: Colors.white,
                      fontSize: FontSize(16),
                      padding: HtmlPaddings.all(0),
                      margin: Margins.zero,
                    ),
                    "p": Style(
                      color: Colors.grey[300],
                      fontSize: FontSize(16),
                      lineHeight: LineHeight(1.7),
                    ),
                    "h1": Style(
                      color: Colors.white,
                      fontSize: FontSize(24),
                      fontWeight: FontWeight.bold,
                    ),
                    "h2": Style(
                      color: Colors.white,
                      fontSize: FontSize(22),
                      fontWeight: FontWeight.bold,
                    ),
                    "h3": Style(
                      color: Colors.white,
                      fontSize: FontSize(20),
                      fontWeight: FontWeight.bold,
                    ),
                    "a": Style(
                      color: Colors.amber,
                      textDecoration: TextDecoration.none,
                    ),
                  },
                ),
              ),
            const SizedBox(height: 16),
            // News link button (if available)
            if (widget.newsLink != null)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: ElevatedButton.icon(
                  onPressed: () => _openNewsLink(context, widget.newsLink!),
                  icon: const Icon(Icons.article, color: Colors.black),
                  label: const Text(
                    'Read Full Article',
                    style: TextStyle(color: Colors.black),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amber,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    minimumSize: const Size(double.infinity, 50),
                  ),
                ),
              ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  // Function to open the news link
  void _openNewsLink(BuildContext context, String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not launch $url')),
      );
    }
  }
}