// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:aub_gymsystem/Logic/firebasehelper_class.dart';
import 'package:aub_gymsystem/Widgets/gym_calendar.dart';
import 'package:aub_gymsystem/constants.dart';

class FacilitiesReservationPage extends StatefulWidget {
  const FacilitiesReservationPage({
    Key? key,
    required this.facilityName,
    required this.lanesNumber,
    required this.numberofSpots,
  }) : super(key: key);
  final String facilityName;
  final int lanesNumber;
  final int numberofSpots;

  @override
  State<FacilitiesReservationPage> createState() =>
      _FacilitiesReservationPageState();
}

class _FacilitiesReservationPageState extends State<FacilitiesReservationPage> {
  final TimeOfDay startTime = const TimeOfDay(hour: 6, minute: 30);

  final TimeOfDay endTime = const TimeOfDay(hour: 21, minute: 30); // 9:30 PM

  int? selectedValue = 0;

  DateTime selectedDate = DateTime.now();

  List<int> spots = [];

  int _activeLaneIndex = 0;

  void _setActiveLaneIndex(int index) {
    setState(() {
      _activeLaneIndex = index;
    });
  }

  List lanes = ["A", "B", "C", "D"];

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

        setState(
          () {
            for (var element in value) {
              if (getDateOnlyFromTimestamp(element["date"]) ==
                      getDateOnly(selectedDate) &&
                  lanes[_activeLaneIndex].toString() == element["lane"] &&
                  element["name"] == widget.facilityName) {
                spots[element["time"]] -= 1;
              }
            }
          },
        );
      },
    );
  }

  @override
  void initState() {
    updateSpots(selectedDate);
    spots = List.generate(10, (index) => widget.numberofSpots);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.facilityName} Reservation"),
      ),
      floatingActionButton: FloatingActionButton(
          backgroundColor: ConstantsClass.secondaryColor,
          child: Image.asset(
            ConstantsClass.reserve,
            fit: BoxFit.cover,
          ),
          onPressed: () {
            if (spots[selectedValue!] > 0) {
              FirebaseHelperClass()
                  .postReservation(
                context: context,
                date: selectedDate,
                name: widget.facilityName,
                index: selectedValue!,
                poolLane: lanes[_activeLaneIndex],
              )
                  .whenComplete(
                () {
                  FirebaseHelperClass().showReservationDialog(
                      context,
                      selectedDate,
                      selectedValue!,
                      "has been successfully submitted");
                },
              );
            } else {
              FirebaseHelperClass().showReservationDialog(
                  context, selectedDate, selectedValue!, "is fully booked");
            }
          }),
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
                      spots =
                          List.generate(10, (index) => widget.numberofSpots);
                    });
                    updateSpots(time1);
                  },
                );
              },
            ),
          ),
          SliverToBoxAdapter(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    widget.lanesNumber,
                    (index) => Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                        onPressed: () {
                          _setActiveLaneIndex(index);

                          setState(() {
                            spots = List.generate(
                                10, (index) => widget.numberofSpots);
                          });
                          updateSpots(selectedDate);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _activeLaneIndex == index
                              ? ConstantsClass.themeColor
                              : null,
                        ),
                        child: Text(
                          '${widget.facilityName} ${widget.facilityName == "Pool" ? 'Lane' : ''} ${lanes[index]}',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: _activeLaneIndex == index
                                  ? Colors.white
                                  : null),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final timeSlot = ConstantsClass.onehourtimeslot[index];
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
