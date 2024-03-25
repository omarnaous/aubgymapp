import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SendNotifcations extends StatefulWidget {
  const SendNotifcations({Key? key}) : super(key: key);

  @override
  State<SendNotifcations> createState() => _SendNotifcationsState();
}

class _SendNotifcationsState extends State<SendNotifcations> {
  final TextEditingController _notificationController = TextEditingController();

  Future<void> _sendNotification(String notificationMessage) async {
    try {
      // Get a reference to the Firestore collection
      CollectionReference notifications =
          FirebaseFirestore.instance.collection('notifications');

      // Add a new document with a generated ID
      await notifications.add({
        'notification': notificationMessage,
        'timestamp': FieldValue.serverTimestamp(),
      });

      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Notification sent successfully!'),
        ),
      );
    } catch (error) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error sending notification. Please try again later.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Send Notification'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _notificationController,
              maxLines: null,
              decoration: const InputDecoration(
                hintText: 'Enter notification message...',
              ),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                String notificationMessage =
                    _notificationController.text.trim();
                if (notificationMessage.isNotEmpty) {
                  _sendNotification(notificationMessage);
                  _notificationController.clear();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please enter a notification message.'),
                    ),
                  );
                }
              },
              child: const Text('Send Notification'),
            ),
          ],
        ),
      ),
    );
  }
}
