import 'package:cloud_firestore/cloud_firestore.dart';

class ClassesModel {
  final String className;
  final String classTime;
  final Timestamp date;
  final List? attendees;

  ClassesModel({
    required this.className,
    required this.classTime,
    required this.date,
    required this.attendees, // Include attendees in the constructor
  });

  factory ClassesModel.fromJson(Map<String, dynamic> json) {
    // Convert attendees from dynamic to List<String>

    return ClassesModel(
      className: json['className'],
      classTime: json['startTime'],
      date: json['date'],
      attendees: json["attendees"] ?? [],
    );
  }

  String formatDate() {
    // Convert timestamp to DateTime
    DateTime dateTime = date.toDate();

    // Format DateTime to desired format: day.month/year
    String formattedDate =
        '${dateTime.day.toString().padLeft(2, '0')}.${dateTime.month.toString().padLeft(2, '0')}/${dateTime.year}';

    return formattedDate;
  }
}
