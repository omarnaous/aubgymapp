import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EnterGymScreen extends StatefulWidget {
  const EnterGymScreen({Key? key}) : super(key: key);

  @override
  State<EnterGymScreen> createState() => _EnterGymScreenState();
}

class _EnterGymScreenState extends State<EnterGymScreen> {
  final TextEditingController _idController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Enter Gym'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: _idController,
                decoration: const InputDecoration(
                  labelText: 'Enter your ID number',
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  final user = FirebaseAuth.instance.currentUser;
                  if (user != null) {
                    final id = _idController.text.trim();
                    final userId = user.uid;
                    await FirebaseFirestore.instance
                        .collection('tracker')
                        .doc(userId)
                        .set({
                      'id': id,
                      'userId': userId,
                    });
                    // ignore: use_build_context_synchronously
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('You Enterred the Gym!')),
                    );
                    _idController.clear();
                    // ignore: use_build_context_synchronously
                    Navigator.of(context).pop();
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('User not authenticated')),
                    );
                  }
                },
                child: const Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
