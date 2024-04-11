// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:aub_gymsystem/Logic/firebasehelper_class.dart';
import 'package:aub_gymsystem/Models/classes_model.dart';
import 'package:aub_gymsystem/Pages/class_attendees.dart';
import 'package:aub_gymsystem/constants.dart';

class ClassesorSessionsStreambuilder extends StatefulWidget {
  const ClassesorSessionsStreambuilder({
    Key? key,
  }) : super(key: key);

  @override
  State<ClassesorSessionsStreambuilder> createState() =>
      _ClassesorSessionsStreambuilderState();
}

class _ClassesorSessionsStreambuilderState
    extends State<ClassesorSessionsStreambuilder> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('classes').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                final doc = snapshot.data!.docs[index];

                // ClassesModel classesModel =
                //     ClassesModel.fromJson(doc.data() as Map<String, dynamic>);

                return Container();

                // return Padding(
                //   padding: const EdgeInsets.all(8.0),
                //   child: Card(
                //     elevation: 3,
                //     child: Column(
                //       children: [
                //         ListTile(
                //           title: Text(classesModel.className),
                //           subtitle: Text(
                //               '${classesModel.formatDate()} ${classesModel.classTime}'),
                //           trailing: IconButton(
                //             icon: const Icon(Icons.delete),
                //             onPressed: () => FirebaseHelperClass()
                //                 .deleteClass(doc.id, context),
                //             color: ConstantsClass.themeColor,
                //           ),
                //         ),
                //         Row(
                //           mainAxisAlignment: MainAxisAlignment.center,
                //           children: [
                //             if (FirebaseAuth.instance.currentUser?.email ==
                //                 'aubadmin@gmail.com')
                //               TextButton(
                //                 onPressed: () {
                //                   FirebaseHelperClass()
                //                       .addClassAttendeeDialog(context, doc.id);
                //                 },
                //                 child: const Text("Add User"),
                //               ),
                //             TextButton(
                //               onPressed: () {
                //                 Navigator.of(context).push(MaterialPageRoute(
                //                     builder: (BuildContext context) {
                //                   return AttendeeSelectionPage(
                //                     attendeesId: classesModel.attendees ?? [],
                //                   );
                //                 }));
                //               },
                //               child: const Text("View Attendees"),
                //             ),
                //           ],
                //         )
                //       ],
                //     ),
                //   ),
                // );
              },
            );
          } else {
            return const Center(child: Text('No classes available'));
          }
        },
      ),
    );
  }
}
