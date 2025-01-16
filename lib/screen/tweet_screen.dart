import 'package:flutter/material.dart';

class Tweet {
  final String profileImage;
  final String name;
  final String username;
  final String time;
  final String content;
  final int likes;
  final int retweets;
  final int comments;

  Tweet({
    required this.profileImage,
    required this.name,
    required this.username,
    required this.time,
    required this.content,
    required this.likes,
    required this.retweets,
    required this.comments,
  });
}

final List<Tweet> tweets = [
  Tweet(
    profileImage: 'https://via.placeholder.com/150',
    name: 'John Doe',
    username: '@johndoe',
    time: '2h',
    content: 'This is a sample tweet. Hello, world!',
    likes: 120,
    retweets: 45,
    comments: 10,
  ),
  Tweet(
    profileImage: 'https://via.placeholder.com/150',
    name: 'Jane Smith',
    username: '@janesmith',
    time: '4h',
    content: 'Flutter is amazing! 🚀',
    likes: 200,
    retweets: 80,
    comments: 25,
  ),
  Tweet(
    profileImage: 'https://via.placeholder.com/150',
    name: 'Alice Johnson',
    username: '@alicej',
    time: '1d',
    content: 'Just finished my first Flutter project. So proud!',
    likes: 300,
    retweets: 100,
    comments: 50,
  ),
];

class TweetListScreen extends StatelessWidget {
  const TweetListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E1E1E),
      appBar: AppBar(
        title: const Text(
          'Home',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFF1E1E1E),
        elevation: 0,
      ),
      body: ListView.builder(
        itemCount: tweets.length,
        itemBuilder: (context, index) {
          final tweet = tweets[index];
          return TweetCard(tweet: tweet);
        },
      ),
    );
  }
}

class TweetCard extends StatelessWidget {
  final Tweet tweet;

  const TweetCard({super.key, required this.tweet});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      color: Colors.grey[900], // Warna latar belakang tweet
      elevation: 4, // Tinggi shadow
      shadowColor: Colors.amber.withOpacity(0.3), // Warna shadow
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12), // Border radius
        side: BorderSide(
          color: Colors.amber.withOpacity(0.5), // Warna border
          width: 1, // Ketebalan border
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(tweet.profileImage),
                  radius: 20,
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      tweet.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      '${tweet.username} · ${tweet.time}',
                      style: TextStyle(
                        color: Colors.grey[400],
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              tweet.content,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.chat_bubble_outline, color: Colors.grey),
                  onPressed: () {
                    // Action for comments
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.repeat, color: Colors.grey),
                  onPressed: () {
                    // Action for retweets
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.favorite_border, color: Colors.grey),
                  onPressed: () {
                    // Action for likes
                  },
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Text(
                    '${tweet.comments} Comments',
                    style: TextStyle(color: Colors.grey[400]),
                  ),
                  const SizedBox(width: 20),
                  Text(
                    '${tweet.retweets} Retweets',
                    style: TextStyle(color: Colors.grey[400]),
                  ),
                  const SizedBox(width: 20),
                  Text(
                    '${tweet.likes} Likes',
                    style: TextStyle(color: Colors.grey[400]),
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