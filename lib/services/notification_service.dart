import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('Handling a background message: ${message.messageId}');
}

class NotificationService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> initialize() async {
    // Request permission for notifications
    await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    // Initialize local notifications
    const initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const initializationSettingsIOS = DarwinInitializationSettings();
    const initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (details) {
        // Handle notification tap
      },
    );

    // Handle background messages
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    // Handle foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      _showNotification(message);
    });
  }

  Future<String?> getToken() async {
    return await _firebaseMessaging.getToken();
  }

  Future<void> _showNotification(RemoteMessage message) async {
    const androidDetails = AndroidNotificationDetails(
      'tweet_channel',
      'Tweet Notifications',
      channelDescription: 'Notifications for new tweets',
      importance: Importance.max,
      priority: Priority.high,
    );

    const iOSDetails = DarwinNotificationDetails();

    const notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iOSDetails,
    );

    await _flutterLocalNotificationsPlugin.show(
      0,
      message.notification?.title ?? 'New Tweet',
      message.notification?.body,
      notificationDetails,
    );
  }

  Future<void> saveUserToken(String userId) async {
    final token = await getToken();
    if (token != null) {
      await FirebaseFirestore.instance
          .collection('user_tokens')
          .doc(userId)
          .set({'token': token}, SetOptions(merge: true));
    }
  }

  Future<void> sendTweetNotification({
    required String senderName,
    required String tweetContent,
    required String senderId,
  }) async {
    try {
      // Get all user tokens except sender
      final tokensSnapshot = await FirebaseFirestore.instance
          .collection('user_tokens')
          .where(FieldPath.documentId, isNotEqualTo: senderId)
          .get();

      final List<String> tokens = [];
      for (var doc in tokensSnapshot.docs) {
        final token = doc.data()['token'] as String?;
        if (token != null) tokens.add(token);
      }

      // Send notification to each token
      for (String token in tokens) {
        try {
          await FirebaseFirestore.instance.collection('notifications').add({
            'token': token,
            'title': 'New Tweet from $senderName',
            'body': tweetContent,
            'senderId': senderId,
            'timestamp': FieldValue.serverTimestamp(),
          });
        } catch (e) {
          print('Error sending notification: $e');
        }
      }
    } catch (e) {
      print('Error getting user tokens: $e');
    }
  }

  Future<void> showLocalNotification(String title, String body) async {
    const androidDetails = AndroidNotificationDetails(
      'local_channel',
      'Local Notifications',
      channelDescription: 'Notifications for local events',
      importance: Importance.max,
      priority: Priority.high,
    );

    const iOSDetails = DarwinNotificationDetails();

    const notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iOSDetails,
    );

    await _flutterLocalNotificationsPlugin.show(
      0,
      title,
      body,
      notificationDetails,
    );
  }
}
