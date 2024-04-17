import 'package:aub_gymsystem/Models/session_model.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PersonalTrainerReservationPanel extends StatefulWidget {
  const PersonalTrainerReservationPanel({Key? key}) : super(key: key);

  @override
  State<PersonalTrainerReservationPanel> createState() =>
      _PersonalTrainerReservationPanelState();
}

class _PersonalTrainerReservationPanelState
    extends State<PersonalTrainerReservationPanel> {
  String? selectedDocId;
  int? selectedSessionId;

  @override
  void initState() {
    super.initState();
    // Initialize selectedDocId and selectedSessionId
    selectedDocId = '';
    selectedSessionId = 0;
  }

  // Function to update reservation status to cancelled
  Future<void> cancelReservation(String docId) async {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Personal Trainer Reservations'),
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('trainers')
            .doc(FirebaseAuth.instance.currentUser
                ?.uid) // Document ID is the current user's UID
            .snapshots(),
        builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }
          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(
              child: Text('No active reservations found.'),
            );
          }

          Map<String, dynamic> data =
              snapshot.data?.data() as Map<String, dynamic>;
          List sessions = data["sessions"];

          return ListView.builder(
            itemCount: sessions.length,
            itemBuilder: (context, index) {
              SessionModel sessionModel = SessionModel.fromMap(sessions[index]);

              if (sessionModel.reserved == true) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    child: ListTile(
                      title: Text(sessionModel.sessionName,
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          StreamBuilder<DocumentSnapshot>(
                            stream: FirebaseFirestore.instance
                                .collection('users')
                                .doc(sessionModel
                                    .reservedBy) // User ID from sessionModel
                                .snapshots(),
                            builder: (context,
                                AsyncSnapshot<DocumentSnapshot> userSnapshot) {
                              if (userSnapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Text(
                                    'Loading...'); // Show loading indicator
                              }
                              if (!userSnapshot.hasData ||
                                  !userSnapshot.data!.exists) {
                                return const Text(
                                    'User not found'); // Show message if user not found
                              }

                              // Extract user data from snapshot
                              Map<String, dynamic> userData = userSnapshot.data
                                  ?.data() as Map<String, dynamic>;

                              // Display user information
                              return Text(
                                  'Reserved by ${userData['firstName']} ${userData['lastName']}');
                            },
                          ),
                          Text(
                            'Date: ${sessionModel.formattedDate()}',
                          ),
                          Text(
                            'Time: ${sessionModel.startTime} - ${sessionModel.endTime}',
                          ),
                        ],
                      ),
                      trailing: ElevatedButton(
                        onPressed: () {
                          sessions[index]["reserved"] = false;
                          sessions[index]["reservedBy"] = null;

                          FirebaseFirestore.instance
                              .collection('trainers')
                              .doc(snapshot.data?.id)
                              .update({'sessions': sessions});

                          // Call function to cancel reservation
                          // cancelReservation(sessionModel.id);
                        },
                        child: const Text('Cancel'),
                      ),
                    ),
                  ),
                );
              }
            },
          );
        },
      ),
    );
  }
}
