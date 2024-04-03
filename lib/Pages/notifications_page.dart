import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({Key? key}) : super(key: key);

  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  final TextEditingController _answerController = TextEditingController();
  String? selectedRadioTile;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream:
            FirebaseFirestore.instance.collection('notifications').snapshots(),
        builder: (BuildContext context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          String formatTimestampToDate(Timestamp timestamp) {
            DateTime dateTime = timestamp.toDate();
            return '${dateTime.day}-${dateTime.month}-${dateTime.year}';
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (BuildContext context, int index) {
              DocumentSnapshot<Map<String, dynamic>> document =
                  snapshot.data!.docs[index];
              Map<String, dynamic> data = document.data()!;
              print(data["questions"]);

              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListTile(
                        title: Text(formatTimestampToDate(data["timestamp"])),
                        subtitle: Text(data['notification']),
                      ),
                      // MCQ Options
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: data["questions"].length,
                        itemBuilder: (BuildContext context, int index) {
                          return RadioListTile(
                            value: data["questions"][index],
                            groupValue: selectedRadioTile,
                            onChanged: (val) {
                              setState(() {
                                selectedRadioTile = val as String?;
                              });
                            },
                            title: Text(data['questions'][index]),
                          );
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                // Save the answer to Firestore
                                saveAnswer(document.id, selectedRadioTile);
                              },
                              child: const Text('Submit'),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  void saveAnswer(String documentId, String? answer) {
    if (answer != null) {
      // Get the current list of answers from Firestore
      FirebaseFirestore.instance
          .collection('notifications')
          .doc(documentId)
          .get()
          .then((DocumentSnapshot<Map<String, dynamic>> documentSnapshot) {
        if (documentSnapshot.exists) {
          List<Map<String, dynamic>> answers = List<Map<String, dynamic>>.from(
              documentSnapshot['answers'] ?? []);

          // Add the user's answer to the list
          answers.add({
            'userUid': FirebaseAuth.instance.currentUser?.uid,
            'answer': answer,
          });

          // Update the document with the new list of answers
          FirebaseFirestore.instance
              .collection('notifications')
              .doc(documentId)
              .update({
            'answers': answers,
          }).then((value) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Answer saved successfully!')),
            );
            setState(() {
              selectedRadioTile = null;
            });
          }).catchError((error) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Failed to save answer: $error')),
            );
          });
        }
      });
    }
  }

  @override
  void dispose() {
    _answerController.dispose();
    super.dispose();
  }
}
