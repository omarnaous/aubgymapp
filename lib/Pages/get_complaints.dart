import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class GetComplaintsPage extends StatefulWidget {
  const GetComplaintsPage({super.key});

  @override
  State<GetComplaintsPage> createState() => _GetComplaintsPageState();
}

class _GetComplaintsPageState extends State<GetComplaintsPage> {
  String formatDate(Timestamp timestamp) {
    // Convert Timestamp to DateTime
    DateTime dateTime = timestamp.toDate();

    // Format DateTime to a regular date format (day, month, year)
    String formattedDate = DateFormat('dd/MM/yyyy').format(dateTime);

    return formattedDate;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Complaints'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('complaints')
            .orderBy('timestamp',
                descending: true) // Order by timestamp in descending order
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No complaints available'));
          }
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              QueryDocumentSnapshot<Map<String, dynamic>> complaintDoc =
                  snapshot.data!.docs[index]
                      as QueryDocumentSnapshot<Map<String, dynamic>>;
              String userId = complaintDoc['userId'] as String;
              return FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                future: FirebaseFirestore.instance
                    .collection('users')
                    .doc(userId)
                    .get(),
                builder: (context, userSnapshot) {
                  if (userSnapshot.connectionState == ConnectionState.waiting) {
                    return const SizedBox(); // Show nothing while waiting for user data
                  }
                  if (userSnapshot.hasError) {
                    return Text('Error: ${userSnapshot.error}');
                  }
                  if (!userSnapshot.hasData) {
                    return const SizedBox(); // Show nothing if user data not available
                  }
                  Map<String, dynamic> userData = userSnapshot.data!.data()!;
                  String userName =
                      '${userData['firstName']} ${userData['lastName']}';
                  String complaint = complaintDoc['complaint'] as String;
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                        child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Text(
                                    userName, // Display user name as title
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Text(
                                    'Date: ${formatDate(complaintDoc["timestamp"])}', // Display formatted date
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Text(
                                    complaint,
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                ),
                              ],
                            ))),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
