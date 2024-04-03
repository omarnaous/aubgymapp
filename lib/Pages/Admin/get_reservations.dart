import 'package:flutter/material.dart';
import 'package:aub_gymsystem/Logic/firebasehelper_class.dart';
import 'package:aub_gymsystem/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AllUsersReservations extends StatefulWidget {
  const AllUsersReservations({Key? key}) : super(key: key);

  @override
  State<AllUsersReservations> createState() => _AllUsersReservationsState();
}

class _AllUsersReservationsState extends State<AllUsersReservations> {
  late Stream<QuerySnapshot<Map<String, dynamic>>> _reservationsStream;
  String _filterText = '';

  @override
  void initState() {
    super.initState();
    _reservationsStream = FirebaseHelperClass().reservationsSnapshots;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Today's Reservations"),
      ),
      body: Column(
        children: [
          TextField(
            onChanged: (value) {
              setState(() {
                _filterText = value;
              });
            },
            decoration: const InputDecoration(
              labelText: 'Filter by name',
              prefixIcon: Icon(Icons.search),
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: _reservationsStream,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text('No Reservations'));
                }

                return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    DocumentSnapshot<Map<String, dynamic>> doc =
                        snapshot.data!.docs[index];
                    Map<String, dynamic> reservationData = doc.data()!;
                    String userId = reservationData['userId'];

                    return FutureBuilder<DocumentSnapshot>(
                      future: FirebaseFirestore.instance
                          .collection('users')
                          .doc(userId)
                          .get(),
                      builder: (context, userSnapshot) {
                        if (userSnapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const SizedBox();
                        }
                        if (userSnapshot.hasError) {
                          return Text('Error: ${userSnapshot.error}');
                        }
                        if (!userSnapshot.hasData) {
                          return const SizedBox();
                        }

                        String userName = userSnapshot.data!['firstName'] +
                            '' +
                            userSnapshot.data!['lastName'];

                        if (!_filterUser(userName)) {
                          return const SizedBox();
                        }

                        Timestamp dateTime = reservationData["date"];
                        DateTime reservationDate = dateTime.toDate();
                        DateTime today = DateTime.now();

                        if (reservationDate.year == today.year &&
                            reservationDate.month == today.month &&
                            reservationDate.day == today.day) {
                          int timeIndex = reservationData["time"];
                          String formattedDate =
                              '${reservationDate.day}/${reservationDate.month}/${reservationDate.year}';

                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Card(
                              child: Column(
                                children: [
                                  ListTile(
                                    title: Text(
                                        '$userName (${reservationData["name"]})'),
                                    subtitle: Text(
                                        '$formattedDate from ${ConstantsClass.timeSlots[timeIndex]}'),
                                  ),
                                ],
                              ),
                            ),
                          );
                        } else {
                          return const SizedBox();
                        }
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  bool _filterUser(String userName) {
    return _filterText.isEmpty ||
        userName.toLowerCase().contains(_filterText.toLowerCase());
  }
}
