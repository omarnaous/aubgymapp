import 'dart:math';

import 'package:aub_gymsystem/Logic/firebasehelper_class.dart';
import 'package:aub_gymsystem/Models/classes_model.dart';
import 'package:aub_gymsystem/Widgets/gym_calendar.dart';
import 'package:aub_gymsystem/Widgets/reservationclass_card.dart';
import 'package:aub_gymsystem/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ClassList extends StatefulWidget {
  const ClassList({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _ClassListState createState() => _ClassListState();
}

class _ClassListState extends State<ClassList> {
  Set<String> classesNames = {};
  int classSelected = 0;
  String userId = '';
  @override
  void initState() {
    FirebaseFirestore.instance.collection('classes').get().then((value) {
      for (var element in value.docChanges) {
        classesNames.add(element.doc.data()?["className"]);
      }
    });

    FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .snapshots()
        .listen((event) {
      setState(() {
        userId = event.data()?["studentId"];
      });
    });

    super.initState();
  }

  DateTime selectedDate = DateTime.now();
  List<int> spots = List.generate(10, (index) => 30);

  void updateSpots(DateTime selectedDate, String className) {
    FirebaseHelperClass().getReservations().then((value) {
      DateTime getDateOnlyFromTimestamp(Timestamp timestamp) {
        DateTime dateTime = timestamp.toDate();
        return DateTime(dateTime.year, dateTime.month, dateTime.day);
      }

      DateTime getDateOnly(DateTime dateTime) {
        return DateTime(dateTime.year, dateTime.month, dateTime.day);
      }

      setState(() {
        spots = List.generate(10, (index) => 30);
      });

      for (var element in value) {
        if (getDateOnlyFromTimestamp(element["date"]) ==
                getDateOnly(selectedDate) &&
            element["name"] == className) {
          setState(() {
            spots[element["time"]] = spots[element["time"]] - 1;
          });
        }
      }
    });
  }

  void showReservationDialog(BuildContext context) {
    String removeTime(DateTime dateTime) {
      return '${dateTime.year}-${dateTime.month}-${dateTime.day}';
    }

    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: const Text('Reservation Details'),
          content: Text(
              'Your reservation has been successfully submitted at ${removeTime(selectedDate)} from ${ConstantsClass.timeSlots[selectedDate.hour]}:${selectedDate.minute}'),
          actions: <Widget>[
            CupertinoDialogAction(
              child: const Text('Close'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Reservation"),
      ),
      body: Column(
        children: [
          GymCalendar(
            selectedDate: selectedDate,
            onSelection: (time1) {
              setState(() {
                selectedDate = time1;
                updateSpots(selectedDate, classesNames.toList()[classSelected]);
              });
            },
          ),
          Expanded(
            child: FutureBuilder<QuerySnapshot>(
              future: FirebaseFirestore.instance.collection('classes').get(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
                  return ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        Map<String, dynamic> data = snapshot.data?.docs[index]
                            .data() as Map<String, dynamic>;

                        ClassesModel classesModel = ClassesModel.fromJson(data);

                        String selectedFormattedDate =
                            '${selectedDate.day}.${selectedDate.month}.${selectedDate.year}';

                        String classesModelFormattedDate =
                            '${classesModel.date.toDate().day}.${classesModel.date.toDate().month}.${classesModel.date.toDate().year}';

                        if (selectedFormattedDate ==
                            classesModelFormattedDate) {
                          if (classesModel.attendees != null) {
                            String userIdString =
                                userId.toString(); // Convert userId to string
                            if (classesModel.attendees!
                                .contains(userIdString)) {
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ReservationCard(
                                  locked: false,
                                  title: classesModel.className,
                                  date:
                                      "${classesModel.formatDate()} ${classesModel.classTime}",
                                  spotsLeft: spots[index],
                                  onPressed: () {
                                    // Handle reservation button press
                                    FirebaseHelperClass()
                                        .postReservation(
                                      context: context,
                                      index: index,
                                      date: selectedDate,
                                      name: classesModel.className,
                                    )
                                        .whenComplete(() {
                                      showReservationDialog(context);
                                    });
                                  },
                                ),
                              );
                            } else {
                              return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: ReservationCard(
                                    locked: true,
                                    title: classesModel.className,
                                    date:
                                        "${classesModel.formatDate()} ${classesModel.classTime}",
                                    spotsLeft: spots[index],
                                    onPressed: () {
                                      // Handle reservation button press
                                      FirebaseHelperClass()
                                          .postReservation(
                                        context: context,
                                        index: index,
                                        date: selectedDate,
                                        name: classesModel.className,
                                      )
                                          .whenComplete(() {
                                        showReservationDialog(context);
                                      });
                                    },
                                  ));
                            }
                          }
                        } else {
                          return SizedBox(
                            height: MediaQuery.of(context).size.height * 0.35,
                            child: const Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("No Classes Available at this Date")
                              ],
                            ),
                          );
                        }
                      });
                } else {
                  return Container(
                    alignment: Alignment.center,
                    child: const Text('No classes available for selected date'),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
