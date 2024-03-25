import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ComplaintsPage extends StatefulWidget {
  const ComplaintsPage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _ComplaintsPageState createState() => _ComplaintsPageState();
}

class _ComplaintsPageState extends State<ComplaintsPage> {
  final TextEditingController _complaintController = TextEditingController();

  void _submitComplaint() async {
    String complaint = _complaintController.text.trim();
    if (complaint.isNotEmpty) {
      String userId = FirebaseAuth.instance.currentUser!.uid;
      Map<String, dynamic> data = {
        'userId': userId,
        'complaint': complaint,
        'timestamp': FieldValue.serverTimestamp(),
      };
      try {
        await FirebaseFirestore.instance.collection('complaints').add(data);
        _complaintController.clear();
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Complaint submitted successfully!'),
          ),
        );
      } catch (error) {
        if (kDebugMode) {
          print('Error submitting complaint: $error');
        }
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content:
                Text('Error submitting complaint. Please try again later.'),
          ),
        );
      }
    } else {
      showCupertinoDialog(
        context: context,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: const Text('Error'),
            content: const Text('Please enter a complaint before submitting.'),
            actions: <Widget>[
              CupertinoDialogAction(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Submit Complaint'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _complaintController,
              maxLines: null, // Allows multiple lines
              decoration: const InputDecoration(
                hintText: 'Enter your complaint...',
              ),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _submitComplaint,
              child: const Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}
