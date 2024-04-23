import 'package:aub_gymsystem/Logic/firebasehelper_class.dart';
import 'package:aub_gymsystem/Models/user_model.dart';
import 'package:aub_gymsystem/Pages/class_list.dart';
import 'package:aub_gymsystem/Pages/enter_gym.dart';
import 'package:aub_gymsystem/Pages/facilities_page.dart';
import 'package:aub_gymsystem/Pages/gym_reserve.dart';
import 'package:aub_gymsystem/Pages/personal_trainer.dart';
import 'package:aub_gymsystem/Pages/tutorials_page.dart';
import 'package:aub_gymsystem/Widgets/welcome_banner.dart';
import 'package:aub_gymsystem/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Widget> navigationList = [
    const EnterGymScreen(),
    Container(),
    const ReservationPage(),
    const FacilitiesPage(),
    const ClassList(),
    const TrainersPage(),
    const TutorialsPage()
  ];

  @override
  void initState() {
    super.initState();
    checkAndUpdateUserStatus();
  }

  Future<void> checkAndUpdateUserStatus() async {
    final currentDate = DateTime.now();
    final userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .get();

    if (userDoc.exists) {
      final userData = userDoc.data() as Map<String, dynamic>;
      final endDateTimestamp = userData['endDate'] as Timestamp?;

      if (endDateTimestamp != null) {
        final endDate = endDateTimestamp.toDate();
        if (endDate.isBefore(currentDate)) {
          // Update user status to locked
          await FirebaseFirestore.instance
              .collection('users')
              .doc(FirebaseAuth.instance.currentUser?.uid)
              .update({'locked': true});
        } else {}
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return SafeArea(
      child: StreamBuilder<DocumentSnapshot>(
          stream: FirebaseHelperClass().userSnapshotStream,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              UserClassModel userClassModel = UserClassModel.fromJson(
                  snapshot.data!.data() as Map<String, dynamic>);
              return CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: WelcomeUserBanner(
                      fullName:
                          "${userClassModel.firstName} ${userClassModel.lastName}",
                      userID: userClassModel.studentId,
                      date: userClassModel.endDate != null
                          ? DateFormat('dd/MM/yyyy')
                              .format(userClassModel.endDate!.toDate())
                          : '',
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('tracker')
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Padding(
                            padding: EdgeInsets.all(12.0),
                            child: CircularProgressIndicator(),
                          );
                        } else if (snapshot.hasError) {
                          return Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Text(
                              'Error: ${snapshot.error}',
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          );
                        } else {
                          final count = snapshot.data?.docs.length ?? 0;
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Card(
                                child: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Text(
                                    '$count People currently in the Gym',
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                        }
                      },
                    ),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.all(12.0),
                    sliver: SliverGrid(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 12.0,
                        mainAxisSpacing: 12.0,
                      ),
                      delegate: SliverChildBuilderDelegate(
                        (BuildContext context, int index) {
                          return GestureDetector(
                            onTap: () async {
                              if (userClassModel.locked && index != 4) {
                              } else {
                                if (index == 1) {
                                  // Delete document logic
                                  Future<void> deleteDocument(
                                      String collectionName,
                                      String documentId) async {
                                    try {
                                      await FirebaseFirestore.instance
                                          .collection(collectionName)
                                          .doc(documentId)
                                          .delete();
                                    } catch (e) {
                                      // Handle error
                                    }
                                  }

                                  deleteDocument('tracker',
                                      FirebaseAuth.instance.currentUser!.uid);
                                } else {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) {
                                        return navigationList[index];
                                      },
                                    ),
                                  );
                                }
                              }
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Card(
                                color: ConstantsClass.secondaryColor,
                                child: SizedBox(
                                  height: height * 0.07,
                                  child: Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        if (userClassModel.locked && index != 4)
                                          const Icon(
                                            Icons.lock,
                                            size: 40,
                                          ),
                                        Text(
                                          ConstantsClass
                                              .homePageListItems[index]
                                              .toString(),
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                            fontSize: 22,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                        childCount: ConstantsClass.homePageListItems.length,
                      ),
                    ),
                  ),
                ],
              );
            } else {
              return Container();
            }
          }),
    );
  }
}
