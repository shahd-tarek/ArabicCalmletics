// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class VRScheduleScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFCF8F5), // Light background
      appBar: AppBar(
        backgroundColor: Color(0xFFFCF8F5),
        elevation: 0,
        title: Text("جلسات VR", style: TextStyle(color: Colors.black)),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Calendar Section
          Container(
            padding: EdgeInsets.all(10),
            child: TableCalendar(
              firstDay: DateTime.utc(2020, 1, 1),
              lastDay: DateTime.utc(2030, 12, 31),
              focusedDay: DateTime.now(),
              calendarFormat: CalendarFormat.week,
              headerStyle: HeaderStyle(
                formatButtonVisible: false,
                titleCentered: true,
                titleTextStyle:
                    TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              calendarStyle: CalendarStyle(
                todayDecoration: BoxDecoration(
                  color: Color(0xFF5D735F),
                  shape: BoxShape.circle,
                ),
                selectedDecoration: BoxDecoration(
                  color: Colors.green,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),

          // Time Slots
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 16),
              itemCount: 10, // Example slots
              itemBuilder: (context, index) {
                return ScheduleCard(
                  time: "${1 + index} مساءا",
                  name: "احمد",
                  team: "القلق",
                  status: "منخفض",
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// Schedule Card Widget
class ScheduleCard extends StatelessWidget {
  final String time;
  final String name;
  final String team;
  final String status;

  const ScheduleCard({
    required this.time,
    required this.name,
    required this.team,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5),
      child: Container(
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Color(0xFFDFF1D8),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Text(time),
            CircleAvatar(
              backgroundColor: Colors.blue,
              radius: 20,
              child: Icon(Icons.person, color: Colors.white),
            ),
            SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name,
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                  Text(team,
                      style: TextStyle(fontSize: 12, color: Colors.grey)),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: Colors.lightGreenAccent,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(status,
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }
}
