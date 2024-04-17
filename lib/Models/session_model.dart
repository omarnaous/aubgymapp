import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class SessionModel {
  final String sessionName;
  final DateTime startDate;
  final String startTime;
  final String endTime;
  final bool? reserved;
  final String? reservedBy;

  SessionModel({
    required this.sessionName,
    required this.startDate,
    required this.startTime,
    required this.endTime,
    this.reserved,
    this.reservedBy,
  });

  factory SessionModel.fromMap(Map<String, dynamic> map) {
    Timestamp startTimestamp = map['startDate'];

    return SessionModel(
      sessionName: map['sessionName'] ?? '',
      startDate: startTimestamp.toDate(),
      startTime: map['startTime'] ?? '',
      endTime: map['endTime'] ?? '',
      reserved: map['reserved'] ?? false,
      reservedBy: map['reservedby'],
    );
  }

  Map<String, dynamic> toMap() {
    Timestamp startDateTimestamp = Timestamp.fromDate(startDate);

    return {
      'startTime': startTime,
      'endTime': endTime,
      'startDate': startDateTimestamp,
      'sessionName': sessionName,
      'reserved': reserved,
      'reservedby': reservedBy,
    };
  }

  String formattedDate() {
    return DateFormat('dd/MM/yyyy').format(startDate);
  }
}
