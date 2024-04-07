import 'package:flutter/material.dart';
import 'package:aub_gymsystem/constants.dart';

class RoleSelectionButtons extends StatelessWidget {
  final List<String> roles;
  final int selectedIndex;
  final Function(int) onPressed;

  const RoleSelectionButtons({
    super.key,
    required this.roles,
    required this.selectedIndex,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Wrap(
        spacing: 10,
        runSpacing: 10,
        alignment: WrapAlignment.center,
        children: List.generate(
          roles.length,
          (index) {
            return Padding(
              padding: const EdgeInsets.all(5.0),
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                    selectedIndex == index
                        ? ConstantsClass.themeColor
                        : Colors.white,
                  ),
                ),
                onPressed: () {
                  onPressed(index);
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
              ),
            );
          },
        ),
      ),
    );
  }
}
