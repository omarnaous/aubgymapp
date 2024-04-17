import 'package:aub_gymsystem/Pages/reserve_session.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TrainersPage extends StatefulWidget {
  const TrainersPage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _TrainersPageState createState() => _TrainersPageState();
}

class _TrainersPageState extends State<TrainersPage> {
  late String selectedTrainer = '';
  late String selectedTrainerUid = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Trainers'),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('trainers').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          List<DocumentSnapshot> trainers = snapshot.data!.docs;
          return ListView.builder(
            itemCount: trainers.length,
            itemBuilder: (BuildContext context, int index) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  child: ListTile(
                    title: Text(
                      trainers[index]['name'],
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: const Text(
                      "View Available Sessions",
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                    trailing: IconButton(
                        onPressed: () {
                          navigatetoReservePage(
                            context,
                            trainers[index]['name'],
                            trainers[index]["userId"]!,
                          );
                        },
                        icon: const Icon(Icons.arrow_forward_ios_rounded)),
                    onTap: () {
                      // Navigate to reserve session page
                      navigatetoReservePage(context, trainers[index]['name'],
                          trainers[index]["userId"]!);
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  // Function to navigate to the reserve session page
  void navigatetoReservePage(
      BuildContext context, String trainerName, String trainerUid) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) {
          return ReserverTrainerSession(
            uid: trainerUid,
          );
        },
      ),
    );
  }
}
