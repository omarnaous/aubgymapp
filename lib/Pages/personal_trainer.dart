import 'package:aub_gymsystem/Pages/reserve_session.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TrainersPage extends StatefulWidget {
  const TrainersPage({Key? key});

  @override
  // ignore: library_private_types_in_public_api
  _TrainersPageState createState() => _TrainersPageState();
}

class _TrainersPageState extends State<TrainersPage> {
  late String _selectedTrainer = '';
  late String _selectedTrainerUid = '';

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
                  child: RadioListTile<String>(
                    title: Text(trainers[index]['name']),
                    value: trainers[index]['name'],
                    groupValue: _selectedTrainer,
                    onChanged: (String? value) {
                      setState(() {
                        _selectedTrainer = value!;
                        _selectedTrainerUid = trainers[index]["userId"]!;
                      });
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (_selectedTrainer.isNotEmpty) {
            // Perform reservation action with selected trainer
            navigatetoReservePage(
                context, _selectedTrainer, _selectedTrainerUid);
          } else {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text('Please select a trainer to reserve.'),
            ));
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  // Function to reserve the selected trainer
  void navigatetoReservePage(
      BuildContext context, String trainerName, String trainerUid) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) {
          return ReserveSession(
            uid: trainerUid,
          );
        },
      ),
    );
  }
}
