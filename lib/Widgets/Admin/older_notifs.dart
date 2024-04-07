import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class OlderNotificationCArd extends StatelessWidget {
  const OlderNotificationCArd({
    Key? key,
    required this.questions,
    required this.questionResults,
    required this.snapshot, // Added snapshot parameter
    required this.index, // Added index parameter
  }) : super(key: key);

  final List questions;
  final Map<String, int> questionResults;
  final AsyncSnapshot snapshot; // Added snapshot parameter
  final int index; // Added index parameter

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        child: Column(
          children: [
            ListTile(
              title: Text(snapshot.data?.docs[index].data()["notification"]),
              trailing: IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () {
                  FirebaseFirestore.instance
                      .collection('notifications')
                      .doc(snapshot.data?.docs[index].id)
                      .delete();
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: List.generate(
                  questions.length,
                  (index) => Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "${questionResults[questions[index]]} answered\n${questions[index]}",
                      textAlign: TextAlign.start,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
