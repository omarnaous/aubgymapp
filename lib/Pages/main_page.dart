import 'package:aub_gymsystem/Pages/home_page.dart';
import 'package:aub_gymsystem/Pages/notifications_page.dart';
import 'package:aub_gymsystem/Pages/profile_page.dart';
import 'package:aub_gymsystem/constants.dart';
import 'package:flutter/material.dart';

class MainPage extends StatefulWidget {
  const MainPage({
    super.key,
  });

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;
  PageController pageController = PageController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications_active),
            label: 'Notifications',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor:
            ConstantsClass.themeColor, // Customize the selected item color
        onTap: (int newIndex) {
          setState(() {
            _selectedIndex = newIndex;
            pageController.jumpToPage(newIndex);
          });
        },
      ),
      body: PageView(
        controller: pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: const [
          HomePage(),
          ProfilePage(),
          NotificationPage(),
        ],
      ),
    );
  }
}
