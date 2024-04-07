import 'package:aub_gymsystem/Models/complaints_model.dart';
import 'package:aub_gymsystem/Models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';

class GetComplaintsPage extends StatefulWidget {
  const GetComplaintsPage({super.key});

  @override
  State<GetComplaintsPage> createState() => _GetComplaintsPageState();
}

class _GetComplaintsPageState extends State<GetComplaintsPage> {
  String formatDate(Timestamp timestamp) {
    DateTime dateTime = timestamp.toDate();

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
            itemCount: snapshot.data?.docs.length,
            itemBuilder: (BuildContext context, int index) {
              Map<String, dynamic> data =
                  snapshot.data?.docs[index].data() as Map<String, dynamic>;
              ComplaintMessageModel complaintMessageModel =
                  ComplaintMessageModel.fromMap(data);
              var userDoc = FirebaseFirestore.instance
                  .collection('users')
                  .doc(complaintMessageModel.userId);

              Future<String> getUserFullName() async {
                try {
                  var documentSnapshot = await userDoc.get();
                  if (documentSnapshot.exists) {
                    var userData = documentSnapshot.data();
                    UserClassModel userClassModel = UserClassModel.fromJson(
                        userData as Map<String, dynamic>);
                    return '${userClassModel.firstName} ${userClassModel.lastName}';
                  } else {
                    return 'User with ID does not exist';
                  }
                } catch (error) {
                  return 'Error getting user data: $error';
                }
              }

              return Card(
                child: ListTile(
                  title: FutureBuilder<String>(
                      future: getUserFullName(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return Text(snapshot.data ?? '');
                        } else {
                          return const Text('');
                        }
                      }),
                  subtitle: Text(complaintMessageModel.complaint),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
