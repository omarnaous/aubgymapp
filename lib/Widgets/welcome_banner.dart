// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:aub_gymsystem/constants.dart';

class WelcomeUserBanner extends StatefulWidget {
  const WelcomeUserBanner({
    Key? key,
    required this.fullName,
    required this.userID,
    required this.date,
  }) : super(key: key);
  final String fullName;
  final String userID;
  final String date;

  @override
  State<WelcomeUserBanner> createState() => _WelcomeUserBannerState();
}

class _WelcomeUserBannerState extends State<WelcomeUserBanner> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: ConstantsClass.secondaryColor,
                  width: 2,
                ),
                color: Colors.grey,
              ),
              child: const CircleAvatar(
                backgroundColor: Colors.white54,
                radius: 25,
                child: Icon(
                  Icons.person,
                ),
              ),
            ),
          ),
          Expanded(
            flex: 4,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.fullName,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                    ),
                  ),
                  Text(
                    "ID: ${widget.userID}",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                    ),
                  ),
                  if (widget
                      .date.isNotEmpty) // Conditionally render the expiry date
                    Text(
                      "Expiry Date: ${widget.date}",
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                      ),
                    ),
                ],
              ),
            ),
          ),
          Expanded(child: Image.asset(ConstantsClass.aubLogoLink)),
        ],
      ),
    );
  }
}
