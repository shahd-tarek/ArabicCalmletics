// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:calmleticsarab/chatbot/start-chatbot.dart';
import 'package:calmleticsarab/community/community.dart';
import 'package:calmleticsarab/constant.dart';
import 'package:calmleticsarab/plan/plan_page.dart';
import 'package:calmleticsarab/progress.dart';
import 'package:calmleticsarab/views/home_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(),
    const PlanPage(),
    const ProgressPage(),
    const Community(),
  ];

  void _goToChatBot(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const StartChatbot()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      floatingActionButton: FloatingActionButton(
        onPressed: () => _goToChatBot(context),
        backgroundColor: kPrimaryColor,
        tooltip: 'Chat Bot',
        shape: const CircleBorder(),
        child: Image.asset(
          'assets/images/Message Bot.png',
          height: 35,
          width: 35,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: BottomAppBar(
            elevation: 5,
            color: Colors.transparent,
            shape: const CircularNotchedRectangle(),
            notchMargin: 6,
            child: SizedBox(
              height: 60,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Expanded(
                    child: navBarItem(Icons.home_rounded, 'الصفحةالرئيسية', 0),
                  ),
                  Expanded(
                    child: navBarItem(
                      Icons.event_available_rounded,
                      'الخطة',
                      1,
                    ),
                  ),
                  const Spacer(),
                  Expanded(
                    child: navBarItem(Icons.show_chart_rounded, 'التقدم', 2),
                  ),
                  Expanded(
                    child: navBarItem(Icons.group_rounded, 'المجتمع', 3),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget navBarItem(IconData icon, String label, int index) {
    return SizedBox(
      width: 90,
      child: InkWell(
        onTap: () {
          setState(() {
            _currentIndex = index;
          });
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: _currentIndex == index ? kPrimaryColor : Colors.grey,
            ),
            Text(
              label,
              style: TextStyle(
                color: _currentIndex == index ? kPrimaryColor : Colors.grey,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
