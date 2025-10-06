// ignore_for_file: avoid_print, use_build_context_synchronously, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:calmleticsarab/constant.dart';
import 'package:calmleticsarab/helper/token_helper.dart';

class TaskTab extends StatefulWidget {
  final String? taskDescription;
  final String? practical;
  final int sessionId;

  const TaskTab({
    super.key,
    required this.taskDescription,
    required this.practical,
    required this.sessionId,
  });

  @override
  State<TaskTab> createState() => _TaskTabState();
}

class _TaskTabState extends State<TaskTab> {
  int selectedFeelingIndex = -1;
  bool isChecked = false;
  bool isCardDisabled = false;
  bool isLoading = false;
  TextEditingController notesController = TextEditingController();

  final List<Map<String, dynamic>> feelings = [
    {"image": "assets/images/very_anxious.png", "text": "قلق جدًا"},
    {"image": "assets/images/anxious.png", "text": "قلق"},
    {"image": "assets/images/tense.png", "text": "متوتر قليلا"},
    {"image": "assets/images/neutral.png", "text": "محايد"},
    {"image": "assets/images/slightly_calm.png", "text": "هادئ قليلا"},
    {"image": "assets/images/calm.png", "text": "هادئ"},
    {"image": "assets/images/feeling_good.png", "text": "بخير"},
    {"image": "assets/images/very_relaxed.png", "text": "مسترخ جدا"},
    {"image": "assets/images/peaceful.png", "text": "سعيد"},
    {"image": "assets/images/super_relaxed.png", "text": "مسترخٍ تمامًا"},
  ];

  Future<void> sendSessionDone(int sessionId) async {
    final url = Uri.parse(
      'https://calmletics-production.up.railway.app/api/player/done',
    );
    try {
      String? token = await TokenHelper.getToken();
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode({'session_id': sessionId}),
      );
      print('Status code: ${response.statusCode}');
      print('Response body: ${response.body}');
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        if (jsonData['message'] == 'Score saved successfully') {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Score saved successfully")),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('faild: ${response.statusCode}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('failed in connection: $e')));
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final screenWidth = constraints.maxWidth;
        final screenHeight = constraints.maxHeight;

        // حساب القيم النسبية
        final padding = screenWidth * 0.04; // ~16px على شاشة 400px
        final borderRadius = screenWidth * 0.05; // ~20px
        final fontSizeSmall = screenWidth * 0.035; // ~14px
        final fontSizeMedium = screenWidth * 0.04; // ~16px
        final checkboxScale = screenWidth * 0.003; // scale ~1.2–1.5
        final imageSize = screenWidth * 0.06; // ~24px
        final textFieldPadding = screenWidth * 0.03;

        return Stack(
          children: [
            SingleChildScrollView(
              padding: EdgeInsets.all(padding),
              child: Container(
                decoration: BoxDecoration(
                  color: isCardDisabled
                      ? const Color.fromARGB(255, 243, 240, 240)
                      : Colors.white,
                  borderRadius: BorderRadius.circular(borderRadius),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                padding: EdgeInsets.all(padding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Transform.scale(
                          scale: checkboxScale + 0.5,
                          child: Checkbox(
                            value: isChecked,
                            onChanged: (value) {
                              setState(() {
                                isChecked = value!;
                              });
                            },
                            activeColor: kPrimaryColor,
                            shape: const CircleBorder(),
                          ),
                        ),
                        SizedBox(width: screenWidth * 0.025),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.taskDescription ?? '',
                                style: TextStyle(
                                  fontSize: fontSizeMedium,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: screenHeight * 0.005),
                              ...(widget.practical ?? '')
                                  .replaceAll('\r\n', '\n')
                                  .replaceAll('\r', '\n')
                                  .split('\n')
                                  .map(
                                    (line) => Text(
                                      line.trim(),
                                      style: TextStyle(
                                        color: Colors.black54,
                                        fontSize: fontSizeSmall,
                                      ),
                                    ),
                                  ),
                              SizedBox(height: screenHeight * 0.01),
                              Row(
                                children: [
                                  Icon(
                                    Icons.repeat_rounded,
                                    color: kPrimaryColor,
                                    size: imageSize,
                                  ),
                                  Text(
                                    "3 مرات",
                                    style: TextStyle(fontSize: fontSizeMedium),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: screenHeight * 0.015),
                    Text(
                      "كيف كان شعورك اليوم؟",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: fontSizeMedium,
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.01),
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: feelings.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: screenWidth < 600
                            ? 3
                            : 4, // 3 في الموبايل، 4 في التابلت
                        childAspectRatio: screenWidth < 600 ? 1.6 : 1.8,
                        crossAxisSpacing: padding,
                        mainAxisSpacing: padding,
                      ),
                      itemBuilder: (context, index) {
                        final isSelected = selectedFeelingIndex == index;
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedFeelingIndex = index;
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? const Color.fromARGB(255, 221, 239, 222)
                                  : Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(
                                borderRadius * 0.8,
                              ),
                              border: Border.all(
                                color: isSelected
                                    ? Colors.green
                                    : Colors.transparent,
                              ),
                            ),
                            alignment: Alignment.center,
                            padding: EdgeInsets.symmetric(
                              horizontal: padding * 0.5,
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  feelings[index]["image"]!,
                                  height: imageSize,
                                  width: imageSize,
                                ),
                                SizedBox(height: screenHeight * 0.004),
                                Text(
                                  feelings[index]["text"]!,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: fontSizeSmall,
                                    color: isSelected
                                        ? kPrimaryColor
                                        : Colors.black87,
                                    fontWeight: isSelected
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                    SizedBox(height: screenHeight * 0.015),
                    Text(
                      "ملاحظات",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: fontSizeMedium,
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.01),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(borderRadius),
                      ),
                      padding: EdgeInsets.all(textFieldPadding),
                      child: TextField(
                        controller: notesController,
                        maxLines: 5,
                        decoration: InputDecoration.collapsed(
                          hintText: "اكتب ما تشعر به",
                          hintStyle: TextStyle(fontSize: fontSizeSmall),
                        ),
                        style: TextStyle(fontSize: fontSizeMedium),
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    Center(
                      child: ElevatedButton(
                        onPressed: isCardDisabled
                            ? null
                            : () {
                                if (!isChecked) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        'Please confirm that you completed the task',
                                      ),
                                    ),
                                  );
                                  return;
                                }
                                if (selectedFeelingIndex == -1) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        'Please select how you felt',
                                      ),
                                    ),
                                  );
                                  return;
                                }
                                if (notesController.text.isEmpty) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        'Please write a your feeling',
                                      ),
                                    ),
                                  );
                                  return;
                                }
                                setState(() {
                                  isCardDisabled = true;
                                  isLoading = true;
                                });
                                sendSessionDone(widget.sessionId);
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: kPrimaryColor,
                          padding: EdgeInsets.symmetric(
                            horizontal: screenWidth * 0.08,
                            vertical: screenHeight * 0.01,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(borderRadius),
                          ),
                        ),
                        child: Text(
                          "تم الاكمال",
                          style: TextStyle(
                            fontSize: fontSizeMedium,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.02),
                  ],
                ),
              ),
            ),
            if (isLoading)
              Container(
                color: Colors.black.withOpacity(0.3),
                child: const Center(child: CircularProgressIndicator()),
              ),
          ],
        );
      },
    );
  }
}
