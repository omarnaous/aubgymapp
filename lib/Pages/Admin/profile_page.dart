import 'package:aub_gymsystem/Pages/Admin/pt_reservations.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:aub_gymsystem/Pages/Admin/add_class.dart';
import 'package:aub_gymsystem/Pages/Admin/manage_user.dart';
import 'package:aub_gymsystem/Widgets/logout_column.dart';
import 'package:aub_gymsystem/Widgets/user_profile.dart';
import 'package:aub_gymsystem/Logic/firebasehelper_class.dart';
import 'package:aub_gymsystem/Models/user_model.dart';
import 'package:aub_gymsystem/Pages/Admin/get_complaints.dart';
import 'package:aub_gymsystem/Pages/Admin/get_reservations.dart';
import 'package:aub_gymsystem/Pages/my_reserve.dart';
import 'package:aub_gymsystem/Pages/send_complaints.dart';
import 'package:aub_gymsystem/Pages/Admin/send_notif.dart';
import 'package:aub_gymsystem/constants.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

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
    Icons.calendar_today,
    Icons.message,
    Icons.lock,
  ];
  final List<String> adminTitle = [
    "Reservations",
    "Manage Users",
    "Complaints",
    "Send Notifications",
    "Schedule Class",
    // "Add Trainer",
  ];
  final List<IconData> adminIcons = const [
    Icons.calendar_today,
    Icons.person,
    Icons.message,
    Icons.notifications_active,
    Icons.schedule,
    // Icons.person_add,
  ];

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseHelperClass().userSnapshotStream,
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (!snapshot.hasData) {
          return const Scaffold(
            body: Center(
              child: Text('No user data available'),
            ),
          );
        }

        Map<String, dynamic> userData =
            snapshot.data!.data() as Map<String, dynamic>;
        UserClassModel userClassModel = UserClassModel.fromJson(userData);

        return Scaffold(
          body: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Container(
                  color: ConstantsClass.themeColor,
                  height: MediaQuery.of(context).size.height * 0.33,
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
                              fontSize: 22,
                            ),
                          ),
                        ),
                        Text(
                          userClassModel.email,
                          style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              if (userClassModel.role == "personal trainer")
                const UserProfileWidgets(
                  icons: [Icons.calendar_month],
                  widgetTitles: ["Reservations"],
                  navigationWidget: [
                    PersonalTrainerReservationPanel(),
                  ],
                  isUser: false,
                )
              else if (userClassModel.role == "class instructor")
                const UserProfileWidgets(
                  icons: [Icons.calendar_month],
                  widgetTitles: ["My Classes"],
                  navigationWidget: [
                    ScheduleClass(),
                  ],
                  isUser: false,
                )
              else if (FirebaseAuth.instance.currentUser?.email !=
                  "aubadmin@gmail.com")
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
                    SendNotificationsPage(),
                    ScheduleClass(),
                    // AddTrainerPage(),
                  ],
                  isUser: false,
                ),
              if (FirebaseAuth.instance.currentUser?.email !=
                  "aubadmin@gmail.com")
                const SliverToBoxAdapter(child: LogoutColumn(isUser: true))
              else
                const SliverToBoxAdapter(child: LogoutColumn(isUser: false))
            ],
          ),
        );
      },
    );
  }
}
