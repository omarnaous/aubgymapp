import 'package:aub_gymsystem/Logic/firebasehelper_class.dart';
import 'package:aub_gymsystem/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyReservations extends StatefulWidget {
  const MyReservations({Key? key}) : super(key: key);

  @override
  State<MyReservations> createState() => _MyReservationsState();
}

class _MyReservationsState extends State<MyReservations> {
  int _activeLaneIndex = 0;

  void _setActiveLaneIndex(int index) {
    setState(() {
      _activeLaneIndex = index;
    });
  }

  List<String> text = ["Active", "Cancelled"];

  bool active = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My reservations"),
      ),
      body: CustomScrollView(
        slivers: <Widget>[
          SliverToBoxAdapter(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    2,
                    (index) => Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                        onPressed: () {
                          _setActiveLaneIndex(index);
                          if (_activeLaneIndex == 0) {
                            setState(() {
                              active = true;
                            });
                          } else {
                            setState(() {
                              active = false;
                            });
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _activeLaneIndex == index
                              ? ConstantsClass.themeColor
                              : null,
                        ),
                        child: Text(
                          '${text[index]} Reservations',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: _activeLaneIndex == index
                                  ? Colors.white
                                  : null),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
            stream: FirebaseHelperClass().reservationsSnapshots,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const SliverToBoxAdapter(
                  child: CircularProgressIndicator(),
                );
              }
              if (!snapshot.hasData) {
                return const SliverToBoxAdapter(
                  child: Center(child: Text('No Reservations')),
                );
              }

              return SliverList(
                delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                    DocumentSnapshot<Map<String, dynamic>> doc =
                        snapshot.data!.docs[index];
                    Map<String, dynamic> data = doc.data()!;
                    Timestamp dateTime = data["date"];
                    int timeIndex = data["time"];
                    DateTime dateTime2 = dateTime.toDate();
                    String formattedDate =
                        '${dateTime2.day}/${dateTime2.month}/${dateTime2.year}'; // Format: MM/DD/YYYY

                    if (data["userId"] ==
                            FirebaseAuth.instance.currentUser?.uid &&
                        data["active"] == active) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Card(
                          child: Column(
                            children: [
                              ListTile(
                                title: Text(
                                  data["name"],
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                  ),
                                ),
                                subtitle: Text(
                                    "$formattedDate from ${ConstantsClass.timeSlots[timeIndex]}"),
                              ),
                              data["active"] == true
                                  ? Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: ElevatedButton(
                                        style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.all<Color>(
                                            ConstantsClass.themeColor,
                                          ),
                                        ),
                                        onPressed: () async {
                                          await doc.reference.update({
                                            'active':
                                                false, // Assuming 'status' is the field you want to update
                                          });
                                          // ignore: use_build_context_synchronously
                                          showCupertinoDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return CupertinoAlertDialog(
                                                title: const Text(
                                                    'Reservation Details'),
                                                content: const Text(
                                                    'Your reservation is cancelled!'),
                                                actions: <Widget>[
                                                  CupertinoDialogAction(
                                                    child: const Text('Close'),
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                        },
                                        child: const Text(
                                          "Cancel Reservation",
                                          style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    )
                                  : const Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Center(
                                        child: Text(
                                          "Cancelled",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    )
                            ],
                          ),
                        ),
                      );
                    } else {
                      return Container();
                    }
                  },
                  childCount: snapshot.data!.docs.length,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
