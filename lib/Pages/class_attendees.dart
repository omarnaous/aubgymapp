import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AttendeeSelectionPage extends StatelessWidget {
  final List attendeesId;

  const AttendeeSelectionPage({
    Key? key,
    required this.attendeesId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Attendees'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .where('studentId', whereIn: attendeesId)
            .snapshots(), // Filter users based on attendeesId list
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No users found.'));
          }

          List<DocumentSnapshot> users = snapshot.data!.docs;

          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              var user = users[index];

              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  child: CheckboxListTile(
                    title: Text('${user['firstName']} ${user['lastName']}'),
                    value: attendeesId.contains(user.id),
                    onChanged: (value) {
                      // Handle attendee selection logic here
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
