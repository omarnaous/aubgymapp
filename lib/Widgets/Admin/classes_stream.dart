import 'package:aub_gymsystem/Logic/firebasehelper_class.dart';
import 'package:aub_gymsystem/Models/classes_model.dart';
import 'package:aub_gymsystem/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ClassesStreambuilder extends StatefulWidget {
  const ClassesStreambuilder({super.key});

  @override
  State<ClassesStreambuilder> createState() => _ClassesStreambuilderState();
}

class _ClassesStreambuilderState extends State<ClassesStreambuilder> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('classes').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                final doc = snapshot.data!.docs[index];

                ClassesModel classesModel =
                    ClassesModel.fromJson(doc.data() as Map<String, dynamic>);

                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    elevation: 3,
                    child: Column(
                      children: [
                        ListTile(
                          title: Text(classesModel.className),
                          subtitle: Text(classesModel.classTime),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () => FirebaseHelperClass()
                                .deleteClass(doc.id, context),
                            color: ConstantsClass.themeColor,
                          ),
                        ),
                        TextButton(
                            onPressed: () {
                              FirebaseHelperClass()
                                  .addClassAttendeeDialog(context, doc.id);
                            },
                            child: const Text("Add User"))
                      ],
                    ),
                  ),
                );
              },
            );
          } else {
            return const Center(child: Text('No classes available'));
          }
        },
      ),
    );
  }
}
