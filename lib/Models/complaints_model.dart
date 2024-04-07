import 'package:cloud_firestore/cloud_firestore.dart';

class ComplaintMessageModel {
  final String complaint;
  final String userId;
  final DateTime timestamp;

  ComplaintMessageModel({
    required this.complaint,
    required this.userId,
    required this.timestamp,
  });

  // Factory method to convert Firestore data to EquipmentComplaint object
  factory ComplaintMessageModel.fromMap(Map<String, dynamic> map) {
    return ComplaintMessageModel(
      complaint: map['complaint'],
      userId: map['userId'],
      timestamp: (map['timestamp'] as Timestamp).toDate(),
    );
  }

  // Method to convert EquipmentComplaint object to Firestore data
  Map<String, dynamic> toMap() {
    return {
      'complaint': complaint,
      'userId': userId,
      'timestamp': timestamp,
    };
  }
}
