// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class ReservationCard extends StatelessWidget {
  final String title;
  final String date;
  final int spotsLeft;
  final VoidCallback onPressed;
  final bool locked;

  const ReservationCard({
    Key? key,
    required this.title,
    required this.date,
    required this.spotsLeft,
    required this.onPressed,
    required this.locked,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: ListTile(
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 5,
            ),
            Text(date),
            const SizedBox(
              height: 5,
            ),
            Text(
              "$spotsLeft Spots left",
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
          ],
        ),
        trailing: locked == false
            ? ElevatedButton(
                onPressed: onPressed,
                child: const Text(
                  "Reserve",
                ),
              )
            : IconButton(onPressed: () {}, icon: const Icon(Icons.lock)),
      ),
    );
  }
}
