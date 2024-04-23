import 'package:aub_gymsystem/Models/session_model.dart';
import 'package:aub_gymsystem/Widgets/gym_calendar.dart';
import 'package:aub_gymsystem/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ReserverTrainerSession extends StatefulWidget {
  final String uid;

  const ReserverTrainerSession({
    Key? key,
    required this.uid,
  }) : super(key: key);

  @override
  State<ReserverTrainerSession> createState() => _ReserverTrainerSessionState();
}

class _ReserverTrainerSessionState extends State<ReserverTrainerSession> {
  int? selectedSessionId;
  String? selectedDocId;
  SessionModel? selectedSessionModel;
  DateTime _selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reserve Session'),
      ),
      floatingActionButton: FloatingActionButton.extended(
          backgroundColor: ConstantsClass.secondaryColor,
          icon: const Icon(Icons.calendar_month),
          label: const Text(
            "Reserve",
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 18,
              color: Colors.black,
            ),
          ),
          onPressed: () async {
            if (selectedSessionModel != null && selectedDocId != null) {
              try {
                FirebaseFirestore.instance
                    .collection('trainers')
                    .doc(selectedDocId)
                    .get()
                    .then((value) {
                  List sessions = value.data()?["sessions"];

                  // Check if selectedSessionId is valid and within the range of sessions
                  if (selectedSessionId != null &&
                      selectedSessionId! < sessions.length) {
                    // Update the session data
                    sessions[selectedSessionId!]['reserved'] = true;
                    sessions[selectedSessionId!]['reservedby'] =
                        FirebaseAuth.instance.currentUser?.uid;

                    // Update the sessions data in Firestore
                    FirebaseFirestore.instance
                        .collection('trainers')
                        .doc(selectedDocId)
                        .update({'sessions': sessions}).then((_) {
                      // Optionally, you can show a success message
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Session Reserved successfully'),
                          backgroundColor: Colors.green,
                        ),
                      );
                    }).catchError((error) {
                      // Show a snackbar with the error message
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Error: $error'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    });
                  } else {
                    // Show a snackbar indicating invalid session selection
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Invalid session selection'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                });
              } catch (error) {
                // Show a snackbar with the error message
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Error: $error'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            }
          }),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('trainers').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text('No sessions found.'),
            );
          }

          return CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: GymCalendar(
                  selectedDate: _selectedDate,
                  onSelection: (date) {
                    setState(() {
                      _selectedDate = date;
                    });
                  },
                ),
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                    final DocumentSnapshot trainerDoc =
                        snapshot.data!.docs[index];
                    final Map<String, dynamic> trainerData =
                        trainerDoc.data() as Map<String, dynamic>;
                    final List<dynamic> sessions = trainerData['sessions'];

                    final SessionModel sessionModel =
                        SessionModel.fromMap(sessions[index]);

                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                        child: RadioListTile<int>(
                          title: Text(
                            sessionModel.sessionName,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: sessionModel.reserved ?? false
                                  ? Colors.grey
                                  : Colors.black,
                            ),
                          ),
                          value: index,
                          groupValue: selectedSessionId,
                          subtitle: Text(
                            'From ${sessionModel.startTime} till ${sessionModel.endTime}${sessionModel.reserved ?? false ? '\nSession Reserved' : ''}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: sessionModel.reserved ?? false
                                  ? Colors.grey
                                  : Colors.black,
                            ),
                          ),
                          onChanged: sessionModel.reserved ?? false
                              ? null
                              : (int? value) {
                                  setState(() {
                                    selectedDocId = trainerDoc.id;
                                    selectedSessionId = value;
                                    selectedSessionModel = sessionModel;
                                  });
                                },
                          activeColor: ConstantsClass.secondaryColor,
                          controlAffinity: ListTileControlAffinity.trailing,
                        ),
                      ),
                    );
                  },
                  childCount: snapshot.data!.docs.length,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
