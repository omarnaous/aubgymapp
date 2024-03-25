import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddTrainerPage extends StatefulWidget {
  const AddTrainerPage({Key? key}) : super(key: key);

  @override
  _AddTrainerPageState createState() => _AddTrainerPageState();
}

class _AddTrainerPageState extends State<AddTrainerPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _numberController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Trainers'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => TrainerListPage()));
            },
            icon: const Icon(Icons.list),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: _numberController,
              decoration: const InputDecoration(labelText: 'Number'),
            ),
            const SizedBox(height: 32.0),
            ElevatedButton(
              onPressed: _addTrainer,
              child: const Text('Add Trainer'),
            ),
            const SizedBox(height: 32.0),
            ElevatedButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => TrainerListPage()));
              },
              child: const Text('Trainers List'),
            ),
          ],
        ),
      ),
    );
  }

  void _addTrainer() async {
    String name = _nameController.text;
    String number = _numberController.text;

    if (name.isNotEmpty && number.isNotEmpty) {
      await FirebaseFirestore.instance.collection('trainers').add({
        'name': name,
        'number': number,
      });
      _nameController.clear();
      _numberController.clear();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Trainer added successfully')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields')),
      );
    }
  }
}

class TrainerListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Trainer List'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('trainers').snapshots(),
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
                final name = doc['name'];
                final number = doc['number'];

                return ListTile(
                  title: Text(name),
                  subtitle: Text(number),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () => _deleteTrainer(doc.id, context),
                    color: Colors.red,
                  ),
                );
              },
            );
          } else {
            return const Center(child: Text('No trainers available'));
          }
        },
      ),
    );
  }

  void _deleteTrainer(
    String documentId,
    BuildContext context,
  ) async {
    try {
      await FirebaseFirestore.instance
          .collection('trainers')
          .doc(documentId)
          .delete();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Trainer deleted successfully')),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error deleting trainer: $error')),
      );
    }
  }
}
