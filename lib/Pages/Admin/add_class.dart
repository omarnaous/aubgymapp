import 'package:aub_gymsystem/Widgets/Admin/classes_stream.dart';
import 'package:aub_gymsystem/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:aub_gymsystem/Logic/firebasehelper_class.dart';
import 'package:aub_gymsystem/Widgets/sign_inbtn.dart';

class ScheduleClassorSession extends StatefulWidget {
  final bool istrainer;

  const ScheduleClassorSession({
    Key? key,
    required this.istrainer,
  }) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _ScheduleClassorSessionState createState() => _ScheduleClassorSessionState();
}

class _ScheduleClassorSessionState extends State<ScheduleClassorSession> {
  final TextEditingController _classNameController = TextEditingController();
  DateTime _selectedStartDate = DateTime.now();
  DateTime _selectedEndDate = DateTime.now();
  TimeOfDay _selectedStartTime = TimeOfDay.now();
  TimeOfDay _selectedEndTime = TimeOfDay.now();

  String repeatDay = 'Monday';

  selectClassStartDate() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null) {
      setState(() {
        _selectedStartDate = pickedDate;
      });
    }
  }

  selectClassEndDate() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null) {
      setState(() {
        _selectedEndDate = pickedDate;
      });
    }
  }

  selectStartTime() async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (pickedTime != null) {
      setState(() {
        _selectedStartTime = pickedTime;
      });
    }
  }

  selectEndTime() async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (pickedTime != null) {
      setState(() {
        _selectedEndTime = pickedTime;
      });
    }
  }

  String userId = '';

  Map<String, dynamic> userDataGlobal = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.istrainer == false ? 'Schedule Class' : 'Schedule Session',
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(3),
        child: Column(
          mainAxisAlignment: widget.istrainer == false
              ? MainAxisAlignment.spaceBetween
              : MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _classNameController,
                decoration: InputDecoration(
                  labelText: widget.istrainer == false
                      ? 'Class Name'
                      : 'Session Title',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () async {
                  selectClassStartDate();
                },
                child: Text(
                    'Start Date: ${_selectedStartDate.toString().split(' ')[0]}'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () async {
                  selectClassEndDate();
                },
                child: Text(
                    'End Date: ${_selectedEndDate.toString().split(' ')[0]}'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () async {
                  selectStartTime();
                },
                child:
                    Text('Start Time: ${_selectedStartTime.format(context)}'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () async {
                  selectEndTime();
                },
                child: Text('End Time: ${_selectedEndTime.format(context)}'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  buildDayButton('Monday'),
                  buildDayButton('Tuesday'),
                  buildDayButton('Wednesday'),
                  buildDayButton('Thursday'),
                  buildDayButton('Friday'),
                ],
              ),
            ),
            StreamBuilder<QuerySnapshot>(
              stream:
                  FirebaseFirestore.instance.collection('users').snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                }
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Text('No users found.');
                }

                return Column(
                  children:
                      snapshot.data!.docs.map((DocumentSnapshot document) {
                    Map<String, dynamic> userData =
                        document.data() as Map<String, dynamic>;
                    String selectedUserId = document.id;

                    userDataGlobal = userData;

                    if (userData["role"] == 'class instructor') {
                      return RadioListTile<String>(
                        title: Text(
                          userData['firstName'] + ' ' + userData["lastName"],
                        ), // Assuming 'name' is a field in the user document
                        value: selectedUserId,
                        groupValue: userId,
                        onChanged: (String? value) {
                          setState(() {
                            userId = value!;
                          });
                        },
                      );
                    } else {
                      return Container();
                    }
                  }).toList(),
                );
              },
            ),
            CustomElevatedButton(
              buttonText: widget.istrainer == false
                  ? "Schedule Class"
                  : 'Schedule Session',
              size: 18,
              onPressed: () {
                print(userDataGlobal);
                print(userDataGlobal['firstName'] +
                    ' ' +
                    userDataGlobal["lastName"]);
                // FirebaseHelperClass().addClass(
                //     context,
                //     _classNameController,
                //     _selectedStartDate,
                //     _selectedEndDate,
                //     _selectedStartTime,
                //     _selectedEndTime,
                //     'classes',
                //     selectedDays,
                //     userId,
                //     userDataGlobal['firstName'] +
                //         ' ' +
                //         userDataGlobal["lastName"]);
              },
            ),
          ],
        ),
      ),
    );
  }

  List<String> selectedDays = [];

  void toggleDay(String day) {
    setState(() {
      if (selectedDays.contains(day)) {
        selectedDays.remove(day);
      } else {
        selectedDays.add(day);
      }
    });
  }

  Widget buildDayButton(String day) {
    final isSelected = selectedDays.contains(day);

    return ElevatedButton(
      onPressed: () => toggleDay(day),
      style: ButtonStyle(
        backgroundColor: isSelected
            ? MaterialStateProperty.all(ConstantsClass.themeColor)
            : MaterialStateProperty.all(Colors.grey),
      ),
      child: Text(
        day,
        style: TextStyle(
          color: isSelected ? Colors.white : Colors.black,
        ),
      ),
    );
  }
}
