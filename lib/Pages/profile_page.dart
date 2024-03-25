// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:aub_gymsystem/Pages/add_class.dart';
import 'package:aub_gymsystem/Pages/add_trainer.dart';
import 'package:aub_gymsystem/Pages/manage_user.dart';
import 'package:aub_gymsystem/Widgets/logout_column.dart';
import 'package:aub_gymsystem/Widgets/user_profile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:aub_gymsystem/Logic/firebasehelper_class.dart';
import 'package:aub_gymsystem/Models/user_model.dart';
import 'package:aub_gymsystem/Pages/get_complaints.dart';
import 'package:aub_gymsystem/Pages/get_reservations.dart';
import 'package:aub_gymsystem/Pages/my_reserve.dart';
import 'package:aub_gymsystem/Pages/send_complaints.dart';
import 'package:aub_gymsystem/Pages/send_notif.dart';
import 'package:aub_gymsystem/constants.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final List<String> widgetTitles = [
    "My Reservations",
    "Complaints",
    "Change Password",
  ];
  final List<IconData> icons = const [
    CupertinoIcons.calendar,
    Icons.message,
    Icons.lock
  ];
  final List<String> adminTitle = [
    "Reservations",
    "Manage Users",
    "Complaints",
    "Send Notifications",
    "Schedule Class",
    "Add Trainer",
  ];
  final List<IconData> adminIcons = const [
    CupertinoIcons.calendar,
    Icons.person,
    Icons.message,
    Icons.notification_add,
    Icons.schedule,
    Icons.add,
  ];

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
              child: StreamBuilder<DocumentSnapshot>(
            stream: FirebaseHelperClass().userSnapshotStream,
            builder: (BuildContext context,
                AsyncSnapshot<DocumentSnapshot> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Container(); // Show loading indicator while fetching data
              }

              if (snapshot.hasData) {
                // Access user data from snapshot
                Map<String, dynamic> userData =
                    snapshot.data!.data() as Map<String, dynamic>;

                UserClassModel userClassModel =
                    UserClassModel.fromJson(userData);

                // Build UI with user data
                return Container(
                  color: ConstantsClass.themeColor,
                  height: height * 0.33,
                  child: SafeArea(
                      child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const CircleAvatar(
                        radius: 40,
                        child: Icon(
                          Icons.person,
                          size: 40,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Text(
                          "${userClassModel.firstName} ${userClassModel.lastName}",
                          style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 22),
                        ),
                      ),
                      Text(
                        userClassModel.email,
                        style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                            fontSize: 18),
                      ),
                    ],
                  )),
                );
              } else {
                return Container();
              }
            },
          )),
          if (FirebaseAuth.instance.currentUser?.email != "aubadmin@gmail.com")
            UserProfileWidgets(
              icons: icons,
              widgetTitles: widgetTitles,
              navigationWidget: const [
                MyReservations(),
                ComplaintsPage(),
              ],
              isUser: true,
            )
          else
            UserProfileWidgets(
              icons: adminIcons,
              widgetTitles: adminTitle,
              navigationWidget: const [
                AllUsersReservations(),
                ManageUsersPage(),
                GetComplaintsPage(),
                SendNotifcations(),
                ScheduleClass(),
                AddTrainerPage()
              ],
              isUser: false,
            ),
          if (FirebaseAuth.instance.currentUser?.email != "aubadmin@gmail.com")
            const SliverToBoxAdapter(child: LogoutColumn(isUser: true))
          else
            const SliverToBoxAdapter(child: LogoutColumn(isUser: false))
        ],
      ),
    );
  }
}
