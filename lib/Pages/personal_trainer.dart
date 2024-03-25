import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart'; // Import the url_launcher package

class TrainersPage extends StatelessWidget {
  const TrainersPage({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Trainers'),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('trainers').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          List<DocumentSnapshot> trainers = snapshot.data!.docs;
          return ListView.builder(
            itemCount: trainers.length,
            itemBuilder: (BuildContext context, int index) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  child: ListTile(
                    leading: const Icon(Icons.person),
                    title: Text(trainers[index]['name']),
                    subtitle: Text(trainers[index]['number']),
                    trailing: const Icon(Icons.phone),
                    onTap: () => _callNumber(
                        context,
                        trainers[index]
                            ['number']), // Call _callNumber function on tap
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  // Function to call the phone number
  _callNumber(BuildContext context, String phoneNumber) async {
    String telScheme = 'tel:$phoneNumber';
    // ignore: deprecated_member_use
    if (await canLaunch(telScheme)) {
      // ignore: deprecated_member_use
      await launch(telScheme);
    } else {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Unable to make a call'),
      ));
    }
  }
}
