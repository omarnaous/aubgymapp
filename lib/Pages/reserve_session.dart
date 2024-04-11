import 'package:aub_gymsystem/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:aub_gymsystem/Models/classes_model.dart';

class ReserveSession extends StatefulWidget {
  final String uid;

  const ReserveSession({
    Key? key,
    required this.uid,
  }) : super(key: key);

  @override
  State<ReserveSession> createState() => _ReserveSessionState();
}

class _ReserveSessionState extends State<ReserveSession> {
  String? selectedSessionId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reserve Session'),
      ),
      floatingActionButton: FloatingActionButton(
          backgroundColor: ConstantsClass.secondaryColor,
          child: Image.asset(
            ConstantsClass.reserve,
            fit: BoxFit.cover,
          ),
          onPressed: () {
            // FirebaseHelperClass()
            //     .postReservation(
            //   context: context,
            //   date: selectedDate,
            //   index: selectedValue!,
            //   name: widget.reservationType ?? "Gym Reservation",
            //   trainerId: widget.trainerUid,
            // )
            //     .whenComplete(() {
            //   FirebaseHelperClass().showReservationDialog(context, selectedDate,
            //       selectedValue!, "has been successfully submitted");
            // });
          }),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('sessions')
            .where('instructorId', isEqualTo: widget.uid)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
                child: Text('No sessions found for this user.'));
          }
          return Container();

          // return Column(
          //   children: snapshot.data!.docs.map((DocumentSnapshot session) {
          //     ClassesModel classesModel =
          //         ClassesModel.fromJson(session.data() as Map<String, dynamic>);

          //     DateTime getDateOnlyFromTimestamp(Timestamp timestamp) {
          //       DateTime dateTime = timestamp.toDate();
          //       return DateTime(dateTime.year, dateTime.month, dateTime.day);
          //     }

          //     // Function to format DateTime to string with date, month, and year
          //     String formatDate(DateTime dateTime) {
          //       DateFormat formatter = DateFormat('dd/MM/yyyy');
          //       return formatter.format(dateTime);
          //     }

          //     // Use session data to build UI components
          //     return Padding(
          //       padding: const EdgeInsets.all(8.0),
          //       child: Card(
          //         child: RadioListTile<String>(
          //           title: Text(classesModel.className),
          //           subtitle: Text(
          //             formatDate(
          //               getDateOnlyFromTimestamp(classesModel.date),
          //             ),
          //           ),
          //           value: session.id,
          //           groupValue: selectedSessionId,
          //           onChanged: (value) {
          //             setState(() {
          //               selectedSessionId = value;
          //             });
          //           },
          //         ),
          //       ),
          //     );
          //   }).toList(),
          // );
        },
      ),
    );
  }
}
