import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Tweet {
  final String id;
  final String profileImage;
  final String name;
  final String username;
  final String content;
  final List<String> likes;
  final List<dynamic> comments;
  final Timestamp timestamp;

  Tweet({
    required this.id,
    required this.profileImage,
    required this.name,
    required this.username,
    required this.content,
    required this.likes,
    required this.comments,
    required this.timestamp,
  });

  factory Tweet.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map;
    return Tweet(
      id: doc.id,
      profileImage: data['profileImage'] ?? 'https://via.placeholder.com/150',
      name: data['name'] ?? '',
      username: data['username'] ?? '',
      content: data['content'] ?? '',
      likes: List<String>.from(data['likes'] ?? []),
      comments: data['comments'] ?? [],
      timestamp: data['timestamp'] ?? Timestamp.now(),
    );
  }
}

class TweetScreen extends StatelessWidget {
  final FirebaseFirestore firestore;

  const TweetScreen({super.key, required this.firestore});

  Future<void> _createNewTweet(BuildContext context) async {
    final TextEditingController contentController = TextEditingController();
    final User? user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User not logged in')),
      );
      return;
    }

    // Ambil data user dari Firestore
    final userDoc = await firestore.collection('user').doc(user.uid).get();
    final userData = userDoc.data() as Map<String, dynamic>;
    final username = userData['username'] ?? 'Anonymous';

    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1E1E1E),
        title: const Text('Buat Tweet Baru',
            style: TextStyle(color: Colors.white)),
        content: TextField(
          controller: contentController,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
            hintText: 'Apa yang sedang terjadi?',
            hintStyle: TextStyle(color: Colors.grey),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.amber),
            ),
          ),
          maxLines: 4,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal', style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () async {
              if (contentController.text.isNotEmpty) {
                await firestore.collection('tweet').add({
                  'content': contentController.text,
                  'name': username, // Gunakan username dari Firestore
                  'username': username, // Gunakan username dari Firestore
                  'profileImage':
                      user.photoURL ?? 'https://via.placeholder.com/150',
                  'timestamp': Timestamp.now(),
                  'likes': [],
                  'comments': [],
                });
                Navigator.pop(context);
              }
            },
            child: const Text('Tweet', style: TextStyle(color: Colors.amber)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E1E1E),
      appBar: AppBar(
        title: const Text(
          'Tweet',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFF1E1E1E),
        elevation: 0,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: firestore
            .collection('tweet')
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}',
                  style: const TextStyle(color: Colors.white)),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final tweets = snapshot.data!.docs
              .map((doc) => Tweet.fromFirestore(doc))
              .toList();

          return ListView.builder(
            itemCount: tweets.length,
            itemBuilder: (context, index) {
              return TweetCard(
                tweet: tweets[index],
                firestore: firestore,
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _createNewTweet(context),
        backgroundColor: Colors.amber,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}

class TweetCard extends StatelessWidget {
  final Tweet tweet;
  final FirebaseFirestore firestore;

  const TweetCard({super.key, required this.tweet, required this.firestore});

  String getTimeAgo() {
    final now = DateTime.now();
    final difference = now.difference(tweet.timestamp.toDate());
    if (difference.inDays > 0) return '${difference.inDays}d';
    if (difference.inHours > 0) return '${difference.inHours}h';
    if (difference.inMinutes > 0) return '${difference.inMinutes}m';
    return 'now';
  }

  Future<void> toggleLike(String userId) async {
    final tweetRef = firestore.collection('tweet').doc(tweet.id);

    if (tweet.likes.contains(userId)) {
      await tweetRef.update({
        'likes': FieldValue.arrayRemove([userId])
      });
    } else {
      await tweetRef.update({
        'likes': FieldValue.arrayUnion([userId])
      });
    }
  }

  Future<void> addComment(String userId, String comment) async {
    // Ambil data user dari Firestore
    final userDoc = await firestore.collection('user').doc(userId).get();
    final userData = userDoc.data() as Map<String, dynamic>;
    final username = userData['username'] ?? 'Anonymous';

    final tweetRef = firestore.collection('tweet').doc(tweet.id);

    await tweetRef.update({
      'comments': FieldValue.arrayUnion([
        {
          'userId': userId,
          'username': username, // Tambah field username
          'content': comment,
          'timestamp': Timestamp.now(),
        }
      ])
    });
  }

  Future<void> deleteTweet() async {
    final tweetRef = firestore.collection('tweet').doc(tweet.id);
    await tweetRef.delete();
  }

  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;
    final userId = user?.uid ?? '';

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      color: Colors.grey[900],
      elevation: 4,
      shadowColor: Colors.amber.withOpacity(0.3),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: Colors.amber.withOpacity(0.5),
          width: 1,
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
                      tweet.username,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      '${user?.email ?? ''} · ${getTimeAgo()}',
                      style: TextStyle(
                        color: Colors.grey[400],
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () async {
                    await deleteTweet();
                  },
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
                  icon:
                      const Icon(Icons.chat_bubble_outline, color: Colors.grey),
                  onPressed: () {
                    // Show dialog to add comment
                    showDialog(
                      context: context,
                      builder: (context) {
                        final TextEditingController commentController =
                            TextEditingController();
                        return AlertDialog(
                          title: const Text('Add Comment'),
                          content: TextField(
                            controller: commentController,
                            decoration: const InputDecoration(
                                hintText: 'Enter your comment'),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () async {
                                if (commentController.text.isNotEmpty) {
                                  await addComment(
                                      userId, commentController.text);
                                  Navigator.pop(context);
                                }
                              },
                              child: const Text('Add'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
                IconButton(
                  icon: Icon(
                    tweet.likes.contains(userId)
                        ? Icons.favorite
                        : Icons.favorite_border,
                    color:
                        tweet.likes.contains(userId) ? Colors.red : Colors.grey,
                  ),
                  onPressed: () {
                    toggleLike(userId);
                  },
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Text(
                    '${tweet.comments.length} Comments',
                    style: TextStyle(color: Colors.grey[400]),
                  ),
                  const SizedBox(width: 20),
                  Text(
                    '${tweet.likes.length} Likes',
                    style: TextStyle(color: Colors.grey[400]),
                  ),
                ],
              ),
            ),
            const Divider(color: Colors.grey),
            // Menampilkan komentar
            ...tweet.comments.map((comment) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      backgroundImage:
                          NetworkImage('https://via.placeholder.com/150'),
                      radius: 15,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            comment['username'] ?? 'Anonymous',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            comment['content'],
                            style: const TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}
