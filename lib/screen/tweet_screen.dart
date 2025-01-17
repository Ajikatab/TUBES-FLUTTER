import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/notification_service.dart';

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
                // Simpan tweet ke Firestore
                await firestore.collection('tweet').add({
                  'content': contentController.text,
                  'name': username,
                  'username': username,
                  'profileImage':
                      user.photoURL ?? 'https://via.placeholder.com/150',
                  'timestamp': Timestamp.now(),
                  'likes': [],
                  'comments': [],
                });

                // Kirim notifikasi ke pengguna lain
                await NotificationService().sendTweetNotification(
                  senderName: username,
                  tweetContent: contentController.text,
                  senderId: user.uid,
                );

                // Tampilkan notifikasi lokal untuk pengguna yang sedang login
                await NotificationService().showLocalNotification(
                  'Tweet Created',
                  'Your tweet has been posted successfully!',
                );

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

class TweetCard extends StatefulWidget {
  final Tweet tweet;
  final FirebaseFirestore firestore;

  const TweetCard({super.key, required this.tweet, required this.firestore});

  @override
  _TweetCardState createState() => _TweetCardState();
}

class _TweetCardState extends State<TweetCard> {
  bool _showAllComments = false; // State untuk menampilkan semua komentar

  Future<void> _confirmDeleteTweet() async {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1E1E1E),
        title: const Text(
          'Hapus Tweet',
          style: TextStyle(color: Colors.white),
        ),
        content: const Text(
          'Apakah Anda yakin ingin menghapus tweet ini?',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context), // Batal
            child: const Text(
              'Batal',
              style: TextStyle(color: Colors.grey),
            ),
          ),
          TextButton(
            onPressed: () async {
              await deleteTweet(); // Hapus tweet
              Navigator.pop(context); // Tutup dialog
            },
            child: const Text(
              'Hapus',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;
    final userId = user?.uid ?? '';

    // Ambil 2 komentar pertama jika tidak menampilkan semua komentar
    final displayedComments = _showAllComments
        ? widget.tweet.comments
        : widget.tweet.comments.take(2).toList();

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
            // Bagian atas (foto profil, username, dll)
            Row(
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(widget.tweet.profileImage),
                  radius: 20,
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${widget.tweet.username} · ${getTimeAgo()}', // Gabungkan username dan waktu
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                Spacer(),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: _confirmDeleteTweet, // Panggil fungsi konfirmasi
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              widget.tweet.content,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                // Tombol Comment
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
                          backgroundColor: const Color(0xFF1E1E1E),
                          title: const Text('Tambah Komentar',
                              style: TextStyle(color: Colors.white)),
                          content: TextField(
                            controller: commentController,
                            style: const TextStyle(color: Colors.white),
                            decoration: const InputDecoration(
                              hintText: 'Masukkan komentar Anda',
                              hintStyle: TextStyle(color: Colors.grey),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.amber),
                              ),
                            ),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('Batal',
                                  style: TextStyle(color: Colors.grey)),
                            ),
                            TextButton(
                              onPressed: () async {
                                if (commentController.text.isNotEmpty) {
                                  await addComment(
                                      userId, commentController.text);
                                  Navigator.pop(context);
                                }
                              },
                              child: const Text('Tambah',
                                  style: TextStyle(color: Colors.amber)),
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
                const SizedBox(
                    width: 8), // Jarak antara tombol Comment dan Like
                // Tombol Like
                IconButton(
                  icon: Icon(
                    widget.tweet.likes.contains(userId)
                        ? Icons.favorite
                        : Icons.favorite_border,
                    color: widget.tweet.likes.contains(userId)
                        ? Colors.red
                        : Colors.grey,
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
                    '${widget.tweet.comments.length} Comments',
                    style: TextStyle(color: Colors.grey[400]),
                  ),
                  const SizedBox(width: 20),
                  Text(
                    '${widget.tweet.likes.length} Likes',
                    style: TextStyle(color: Colors.grey[400]),
                  ),
                ],
              ),
            ),
            const Divider(color: Colors.grey),
            // Menampilkan komentar
            ...displayedComments.map((comment) {
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
            // Tombol "Lihat balasan lainnya" jika ada lebih dari 2 komentar
            if (widget.tweet.comments.length > 2 && !_showAllComments)
              TextButton(
                onPressed: () {
                  setState(() {
                    _showAllComments = true; // Tampilkan semua komentar
                  });
                },
                child: const Text(
                  'Lihat balasan lainnya',
                  style: TextStyle(color: Colors.amber),
                ),
              ),
          ],
        ),
      ),
    );
  }

  String getTimeAgo() {
    final now = DateTime.now();
    final difference = now.difference(widget.tweet.timestamp.toDate());
    if (difference.inDays > 0) return '${difference.inDays}d';
    if (difference.inHours > 0) return '${difference.inHours}h';
    if (difference.inMinutes > 0) return '${difference.inMinutes}m';
    return 'now';
  }

  Future<void> toggleLike(String userId) async {
    final tweetRef = widget.firestore.collection('tweet').doc(widget.tweet.id);

    if (widget.tweet.likes.contains(userId)) {
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
    final userDoc = await widget.firestore.collection('user').doc(userId).get();
    final userData = userDoc.data() as Map<String, dynamic>;
    final username = userData['username'] ?? 'Anonymous';

    final tweetRef = widget.firestore.collection('tweet').doc(widget.tweet.id);

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
    final tweetRef = widget.firestore.collection('tweet').doc(widget.tweet.id);
    await tweetRef.delete();
  }
}
