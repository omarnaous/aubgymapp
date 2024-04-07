import 'package:aub_gymsystem/Logic/firebasehelper_class.dart';
import 'package:aub_gymsystem/Widgets/Admin/classes_stream.dart';
import 'package:aub_gymsystem/Widgets/sign_inbtn.dart';
import 'package:flutter/material.dart';

class ScheduleClass extends StatefulWidget {
  const ScheduleClass({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _ScheduleClassState createState() => _ScheduleClassState();
}

class _ScheduleClassState extends State<ScheduleClass> {
  final TextEditingController _classNameController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedStartTime = TimeOfDay.now();
  TimeOfDay _selectedEndTime = TimeOfDay.now();

  selectClassDate() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Schedule Class'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(3),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _classNameController,
                decoration: const InputDecoration(labelText: 'Class Name'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () async {
                  selectClassDate();
                },
                child: Text('Date: ${_selectedDate.toString().split(' ')[0]}'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () async {
                  selectStartTime();
                },
                child: Text('Time: ${_selectedStartTime.format(context)}'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () async {
                  selectEndTime();
                },
                child: Text('Time: ${_selectedEndTime.format(context)}'),
              ),
            ),
            CustomElevatedButton(
              buttonText: "Schedule Class",
              size: 18,
              onPressed: () {
                FirebaseHelperClass().addClass(
                  context,
                  _classNameController,
                  _selectedDate,
                  _selectedStartTime,
                  _selectedEndTime,
                );
              },
            ),
            const Divider(),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                "Current Active Classes:",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
            const ClassesStreambuilder()
          ],
        ),
      ),
    );
  }
}
