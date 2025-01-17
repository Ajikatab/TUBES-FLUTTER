const functions = require('firebase-functions');
const admin = require('firebase-admin');
admin.initializeApp();

exports.sendTweetNotification = functions.firestore
    .document('notifications/{notificationId}')
    .onCreate(async (snap, context) => {
        const notification = snap.data();
        
        const message = {
            token: notification.token,
            notification: {
                title: notification.title,
                body: notification.body
            },
            data: {
                senderId: notification.senderId,
                click_action: 'FLUTTER_NOTIFICATION_CLICK'
            }
        };

        try {
            await admin.messaging().send(message);
            // Delete the notification document after sending
            await snap.ref.delete();
        } catch (error) {
            console.error('Error sending notification:', error);
        }
    }); 