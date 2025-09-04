import 'package:flutter/material.dart';
import 'package:calmleticsarab/constant.dart';
import 'package:table_calendar/table_calendar.dart';

class VRScheduleScreen extends StatelessWidget {
  const VRScheduleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgcolor, // Light background
      appBar: AppBar(
        backgroundColor: bgcolor,
        elevation: 0,
        title: const Text("VR Sessions", style: TextStyle(color: Colors.black)),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Calendar Section
          Container(
            padding: const EdgeInsets.all(10),
            child: TableCalendar(
              firstDay: DateTime.utc(2020, 1, 1),
              lastDay: DateTime.utc(2030, 12, 31),
              focusedDay: DateTime.now(),
              calendarFormat: CalendarFormat.week,
              headerStyle: const HeaderStyle(
                formatButtonVisible: false,
                titleCentered: true,
                titleTextStyle: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              calendarStyle: const CalendarStyle(
                todayDecoration: BoxDecoration(
                  color: kPrimaryColor,
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
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: 4, // Example slots
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10, top: 5),
                  child: ScheduleCard(
                    time: "${1 + index} PM",
                    name: "Savannah Nguyen",
                    team: "Anxiety Warriors",
                    status: "low",
                  ),
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
    super.key,
    required this.time,
    required this.name,
    required this.team,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xffE9EFEB),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Text(time),
            const SizedBox(width: 8),
            const CircleAvatar(
              backgroundColor: kPrimaryColor,
              radius: 20,
              child: Icon(Icons.person, color: Colors.white),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    team,
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: const Color(0xffEFFFCE),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                status,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
