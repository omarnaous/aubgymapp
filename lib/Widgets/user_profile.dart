import 'package:aub_gymsystem/Logic/firebasehelper_class.dart';
import 'package:flutter/material.dart';

class UserProfileWidgets extends StatelessWidget {
  const UserProfileWidgets({
    Key? key,
    required this.icons,
    required this.widgetTitles,
    required this.navigationWidget,
    required this.isUser,
  }) : super(key: key);

  final List<IconData> icons;
  final List<String> widgetTitles;
  final List<Widget> navigationWidget;
  final bool isUser;

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.all(10.0), // Add padding around the grid
      sliver: SliverGrid(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // 2 cards per row
          crossAxisSpacing: 10.0,
          mainAxisSpacing: 10.0,
        ),
        delegate: SliverChildBuilderDelegate(
          (BuildContext context, int index) {
            return Padding(
              padding:
                  const EdgeInsets.all(8.0), // Add padding around each card
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) {
                        return navigationWidget[index];
                      },
                    ),
                  );

                  if (index == 2 && isUser == true) {
                    FirebaseHelperClass().showresetPass(context);
                  }
                },
                child: Card(
                  elevation: 5,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(
                          icons[index],
                          size: 40,
                        ),
                      ),
                      Text(
                        widgetTitles[index],
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
          childCount: widgetTitles.length, // Number of cards
        ),
      ),
    );
  }
}
