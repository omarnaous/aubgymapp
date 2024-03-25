// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';

class UserClassModel {
  final String email;
  final String firstName;
  final String lastName;
  final String studentId;
  final String phoneNumber;
  final bool locked;
  final String role;
  final Timestamp? endDate;

  UserClassModel({
    this.endDate,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.studentId,
    required this.phoneNumber,
    required this.locked,
    required this.role,
  });

  factory UserClassModel.fromJson(Map<String, dynamic> json) {
    return UserClassModel(
      endDate: json["endDate"],
      email: json['email'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      studentId: json['studentId'],
      phoneNumber: json['phoneNumber'],
      locked: json["locked"],
      role: json["role"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'studentId': studentId,
      'phoneNumber': phoneNumber,
    };
  }
}
