import 'package:aub_gymsystem/Logic/firebasehelper_class.dart';
import 'package:aub_gymsystem/Widgets/gym_calendar.dart';
import 'package:aub_gymsystem/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
  @override
  void initState() {
    FirebaseFirestore.instance.collection('classes').get().then((value) {
      for (var element in value.docChanges) {
        classesNames.add(element.doc.data()?["className"]);
      }
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
          // if (classesNames.isNotEmpty)
          //   Padding(
          //     padding: const EdgeInsets.all(20.0),
          //     child: Column(
          //       crossAxisAlignment: CrossAxisAlignment.stretch,
          //       children: [
          //         DropdownButton<String>(
          //           items: classesNames.toList().map((String value) {
          //             return DropdownMenuItem<String>(
          //               value: value,
          //               child: Text(value),
          //             );
          //           }).toList(),
          //           onChanged: (newItem) {
          //             setState(() {});
          //             classSelected =
          //                 classesNames.toList().indexOf(newItem ?? "");
          //           },
          //           hint: Text(classesNames.toList()[classSelected]),
          //         ),
          //       ],
          //     ),
          //   ),
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
                      final doc = snapshot.data!.docs[index];
                      final className = doc['className'];
                      final classTime = doc['startTime'];
                      final date = doc['date'];

                      DateTime getDateOnlyFromTimestamp(Timestamp timestamp) {
                        DateTime dateTime = timestamp.toDate();
                        return DateTime(
                          dateTime.year,
                          dateTime.month,
                          dateTime.day,
                        );
                      }

                      DateTime getDateOnly(DateTime dateTime) {
                        return DateTime(
                          dateTime.year,
                          dateTime.month,
                          dateTime.day,
                        );
                      }

                      if (getDateOnlyFromTimestamp(date)
                              .isBefore(getDateOnly(selectedDate)) !=
                          true) {
                        return ReservationCard(
                          title: className,
                          date:
                              "${getDateOnlyFromTimestamp(date).day}/${getDateOnlyFromTimestamp(date).month}/${getDateOnlyFromTimestamp(date).year} $classTime",
                          spotsLeft: spots[index],
                          onPressed: () {
                            // Handle reservation button press
                            FirebaseHelperClass()
                                .postReservation(
                              context: context,
                              index: index,
                              date: selectedDate,
                              name: className,
                            )
                                .whenComplete(() {
                              showReservationDialog(context);
                            });
                          },
                        );
                      } else {
                        // Return an empty container if the condition is not met
                        return Container();
                      }
                    },
                  );
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

class ReservationCard extends StatelessWidget {
  final String title;
  final String date;
  final int spotsLeft;
  final VoidCallback onPressed;

  const ReservationCard({
    Key? key,
    required this.title,
    required this.date,
    required this.spotsLeft,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: ListTile(
        title: Text(title),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(date),
            Text("$spotsLeft Spots left"),
          ],
        ),
        trailing: ElevatedButton(
          onPressed: onPressed,
          child: const Text("Reserve"),
        ),
      ),
    );
  }
}
