import 'package:aub_gymsystem/constants.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PersonalTrainerReservationPanel extends StatefulWidget {
  const PersonalTrainerReservationPanel({Key? key});

  @override
  State<PersonalTrainerReservationPanel> createState() =>
      _PersonalTrainerReservationPanelState();
}

class _PersonalTrainerReservationPanelState
    extends State<PersonalTrainerReservationPanel> {
  // Function to update reservation status to cancelled
  Future<void> cancelReservation(String reservationId) async {
    try {
      await FirebaseFirestore.instance
          .collection('reservations')
          .doc(reservationId)
          .update({'active': false});
      // Show snackbar or toast indicating successful cancellation
    } catch (error) {
      // Handle error
      print('Error cancelling reservation: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Personal Trainer Reservations'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('reservations')
            .where('trainerId',
                isEqualTo: FirebaseAuth.instance.currentUser?.uid)
            .where('active', isEqualTo: true) // Filter active reservations
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text('No active reservations found.'),
            );
          }
          // If there are reservations, display them
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              var reservation = snapshot.data!.docs[index];

              String clientName = reservation['name'];
              String reservationId = reservation.id;

              Timestamp reservationDate = reservation['date'] as Timestamp;

              // Convert Timestamp to DateTime
              DateTime dateTime = reservationDate.toDate();

              // Format date as day/month/year
              String formattedDate =
                  '${dateTime.day}/${dateTime.month}/${dateTime.year} at ${ConstantsClass.timeSlots[reservation["time"]]}';

              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  child: ListTile(
                    title: Text(clientName),
                    subtitle: Text(formattedDate),
                    trailing: ElevatedButton(
                      onPressed: () {
                        // Call function to cancel reservation

                        cancelReservation(reservationId);
                      },
                      child: const Text('Cancel'),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
