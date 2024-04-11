import 'package:aub_gymsystem/Models/classes_model.dart';
import 'package:aub_gymsystem/Models/user_model.dart';
import 'package:aub_gymsystem/Widgets/gym_calendar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ClassList extends StatefulWidget {
  const ClassList({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _ClassListState createState() => _ClassListState();
}

class _ClassListState extends State<ClassList> {
  String? selectedClassName; // Variable to store the selected class name
  String? selectedDocId; // Variable to store the selected document ID
  DateTime selectedDate = DateTime.now();
  bool canReserve = true;

  void showReservationDialog(BuildContext context) {
    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: const Text('Reservation Details'),
          content:
              const Text('Your reservation has been successfully submitted!'),
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

  void _postReservation() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;

    if (user != null && selectedDocId != null) {
      String userUID = user.uid;
      String formattedDate = DateFormat('yyyy-MM-dd').format(selectedDate);

      try {
        // Create a reference to the reservations document
        DocumentReference reservationDocRef = FirebaseFirestore.instance
            .collection('classes')
            .doc(selectedDocId!);

        // Update the reservations list field in the document
        await reservationDocRef.update({
          'reservations': FieldValue.arrayUnion([
            {
              'userID': userUID,
              'date': formattedDate,
            }
          ])
        });

        // Show reservation dialog
        // ignore: use_build_context_synchronously
        showReservationDialog(context);
      } catch (e) {
        print('Error posting reservation: $e');
      }
    } else {
      print('No user logged in or no class selected');
    }
  }

  Future<List<Map<String, dynamic>>?> getAllUserData() async {
    try {
      // Get all documents from the users collection
      QuerySnapshot userSnapshots =
          await FirebaseFirestore.instance.collection('users').get();

      // Check if any documents exist
      if (userSnapshots.docs.isNotEmpty) {
        // Return the data as a list of maps with document IDs included
        return userSnapshots.docs.map((doc) {
          Map<String, dynamic> userData = doc.data() as Map<String, dynamic>;
          userData['id'] = doc.id; // Add the document ID to the map
          return userData;
        }).toList();
      } else {
        // Return null if no documents exist
        return null;
      }
    } catch (e) {
      // Handle any errors that occur during fetching
      print('Error fetching user data: $e');
      return null;
    }
  }

  Future<Map<String, dynamic>?> getUserDataById(String userId) async {
    // Fetch all user data
    List<Map<String, dynamic>>? allUserData = await getAllUserData();

    if (allUserData != null) {
      // Find the user data with the specified ID
      Map<String, dynamic>? userData = allUserData.firstWhere(
        (user) => user['id'] == userId,
      );

      return userData;
    } else {
      // Handle the case where no user data is available
      return null;
    }
  }

  Future<bool> isUserUnlocked(
      String userId, List<dynamic> unlockedUsers, DateTime selectedDate) async {
    // Fetch user data asynchronously
    Map<String, dynamic>? userData = await getUserDataById(userId);

    if (userData != null) {
      // Get the student ID from the user data
      String? studentId = userData['studentId'];

      if (studentId != null) {
        // Check if the student ID is present in the list of unlocked users
        bool isUnlocked = unlockedUsers.any((element) {
          String? unlockedUserId = element['userId'];
          String? unlockDateStr = element['date'];

          if (unlockedUserId != null &&
              unlockDateStr != null &&
              unlockedUserId == studentId) {
            DateTime unlockedDate = DateTime.parse(unlockDateStr);

            print(unlockedDate);

            DateTime oneMonthLater = unlockedDate.add(const Duration(days: 30));

            print(oneMonthLater);

            print(selectedDate);

            return selectedDate.isBefore(oneMonthLater);
          }
          return false;
        });

        return isUnlocked;
      }
    }

    return false; // Default to false if user data is not available
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Reservation"),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          if (canReserve == true) {
            _postReservation();
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content:
                    Text("No spots Available for this class.Fully Booked!"),
              ),
            );
          }
        },
        label: const Text(
          "Reserve Class",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: GymCalendar(
              selectedDate: selectedDate,
              onSelection: (time1) {
                setState(() {
                  selectedDate = time1;
                });
              },
            ),
          ),
          StreamBuilder<QuerySnapshot>(
            stream:
                FirebaseFirestore.instance.collection('classes').snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> classSnap) {
              if (classSnap.connectionState == ConnectionState.waiting) {
                return const SliverToBoxAdapter(
                  child: Center(child: CircularProgressIndicator()),
                );
              }
              if (classSnap.hasError) {
                return SliverToBoxAdapter(
                  child: Center(child: Text('Error: ${classSnap.error}')),
                );
              }
              if (!classSnap.hasData || classSnap.data!.docs.isEmpty) {
                return const SliverToBoxAdapter(
                  child: Center(child: Text('No classes found.')),
                );
              }

              return SliverList(
                delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                    Map<String, dynamic> data = classSnap.data!.docs[index]
                        .data() as Map<String, dynamic>;

                    ClassesModel classesModel = ClassesModel.fromMap(data);

                    DateTime startDate = classesModel.startDate.toDate();
                    DateTime endDate = classesModel.endDate.toDate();
                    bool isDaySelected(
                        DateTime date, List<String> repeatedDays) {
                      String dayOfWeek = DateFormat('EEEE')
                          .format(date); // Get the day of the week
                      return repeatedDays.contains(dayOfWeek);
                    }

                    if ((selectedDate.isAtSameMomentAs(startDate) ||
                            selectedDate.isAtSameMomentAs(endDate)) ||
                        (selectedDate.isAfter(startDate) &&
                            selectedDate.isBefore(endDate))) {
                      if (isDaySelected(
                          selectedDate, classesModel.repeatedDays)) {
                        int count = 30;

                        for (var element in classesModel.reservations) {
                          if (element["date"] ==
                              DateFormat('yyyy-MM-dd').format(selectedDate)) {
                            count -= 1;
                          }
                        }

                        return FutureBuilder<bool>(
                          future: isUserUnlocked(
                              FirebaseAuth.instance.currentUser!.uid,
                              classesModel.unlockedUsers,
                              selectedDate),
                          builder: (context, snapshot) {
                            if (snapshot.hasError) {
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Card(
                                  child: Text('Error: ${snapshot.error}'),
                                ),
                              );
                            }

                            if (snapshot.hasData == false) {
                              return Container();
                            }

                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Card(
                                child: RadioListTile<String>(
                                  title: Text(classesModel.className),
                                  subtitle: Text(
                                      '${classesModel.classInstructor} - $count spots left ${snapshot.data! ? 'Unlocked' : 'Locked'}'),
                                  value: classesModel.className,
                                  groupValue: selectedClassName,
                                  onChanged: snapshot.data!
                                      ? (String? value) {
                                          setState(() {
                                            selectedClassName = value;
                                            selectedDocId =
                                                classSnap.data!.docs[index].id;
                                          });
                                        }
                                      : null,
                                  secondary: snapshot.data!
                                      ? const Icon(Icons.lock_open)
                                      : const Icon(Icons.lock),
                                  // Add more fields as needed
                                ),
                              ),
                            );
                          },
                        );
                      } else {
                        return const SizedBox(); // Return an empty container if the class is not on the selected day
                      }
                    }
                    return Container();
                  },
                  childCount: classSnap.data!.docs.length,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
