// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:aub_gymsystem/Logic/firebasehelper_class.dart';
import 'package:aub_gymsystem/Widgets/gym_calendar.dart';
import 'package:aub_gymsystem/constants.dart';

class ReservationPage extends StatefulWidget {
  const ReservationPage({
    Key? key,
    this.reservationType,
    this.trainerUid,
  }) : super(key: key);
  final String? reservationType;
  final String? trainerUid;

  @override
  State<ReservationPage> createState() => _ReservationPageState();
}

class _ReservationPageState extends State<ReservationPage> {
  final TimeOfDay startTime = const TimeOfDay(hour: 6, minute: 30);
  final TimeOfDay endTime = const TimeOfDay(hour: 21, minute: 30); // 9:30 PM

  int? selectedValue = 0;

  DateTime selectedDate = DateTime.now();

  List<int> spots = List.generate(10, (index) => 30);

// Function to update spots based on reservations for a selected date
  void updateSpots(DateTime selectedDate) {
    FirebaseHelperClass().getReservations().then(
      (value) {
        // Function to get date without time from Timestamp
        DateTime getDateOnlyFromTimestamp(Timestamp timestamp) {
          DateTime dateTime = timestamp.toDate();
          return DateTime(dateTime.year, dateTime.month, dateTime.day);
        }

        // Function to get date without time from DateTime
        DateTime getDateOnly(DateTime dateTime) {
          return DateTime(dateTime.year, dateTime.month, dateTime.day);
        }

        for (var element in value) {
          if (getDateOnlyFromTimestamp(element["date"]) ==
                  getDateOnly(selectedDate) &&
              element["active"] == true) {
            setState(
              () {
                if (spots[element["time"]] > 0) {
                  spots[element["time"]] = spots[element["time"]] - 1;
                } else {}
              },
            );
          }
        }
      },
    );
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
              'Your reservation has been successfully submitted at ${removeTime(selectedDate)} from ${ConstantsClass.timeSlots[selectedValue!]}'),
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
  void initState() {
    updateSpots(selectedDate);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Reservation"),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: ConstantsClass.secondaryColor,
        icon: const Icon(Icons.calendar_month),
        label: const Text(
          "Reserve",
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 18,
            color: Colors.black,
          ),
        ),
        onPressed: () {
          if (spots[selectedValue!] > 0) {
            FirebaseHelperClass()
                .postReservation(
              context: context,
              date: selectedDate,
              index: selectedValue!,
              name: widget.reservationType ?? "Gym Reservation",
              trainerId: widget.trainerUid,
            )
                .whenComplete(() {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                    "Reserved Successfully",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  backgroundColor: Colors.green,
                ),
              );
            });
          } else {
            FirebaseHelperClass().showReservationDialog(
                context, selectedDate, selectedValue!, "is fully booked");
          }
        },
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: GymCalendar(
              selectedDate: selectedDate,
              onSelection: (time1) {
                setState(
                  () {
                    selectedDate = time1;
                    setState(() {
                      spots = List.generate(10, (index) => 30);
                    });
                    updateSpots(time1);
                  },
                );
              },
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final timeSlot = ConstantsClass.timeSlots[index];
                return RadioListTile<int>(
                  value: index,
                  groupValue: selectedValue,
                  onChanged: (value) async {
                    setState(() {
                      selectedValue = value!;
                    });
                  },
                  title: Text(timeSlot),
                  subtitle: Text("${spots[index]} Spots left"),
                );
              },
              childCount: ConstantsClass.timeSlots.length,
            ),
          ),
        ],
      ),
    );
  }
}
