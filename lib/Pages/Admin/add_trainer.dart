// import 'package:aub_gymsystem/Logic/firebasehelper_class.dart';
// import 'package:aub_gymsystem/Pages/Admin/trainers_list.dart';
// import 'package:flutter/material.dart';

// class AddTrainerPage extends StatefulWidget {
//   const AddTrainerPage({Key? key}) : super(key: key);

//   @override
//   // ignore: library_private_types_in_public_api
//   _AddTrainerPageState createState() => _AddTrainerPageState();
// }

// class _AddTrainerPageState extends State<AddTrainerPage> {
//   final TextEditingController _nameController = TextEditingController();
//   final TextEditingController _numberController = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Trainers'),
//         actions: [
//           IconButton(
//             onPressed: () {
//               Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                       builder: (context) => const TrainerListPage()));
//             },
//             icon: const Icon(Icons.list),
//           ),
//         ],
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             TextField(
//               controller: _nameController,
//               decoration: const InputDecoration(labelText: 'Name'),
//             ),
//             const SizedBox(height: 16.0),
//             TextField(
//               controller: _numberController,
//               decoration: const InputDecoration(labelText: 'Number'),
//             ),
//             const SizedBox(height: 32.0),
//             ElevatedButton(
//               onPressed: () {
//                 // FirebaseHelperClass()
//                 //     .addTrainer(context, _nameController, _numberController);
//               },
//               child: const Text('Add Trainer'),
//             ),
//             const SizedBox(height: 32.0),
//             ElevatedButton(
//               onPressed: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => const TrainerListPage(),
//                   ),
//                 );
//               },
//               child: const Text('Trainers List'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
