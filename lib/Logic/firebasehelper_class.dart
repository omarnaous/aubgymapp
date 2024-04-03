import 'package:aub_gymsystem/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class FirebaseHelperClass {
  final Stream<QuerySnapshot> classesSnapshotStream =
      FirebaseFirestore.instance.collection('classes').snapshots();
  Stream<DocumentSnapshot<Map<String, dynamic>>> userSnapshotStream =
      FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .snapshots();
  final Stream<QuerySnapshot<Map<String, dynamic>>> reservationsSnapshots =
      FirebaseFirestore.instance.collection('reservations').snapshots();

  void deleteAccountPrompt(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: const Text('Delete Account?'),
          content: const Text('Are you sure you want to delete your account?'),
          actions: <Widget>[
            CupertinoDialogAction(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            CupertinoDialogAction(
              onPressed: () async {
                // Delete the user account
                User? user = FirebaseAuth.instance.currentUser;
                if (user != null) {
                  try {
                    await user.delete();
                    // ignore: use_build_context_synchronously
                    Navigator.of(context).pop();
                    // Optionally, navigate to a different page or show a confirmation message
                  } catch (e) {
                    if (kDebugMode) {
                      print('Failed to delete account: $e');
                    }
                    // Handle errors here
                  }
                }
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  void showresetPass(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: const Text('Change Password?'),
          content: const Text('Are you sure you want to change your password? '
              'A confirmation email will be sent to your email address.'),
          actions: <Widget>[
            CupertinoDialogAction(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            CupertinoDialogAction(
              onPressed: () async {
                Navigator.of(context).pop();
                User? user = FirebaseAuth.instance.currentUser;
                if (user != null) {
                  try {
                    await FirebaseAuth.instance
                        .sendPasswordResetEmail(email: user.email!);
                    // Show confirmation message or navigate to a different page
                    // ignore: use_build_context_synchronously
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return CupertinoAlertDialog(
                          title: const Text('Email Sent'),
                          content: const Text(
                              'A password reset link has been sent to your email address.'),
                          actions: <Widget>[
                            CupertinoDialogAction(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text('OK'),
                            ),
                          ],
                        );
                      },
                    );
                    // Dismiss the confirmation dialog
                  } catch (e) {
                    if (kDebugMode) {
                      print('Failed to send password reset email: $e');
                    }
                    // Handle errors here
                  }
                }
              },
              child: const Text('Change Password'),
            ),
          ],
        );
      },
    );
  }

  Future<void> postReservation(
      {required int index,
      required DateTime date,
      required String name,
      required BuildContext context,
      String? trainerId,
      String? poolLane}) async {
    try {
      // Get the reference to the "reservations" collection
      CollectionReference reservationsCollection =
          FirebaseFirestore.instance.collection('reservations');

      // Add the new reservation to the "reservations" collection
      await reservationsCollection.add({
        'date': date,
        'time': index,
        'userId': FirebaseAuth.instance.currentUser?.uid,
        'active': true,
        'name': name,
        'lane': poolLane,
        'trainerId': trainerId
      });

      // Show a success message or navigate to a different page
    } catch (e) {
      // Show an error message
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error saving reservation: $e'),
        ),
      );
    }
  }

  Future<List<Map<String, dynamic>>> getReservations() async {
    try {
      // Get the reference to the "reservations" collection
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('reservations').get();

      // Extract reservations data along with document IDs
      List<Map<String, dynamic>> reservations = [];
      for (var doc in querySnapshot.docs) {
        Map<String, dynamic> reservationData =
            doc.data() as Map<String, dynamic>;
        reservationData['id'] =
            doc.id; // Add document ID to the reservation data
        reservations.add(reservationData);
      }

      return reservations;
    } catch (e) {
      if (kDebugMode) {
        print('Error retrieving reservations: $e');
      }
      return [];
    }
  }

  void showReservationDialog(BuildContext context, DateTime selectedDate,
      int selectedValue, String text) {
    String removeTime(DateTime dateTime) {
      return '${dateTime.year}-${dateTime.month}-${dateTime.day}';
    }

    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: const Text('Reservation Details'),
          content: Text(
              'This reservation $text at ${removeTime(selectedDate)} from ${ConstantsClass.timeSlots[selectedValue]}'),
          actions: <Widget>[
            CupertinoDialogAction(
              child: const Text('Close'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> updateAttendeesList(
      String docId, String attendeeId, BuildContext context) async {
    try {
      await FirebaseFirestore.instance.collection('classes').doc(docId).update({
        'attendees': FieldValue.arrayUnion([attendeeId]),
      });
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Attendee added successfully')),
      );
    } catch (error) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error adding attendee: $error')),
      );
    }
  }

  Future<void> addClass(
      BuildContext context,
      TextEditingController classNameController,
      DateTime selectedDate,
      TimeOfDay selectedStartTime,
      TimeOfDay selectedEndTime) async {
    try {
      if (classNameController.text.isNotEmpty) {
        await FirebaseFirestore.instance.collection('classes').add({
          'className': classNameController.text,
          'date': selectedDate,
          'startTime':
              'From ${selectedStartTime.format(context)} to ${selectedEndTime.format(context)} ',
        });
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Class Added successfully')),
        );
        classNameController.clear();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please fill in all fields')),
        );
      }
    } catch (error) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error adding document: $error')),
      );
    }
  }

  Future<void> deleteClass(String documentId, BuildContext context) async {
    try {
      await FirebaseFirestore.instance
          .collection('classes')
          .doc(documentId)
          .delete();
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Class deleted successfully')),
      );
    } catch (error) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error deleting document: $error')),
      );
    }
  }

  Future<void> addClassAttendeeDialog(
      BuildContext context, String docId) async {
    String attendeeId = '';

    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add Attendee'),
          content: SingleChildScrollView(
            child: TextField(
              onChanged: (value) => attendeeId = value,
              decoration: const InputDecoration(labelText: 'Enter Attendee ID'),
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                await FirebaseHelperClass()
                    .updateAttendeesList(docId, attendeeId, context);
                // ignore: use_build_context_synchronously
                Navigator.of(context).pop();
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  void addTrainer(BuildContext context, String name, String userId) async {
    if (name.isNotEmpty && userId.isNotEmpty) {
      try {
        await FirebaseFirestore.instance
            .collection('trainers')
            .doc(userId) // Set the document ID to the user's UID
            .set({
          'name': name,
          'userId': userId,
        });
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Trainer added successfully')),
        );
      } catch (error) {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error adding trainer: $error')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields')),
      );
    }
  }

  void deleteTrainer(String documentId, BuildContext context) async {
    try {
      await FirebaseFirestore.instance
          .collection('trainers')
          .doc(documentId)
          .delete();
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Trainer deleted successfully')),
      );
    } catch (error) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error deleting trainer: $error')),
      );
    }
  }
}
