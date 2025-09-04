import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:calmleticsarab/helper/token_helper.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:calmleticsarab/community/coachCommunity/showSuccessDialog.dart';
import 'package:calmleticsarab/constant.dart';
import 'package:calmleticsarab/widgets/custom_button.dart';

class BookVRSessionPage extends StatefulWidget {
  final int sessionId;

  const BookVRSessionPage({super.key, required this.sessionId});

  @override
  _BookVRSessionPageState createState() => _BookVRSessionPageState();
}

class _BookVRSessionPageState extends State<BookVRSessionPage> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  int? selectedTimeSlotIndex;

  final List<String> timeSlots = [
    "10:00 AM - 11:00 AM",
    "11:00 AM - 12:00 PM",
    "12:00 PM - 1:00 PM",
    "1:00 PM - 2:00 PM",
    "2:00 PM - 3:00 PM",
  ];

  Future<void> bookSession() async {
    if (_selectedDay == null || selectedTimeSlotIndex == null) {
      Get.snackbar(
        "Error",
        "Please select a date and time slot",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    String time = timeSlots[selectedTimeSlotIndex!];
    int year = _selectedDay!.year;
    int day = _selectedDay!.day;

    try {
      String? token = await TokenHelper.getToken();

      final response = await http.post(
        Uri.parse(
          'https://calmletics-production.up.railway.app/api/player/booksession',
        ),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          "session_id": widget.sessionId,
          "year": year,
          "day": day,
          "time": time,
        }),
      );
      print("Status Code: ${response.statusCode}");
      print("Response Body: ${response.body}");

      final responseBody = jsonDecode(response.body);

      if (response.statusCode == 200 && responseBody['message'] != null) {
        showSuccessDialog(context, "$day/${_selectedDay?.month}/$year, $time");

        setState(() {
          _selectedDay = null;
          selectedTimeSlotIndex = null;
        });
      } else {
        Get.snackbar(
          "Error",
          "Failed to book session",
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        "Something went wrong: $e",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgcolor,
      appBar: AppBar(
        backgroundColor: bgcolor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: Text(
                "احجز جلسة VR",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 10),

            TableCalendar(
              focusedDay: _focusedDay,
              firstDay: DateTime.now(),
              lastDay: DateTime(2100, 12, 31),
              calendarFormat: CalendarFormat.week,
              selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                });
              },
              onPageChanged: (focusedDay) {
                setState(() {
                  _focusedDay = focusedDay;
                });
              },
              calendarStyle: CalendarStyle(
                selectedDecoration: const BoxDecoration(
                  color: kPrimaryColor,
                  shape: BoxShape.circle,
                ),
                todayDecoration: BoxDecoration(
                  color: Colors.grey[300],
                  shape: BoxShape.circle,
                ),
              ),
              headerStyle: const HeaderStyle(
                formatButtonVisible: false,
                titleCentered: true,
              ),
            ),

            const SizedBox(height: 20),

            Expanded(
              child: ListView.builder(
                itemCount: timeSlots.length,
                itemBuilder: (context, index) {
                  bool isSelected = selectedTimeSlotIndex == index;
                  return GestureDetector(
                    onTap: () => setState(() => selectedTimeSlotIndex = index),
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 5),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: isSelected ? Colors.green[100] : Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey[300]!),
                      ),
                      child: Text(
                        timeSlots[index],
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 10),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [CustomButton(text: "تأكيد", ontap: bookSession)],
            ),
          ],
        ),
      ),
    );
  }
}
