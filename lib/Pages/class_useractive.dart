import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserClassesReserved extends StatefulWidget {
  const UserClassesReserved({Key? key}) : super(key: key);

  @override
  State<UserClassesReserved> createState() => _UserClassesReservedState();
}

class _UserClassesReservedState extends State<UserClassesReserved> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Class Reservations"),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('classes').snapshots(),
        builder: (context, snapshot) {
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
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text('No classes found.'),
            );
          }

          // Return a CustomScrollView to display all class information
          return CustomScrollView(
            slivers: [
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    var classData = snapshot.data!.docs[index].data()
                        as Map<String, dynamic>;

                    // Extract class name and reservations
                    String className = classData['className'] as String;
                    List<Map<String, dynamic>> reservations =
                        (classData['reservations'] as List<dynamic>)
                            .cast<Map<String, dynamic>>();

                    // Filter reservations by current user's ID
                    List<Map<String, dynamic>> userReservations = reservations
                        .where((reservation) =>
                            reservation['userID'] ==
                            FirebaseAuth.instance.currentUser!.uid)
                        .toList();

                    // Build a Column for each class
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ListTile(
                              title: Text(
                                className,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                            // Build Text for each reservation
                            ...userReservations.map((reservation) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 4.0, horizontal: 16.0),
                                child: Text(
                                  'Date: ${reservation['date']}',
                                ),
                              );
                            }).toList(),
                          ],
                        ),
                      ),
                    );
                  },
                  childCount: snapshot.data!.docs.length,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
