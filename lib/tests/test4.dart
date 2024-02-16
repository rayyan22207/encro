import 'package:encro/tests/test4_1.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final pages = [
    const MessagePage(),
    const NotificationsPage(),
    const CallsPage(),
    const ContactPage()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[0],
      bottomNavigationBar: const _BottomNav(),
    );
  }
}

class _BottomNav extends StatelessWidget {
  const _BottomNav();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        top: false,
        bottom: true,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            NavBarItem(
              index: 0,
              lable: 'Messages',
              icon: CupertinoIcons.bubble_left_bubble_right_fill,
              onTap: (index) {
                print(index);
              },
            ),
            NavBarItem(
              index: 1,
              lable: 'Notifications',
              icon: CupertinoIcons.bell_solid,
              onTap: (index) {
                print(index);
              },
            ),
            NavBarItem(
              index: 2,
              lable: 'Calls',
              icon: CupertinoIcons.phone_fill,
              onTap: (index) {
                print(index);
              },
            ),
            NavBarItem(
              index: 3,
              lable: 'Contacts',
              icon: CupertinoIcons.person_2_fill,
              onTap: (index) {
                print(index);
              },
            ),
          ],
        ));
  }
}

class NavBarItem extends StatelessWidget {
  const NavBarItem(
      {super.key,
      required this.index,
      required this.lable,
      required this.icon,
      required this.onTap});

  final ValueChanged<int> onTap;

  final int index;
  final String lable;
  final IconData icon;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onTap(index);
      },
      child: SizedBox(
        height: 70,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon),
            const SizedBox(
              height: 8,
            ),
            Text(
              lable,
              style: TextStyle(fontSize: 11),
            ),
          ],
        ),
      ),
    );
  }
}
