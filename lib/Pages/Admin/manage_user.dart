import 'package:aub_gymsystem/Models/user_model.dart';
import 'package:aub_gymsystem/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ManageUsersPage extends StatefulWidget {
  const ManageUsersPage({Key? key}) : super(key: key);

  @override
  _ManageUsersPageState createState() => _ManageUsersPageState();
}

class _ManageUsersPageState extends State<ManageUsersPage> {
  List<String> roles = ["Guest", "Faculty"];
  int selectedIndex = 0;
  TextEditingController searchController =
      TextEditingController(); // Add search controller

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Users'),
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(roles.length, (index) {
                return ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                      selectedIndex == index
                          ? ConstantsClass.themeColor
                          : Colors.white,
                    ),
                  ),
                  onPressed: () {
                    setState(() {
                      selectedIndex = index;
                    });
                  },
                  child: Text(
                    roles[index],
                    style: TextStyle(
                      fontSize: 20,
                      color: selectedIndex == index
                          ? Colors.white
                          : ConstantsClass.themeColor,
                    ),
                  ),
                );
              }),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: TextField(
                controller: searchController,
                onChanged: (value) {
                  setState(() {}); // Trigger rebuild when text changes
                },
                decoration: const InputDecoration(
                  hintText: 'Search by name',
                ),
              ),
            ),
          ),
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('users')
                .where(
                  'role',
                  isEqualTo: roles[selectedIndex].toLowerCase(),
                )
                .snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const SliverFillRemaining(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              } else if (snapshot.hasError) {
                return SliverFillRemaining(
                  child: Center(
                    child: Text('Error: ${snapshot.error}'),
                  ),
                );
              } else {
                final List<DocumentSnapshot> users = snapshot.data!.docs;

                // Filter users based on search query
                List<DocumentSnapshot> filteredUsers = users.where((user) {
                  String firstName = user['firstName'].toLowerCase();
                  String lastName = user['lastName'].toLowerCase();
                  String searchQuery = searchController.text.toLowerCase();

                  // Check if the search query matches either the first name or last name
                  return firstName.contains(searchQuery) ||
                      lastName.contains(searchQuery);
                }).toList();

                return SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                      final userData =
                          filteredUsers[index].data() as Map<String, dynamic>;
                      UserClassModel userClassModel =
                          UserClassModel.fromJson(userData);

                      void toggleLockState() async {
                        if (userClassModel.locked) {
                          // If the user is currently locked, set end date to null
                          await FirebaseFirestore.instance
                              .collection('users')
                              .doc(filteredUsers[index].id)
                              .update({
                            'locked': false,
                            'endDate': null,
                          });
                        } else {
                          // Calculate the end date one month from now
                          DateTime endDate =
                              DateTime.now().add(const Duration(days: 30));

                          // Update Firestore document with new locked status and end date
                          await FirebaseFirestore.instance
                              .collection('users')
                              .doc(filteredUsers[index].id)
                              .update({
                            'locked': true,
                            'endDate': endDate,
                          });
                        }
                      }

                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Card(
                          child: ListTile(
                            title: Text(
                              '${userClassModel.firstName} ${userClassModel.lastName}',
                            ),
                            subtitle: Text(
                              userData['email'],
                            ),
                            trailing: userClassModel.locked
                                ? TextButton(
                                    onPressed: toggleLockState,
                                    child: const Text("Unlock"))
                                : TextButton(
                                    onPressed: toggleLockState,
                                    child: const Text("Lock")),
                          ),
                        ),
                      );
                    },
                    childCount: filteredUsers.length,
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
