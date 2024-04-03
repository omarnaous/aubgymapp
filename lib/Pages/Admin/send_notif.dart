import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SendNotificationsPage extends StatefulWidget {
  const SendNotificationsPage({Key? key}) : super(key: key);

  @override
  _SendNotificationsPageState createState() => _SendNotificationsPageState();
}

class _SendNotificationsPageState extends State<SendNotificationsPage> {
  final TextEditingController _questionController = TextEditingController();
  final TextEditingController _optionController = TextEditingController();
  List<String> options = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Notification'),
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextField(
                    controller: _questionController,
                    decoration: InputDecoration(labelText: 'Enter Question'),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _optionController,
                          decoration:
                              InputDecoration(labelText: 'Enter Option'),
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            options.add(_optionController.text);
                            _optionController.clear();
                          });
                        },
                        icon: const Icon(Icons.add),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      saveQuestion();
                    },
                    child: const Text('Save'),
                  ),
                  const SizedBox(height: 16),
                  const Text('Options:',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children:
                        options.map((option) => Text('- $option')).toList(),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.15,
            ),
          ),
          const SliverToBoxAdapter(
            child: Divider(),
          ),
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                "Older Notifications Results",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                ),
              ),
            ),
          ),
          StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('notifications')
                .snapshots(),
            builder: (BuildContext context,
                AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
              if (snapshot.hasData) {
                return SliverList.builder(
                    itemCount: snapshot.data?.docs.length,
                    itemBuilder: (context, int index) {
                      List answers =
                          snapshot.data?.docs[index].data()["answers"] ?? [];
                      List questions =
                          snapshot.data?.docs[index].data()["questions"] ?? [];

                      Map<String, int> questionResults = {};

                      for (var question in questions) {
                        questionResults[question] = 0;
                      }

                      for (var element in answers) {
                        if (questionResults.containsKey(element["answer"])) {
                          questionResults[element["answer"]] =
                              questionResults[element["answer"]]! + 1;
                        }
                      }

                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Card(
                          child: Column(
                            children: [
                              ListTile(
                                title: Text(snapshot.data?.docs[index]
                                    .data()["notification"]),
                                trailing: IconButton(
                                    icon: const Icon(Icons.delete),
                                    onPressed: () {
                                      FirebaseFirestore.instance
                                          .collection('notifications')
                                          .doc(snapshot.data?.docs[index].id)
                                          .delete();
                                    }),
                              ),
                              Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: List.generate(
                                          questions.length,
                                          (index) => Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Text(
                                                  "${questionResults[questions[index]]} answered\n${questions[index]}",
                                                  textAlign: TextAlign.start,
                                                  style: const TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              )),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      );
                    });
              } else {
                return const SliverToBoxAdapter();
              }
            },
          )
        ],
      ),
    );
  }

  void saveQuestion() {
    // Check if question is not empty and at least two options are provided
    if (_questionController.text.isNotEmpty && options.length >= 2) {
      // Save the question and options to Firestore
      FirebaseFirestore.instance.collection('notifications').add({
        'notification': _questionController.text,
        'questions': options,
        'answers': [], // Empty answers list
        'timestamp': DateTime.now()
      }).then((value) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Question saved successfully!')),
        );
        // Clear fields and options list
        setState(() {
          _questionController.clear();
          _optionController.clear();
          options.clear();
        });
      }).catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to save question: $error')),
        );
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Please enter a question and at least two options')),
      );
    }
  }
}
