import 'package:aub_gymsystem/Models/classes_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AllClassList extends StatelessWidget {
  const AllClassList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Class List'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('classes').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No classes found.'));
          }

          // Extract class data from snapshot
          List<QueryDocumentSnapshot> classDocs = snapshot.data!.docs;

          return ListView.builder(
            itemCount: classDocs.length,
            itemBuilder: (context, index) {
              // Access document ID
              String docId = classDocs[index].id;

              // Create an instance of classModel
              ClassesModel classesModel = ClassesModel.fromMap(
                  classDocs[index].data() as Map<String, dynamic>);

              // Access classModel properties
              String className = classesModel.className;
              String instructorId = classesModel.instructorId;

              return FutureBuilder<String>(
                future: _getInstructorName(instructorId),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    String instructorName = snapshot.data ?? 'Unknown';
                    // Customize the UI as needed
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                        child: ListTile(
                          title: Text(className),
                          subtitle: Text(instructorName),
                          // Add more fields as needed
                          trailing: TextButton(
                            onPressed: () {
                              _showUnlockUserDialog(
                                  context, classesModel, docId);
                            },
                            child: const Text('Unlock User'),
                          ),
                        ),
                      ),
                    );
                  }
                },
              );
            },
          );
        },
      ),
    );
  }

  Future<String> _getInstructorName(String instructorId) async {
    try {
      DocumentSnapshot instructorSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(instructorId)
          .get();

      if (instructorSnapshot.exists) {
        Map<String, dynamic> userData = instructorSnapshot.data() as Map<String,
            dynamic>; // assuming user document contains 'firstName' and 'lastName' fields
        return '${userData['firstName']} ${userData['lastName']}';
      } else {
        return 'Unknown';
      }
    } catch (e) {
      print('Error fetching instructor data: $e');
      return 'Unknown';
    }
  }

  void _showUnlockUserDialog(
      BuildContext context, ClassesModel classesModel, String docId) {
    String userId = '';
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Unlock User'),
          content: TextField(
            onChanged: (value) {
              userId = value;
            },
            decoration: const InputDecoration(
              hintText: 'Enter User ID',
            ),
          ),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                // Update unlocked users list
                _updateUnlockedUsers(context, classesModel, userId, docId);
              },
              child: const Text('Unlock'),
            ),
          ],
        );
      },
    );
  }

  void _updateUnlockedUsers(BuildContext context, ClassesModel classesModel,
      String userId, String docId) {
    String formattedDate = DateFormat('yyyy-MM-dd').format(DateTime.now());

    // Perform the update operation here
    try {
      DocumentReference classDocRef =
          FirebaseFirestore.instance.collection('classes').doc(docId);

      classDocRef.update({
        'unlockedUsers': FieldValue.arrayUnion([
          {
            'userId': userId,
            'date': formattedDate,
          }
        ])
      }).then((value) {
        print('User unlocked successfully.');
        // Close the dialog
        Navigator.of(context).pop();
        // Show a confirmation message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('User unlocked successfully.'),
          ),
        );
      }).catchError((error) {
        print('Failed to unlock user: $error');
        // Show an error message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to unlock user. Please try again.'),
          ),
        );
      });
    } catch (e) {
      print('Error unlocking user: $e');
      // Show an error message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error unlocking user. Please try again.'),
        ),
      );
    }
  }
}
