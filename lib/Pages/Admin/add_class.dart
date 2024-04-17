import 'package:aub_gymsystem/Widgets/Admin/classes_stream.dart';
import 'package:aub_gymsystem/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:aub_gymsystem/Logic/firebasehelper_class.dart';
import 'package:aub_gymsystem/Widgets/sign_inbtn.dart';

class ScheduleClassorSession extends StatefulWidget {
  final bool istrainer;

  const ScheduleClassorSession({
    Key? key,
    required this.istrainer,
  }) : super(key: key);

  @override
  _ScheduleClassorSessionState createState() => _ScheduleClassorSessionState();
}

class _ScheduleClassorSessionState extends State<ScheduleClassorSession> {
  final TextEditingController _classNameController = TextEditingController();
  DateTime _selectedStartDate = DateTime.now();
  DateTime _selectedEndDate = DateTime.now();
  TimeOfDay _selectedStartTime = TimeOfDay.now();
  TimeOfDay _selectedEndTime = TimeOfDay.now();

  String repeatDay = 'Monday';

  late String userId; // Change userId to be non-nullable

  List<String> selectedDays = [];

  late Stream<QuerySnapshot> _userStream; // Declare the stream variable

  @override
  void initState() {
    super.initState();
    // Initialize userId with the ID of the first instructor found
    _userStream = FirebaseFirestore.instance.collection('users').snapshots();
    _userStream.listen((snapshot) {
      for (DocumentSnapshot doc in snapshot.docs) {
        Map<String, dynamic> userData = doc.data() as Map<String, dynamic>;
        if (userData["role"] == 'class instructor') {
          userId = doc.id;
          break;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _userStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Text('No users found.');
        }

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
                widget.istrainer == false
                    ? Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                          onPressed: () async {
                            selectClassEndDate();
                          },
                          child: Text(
                              'End Date: ${_selectedEndDate.toString().split(' ')[0]}'),
                        ),
                      )
                    : Container(),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: () async {
                      selectStartTime();
                    },
                    child: Text(
                        'Start Time: ${_selectedStartTime.format(context)}'),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: () async {
                      selectEndTime();
                    },
                    child:
                        Text('End Time: ${_selectedEndTime.format(context)}'),
                  ),
                ),
                widget.istrainer == false
                    ? Padding(
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
                      )
                    : Container(),
                widget.istrainer == false
                    ? Column(
                        children: snapshot.data!.docs
                            .map((DocumentSnapshot document) {
                          Map<String, dynamic> userData =
                              document.data() as Map<String, dynamic>;
                          String selectedUserId = document.id;

                          if (userData["role"] == 'class instructor') {
                            return RadioListTile<String>(
                              title: Text(
                                userData['firstName'] +
                                    ' ' +
                                    userData["lastName"],
                              ),
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
                      )
                    : Container(),
                CustomElevatedButton(
                  buttonText: widget.istrainer == false
                      ? "Schedule Class"
                      : 'Schedule Session',
                  size: 18,
                  onPressed: () {
                    // Check if class name is not empty
                    if (_classNameController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Please enter a class name.'),
                        ),
                      );
                      return; // Stop further execution
                    }

                    // Check if start date is before end date
                    if (_selectedStartDate.isAfter(_selectedEndDate)) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Start date cannot be after end date.'),
                        ),
                      );
                      return; // Stop further execution
                    }

                    // Check if start time is before end time
                    if (_selectedStartTime.hour > _selectedEndTime.hour ||
                        (_selectedStartTime.hour == _selectedEndTime.hour &&
                            _selectedStartTime.minute >=
                                _selectedEndTime.minute)) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Start time cannot be after end time.'),
                        ),
                      );
                      return; // Stop further execution
                    }

                    // Check if at least one day is selected
                    if (selectedDays.isEmpty && widget.istrainer == false) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Please select at least one day.'),
                        ),
                      );
                      return; // Stop further execution
                    }

                    // Check if userId is not empty
                    if (userId.isEmpty && widget.istrainer == false) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('No instructor selected.'),
                        ),
                      );
                      return; // Stop further execution
                    }

                    // If all checks passed, proceed to add the class
                    Map<String, dynamic> data =
                        getDocumentData(userId, snapshot.data!)
                            as Map<String, dynamic>;

                    String firstName = data["firstName"];
                    String lastName = data["lastName"];

                    widget.istrainer
                        ? updatePTSessions(
                            FirebaseAuth.instance.currentUser!.uid,
                            {
                              'sessionName': _classNameController.text,
                              'startDate': _selectedStartDate,
                              // 'endDate': _selectedEndDate,
                              'startTime': _selectedStartTime.format(context),
                              'endTime': _selectedEndTime.format(context),
                            },
                          ).whenComplete(() {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Session added successfully.'),
                                duration: Duration(
                                    seconds:
                                        2), // Adjust the duration as needed
                              ),
                            );
                          })
                        : FirebaseHelperClass().addClass(
                            context,
                            _classNameController,
                            _selectedStartDate,
                            _selectedEndDate,
                            _selectedStartTime,
                            _selectedEndTime,
                            'classes',
                            selectedDays,
                            userId,
                            firstName + lastName);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> updatePTSessions(
      String documentId, Map<String, dynamic> reservationsToUpdate) async {
    try {
      // Reference to the document
      DocumentReference documentReference =
          FirebaseFirestore.instance.collection('trainers').doc(documentId);

      // Update the reservations field with the new list
      await documentReference.update({
        'sessions': FieldValue.arrayUnion([reservationsToUpdate]),
      });

      print('Reservations updated successfully.');
    } catch (error) {
      print('Error updating reservations: $error');
      throw error; // Throw the error for handling in UI if needed
    }
  }

  Object? getDocumentData(String targetDocId, QuerySnapshot snapshot) {
    DocumentSnapshot? targetDoc;
    for (DocumentSnapshot doc in snapshot.docs) {
      if (doc.id == targetDocId) {
        targetDoc = doc;
        break;
      }
    }

    if (targetDoc != null) {
      return targetDoc.data();
    } else {
      return null;
    }
  }

  void selectClassStartDate() async {
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

  void selectClassEndDate() async {
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

  void selectStartTime() async {
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

  void selectEndTime() async {
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
