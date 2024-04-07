import 'package:aub_gymsystem/Logic/firebasehelper_class.dart';
import 'package:flutter/material.dart';

class ComplaintsPage extends StatefulWidget {
  const ComplaintsPage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _ComplaintsPageState createState() => _ComplaintsPageState();
}

class _ComplaintsPageState extends State<ComplaintsPage> {
  final TextEditingController _complaintController = TextEditingController();

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
              onPressed: () {
                FirebaseHelperClass()
                    .submitComplaint(_complaintController, context);
              },
              child: const Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}
