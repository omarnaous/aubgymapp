// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';

class ClassesModel {
  final String className;
  final Timestamp startDate;
  final Timestamp endDate;
  final String startTime;
  final String endTime;
  final List<String> repeatedDays;
  final String instructorId;
  final List reservations;
  final List unlockedUsers;
  final String classInstructor;

  ClassesModel({
    required this.className,
    required this.startDate,
    required this.endDate,
    required this.startTime,
    required this.endTime,
    required this.repeatedDays,
    required this.instructorId,
    required this.reservations,
    required this.unlockedUsers,
    required this.classInstructor,
  });

  factory ClassesModel.fromMap(Map<String, dynamic> map) {
    return ClassesModel(
        className: map['className'],
        startDate: map['startDate'] ?? Timestamp.now(),
        endDate: map['endDate'] ?? Timestamp.now(),
        startTime: map['startTime'] ?? '',
        endTime: map['endTime'] ?? '',
        repeatedDays: List<String>.from(map['repeatedDays'] ?? []),
        instructorId: map['instructorId'] ?? '',
        reservations: map['reservations'] ?? [],
        unlockedUsers: map['unlockedUsers'] ?? [],
        classInstructor: map['classInstructor'] ?? '');
  }
}
