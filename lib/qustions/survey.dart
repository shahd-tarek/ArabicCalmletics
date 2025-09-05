// ignore_for_file: library_private_types_in_public_api, avoid_print, use_build_context_synchronously

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:calmleticsarab/constant.dart';
import 'package:calmleticsarab/qustions/end_survey.dart';

class SurveyScreen extends StatefulWidget {
  const SurveyScreen({super.key});

  @override
  _SurveyScreenState createState() => _SurveyScreenState();
}

class _SurveyScreenState extends State<SurveyScreen> {
  Map<int, dynamic> questionAnswers = {};
  int currentPage = 0;
  final PageController _pageController = PageController();

  Future<void> submitSurveyAnswers() async {
    const String apiUrl =
        "https://calmletics-production.up.railway.app/api/player/answers";
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("user_token");

    Map<String, dynamic> formattedAnswers = {
      "Age": questionAnswers[2]?.toString(),
      "Years_of_Excersie_Experince": questionAnswers[4]?.toString(),
      "Weekly_Anxiety": questionAnswers[5]?.toString(),
      "Daily_App_Usage": questionAnswers[12]?.toString(),
      "Comfort_in_Social_Situations": questionAnswers[13]?.toString(),
      "Competition_Level": questionAnswers[6]?.toString(),
      "gender": questionAnswers[1]?.toString(),
      "Current_Status": questionAnswers[3]?.toString(),
      "Feeling_Anxious": questionAnswers[7]?.toString(),
      "Preferred_Anxiety_Treatment": questionAnswers[8]?.toString(),
      "Handling_Anxiety_Situations": questionAnswers[9]?.toString(),
      "General_Mood": questionAnswers[10]?.toString(),
      "Preferred_Content": questionAnswers[11]?.toString(),
      "Online_Interaction_Over_Offline": questionAnswers[14]?.toString(),
    };

    formattedAnswers.removeWhere(
      (key, value) => value == null || value.isEmpty,
    );

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode(formattedAnswers),
      );

      if (response.statusCode == 200) {
        print("Survey submitted successfully: ${response.body}");
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return const CustomDialog();
          },
        );
      } else {
        print("Failed to submit survey: ${response.body}");
      }
    } catch (e) {
      print("Error submitting survey: $e");
    }
  }

  void nextPage() {
    if (currentPage < surveyData.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
    }
  }

  bool areAllQuestionsAnswered(int pageIndex) {
    final questions = surveyData[pageIndex]['questions'];
    return questions.every((q) => questionAnswers.containsKey(q['id']));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgcolor,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: bgcolor,
      ),
      body: PageView.builder(
        controller: _pageController,
        onPageChanged: (index) => setState(() => currentPage = index),
        itemCount: surveyData.length,
        itemBuilder: (context, pageIndex) {
          return buildSurveyPage(surveyData[pageIndex], pageIndex);
        },
      ),
    );
  }

  Widget buildSurveyPage(Map<String, dynamic> page, int pageIndex) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: Container(
            width: double.infinity,
            color: const Color.fromRGBO(237, 237, 237, 1),
            child: Container(
              decoration: BoxDecoration(
                color: const Color.fromRGBO(255, 255, 255, 1),
                borderRadius: BorderRadius.circular(35),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        const SizedBox(width: 40),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: SizedBox(
                            height: 20,
                            width: 250,
                            child: LinearProgressIndicator(
                              value: (pageIndex + 1) / surveyData.length,
                              backgroundColor: Colors.grey[300],
                              valueColor: const AlwaysStoppedAnimation<Color>(
                                kPrimaryColor,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Text(
                          '${pageIndex + 1}/${surveyData.length}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: kPrimaryColor,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Center(
                      child: Text(
                        page['title'],
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Expanded(
                      child: ListView.builder(
                        itemCount: page['questions'].length,
                        itemBuilder: (context, questionIndex) {
                          final question = page['questions'][questionIndex];
                          return buildQuestion(question);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        Container(height: 24, color: const Color.fromRGBO(237, 237, 237, 1)),
        Container(
          padding: const EdgeInsets.all(16.0),
          color: const Color.fromRGBO(255, 255, 255, 1),
          child: ElevatedButton(
            onPressed:
                areAllQuestionsAnswered(pageIndex)
                    ? () async {
                      if (pageIndex == surveyData.length - 1) {
                        await submitSurveyAnswers();
                      } else {
                        nextPage();
                      }
                    }
                    : null,
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  areAllQuestionsAnswered(pageIndex)
                      ? kPrimaryColor
                      : const Color.fromRGBO(106, 149, 122, 0.5),
              minimumSize: const Size(double.infinity, 50),
            ),
            child: Text(
              pageIndex == surveyData.length - 1 ? 'Submit' : 'Next',
              style: const TextStyle(color: Colors.white, fontSize: 20),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildQuestion(Map<String, dynamic> question) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: SizedBox(
        width: 300,
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: const BorderSide(color: Colors.grey, width: 1),
          ),
          color: const Color.fromRGBO(255, 255, 255, 1),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  question['question'],
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),
                Column(
                  children:
                      question['options'].map<Widget>((option) {
                        bool isSelected =
                            questionAnswers[question['id']] == option;
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 6),
                          child: ElevatedButton(
                            onPressed: () {
                              setState(() {
                                questionAnswers[question['id']] = option;
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  isSelected
                                      ? const Color.fromRGBO(215, 244, 212, 1)
                                      : const Color.fromRGBO(255, 255, 255, 1),
                              foregroundColor:
                                  isSelected ? Colors.black : Colors.grey,
                              minimumSize: const Size(double.infinity, 50),
                              elevation: isSelected ? 2 : 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                                side: BorderSide(
                                  color:
                                      isSelected
                                          ? Colors.transparent
                                          : Colors.grey,
                                  width: 1,
                                ),
                              ),
                            ),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                option,
                                style: const TextStyle(fontSize: 16),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

final List<Map<String, dynamic>> surveyData = [
  {
    'title': 'Tell us about yourself',
    'questions': [
      {
        'id': 1,
        'question': 'Gender',
        'options': ["Male", "Female"],
      },
      {
        'id': 2,
        'question': 'What is your age?',
        'options': ['Under 18', '18-24', '25-34'],
      },
      {
        'id': 3,
        'question': 'What is your current situation?',
        'options': ['Working', 'Studying', 'Not currently working'],
      },
    ],
  },
  {
    'title': 'Your Sports Journey & Anxiety',
    'questions': [
      {
        'id': 4,
        'question': 'How many years have you been practicing sports?',
        'options': [
          'Less than a year',
          '1-3 years',
          '4-6 years',
          'More than 6 years',
        ],
      },
      {
        'id': 5,
        'question': 'How often do you feel anxious in\na week?',
        'options': ['Rarely', 'Sometimes', 'Often', 'Always'],
      },
      {
        'id': 6,
        'question': "What's your competition level?",
        'options': [
          'Excellent',
          'First degree',
          'Second degree',
          'Third degree',
          'Not specified',
        ],
      },
      {
        'id': 7,
        'question': 'I feel anxious.',
        'options': [
          'In the morning',
          'In the evening',
          'Before important events',
          'Randomly',
        ],
      },
    ],
  },
  {
    'title': 'How You Handle Anxiety',
    'questions': [
      {
        'id': 8,
        'question':
            'Which of the following do you\nprefer for treating anxiety?',
        'options': [
          'Relaxation',
          'Physical activity',
          'Meditation',
          'Talking with friends',
        ],
      },
      {
        'id': 9,
        'question': 'How do you act in situations that\ncause anxiety?',
        'options': [
          'Avoid it',
          "Can't control my reaction",
          "Can't think",
          'Seek help',
        ],
      },
      {
        'id': 10,
        'question': 'How would you describe your\nmood most of the time?',
        'options': ['Optimistic', 'Neutral', 'Pessimistic'],
      },
    ],
  },
  {
    'title': 'Your Preferences & Social Comfort',
    'questions': [
      {
        'id': 11,
        'question':
            'What type of content do you\nprefer for mental health support?',
        'options': [
          'Motivational videos',
          'Interactive exercises',
          'Reading (Articles)',
          'Guided sessions (Podcasts)',
        ],
      },
      {
        'id': 12,
        'question': 'How much time do you spend\nusing apps daily?',
        'options': ['1-2 hours', '3-4 hours', '4-6 hours', 'More than 6 hours'],
      },
      {
        'id': 13,
        'question': 'How comfortable are you in\nsocial situations?',
        'options': [
          'Completely uncomfortable',
          'Uncomfortable',
          'Comfortable',
          'Very comfortable',
        ],
      },
      {
        'id': 14,
        'question':
            'Do you feel better interacting\nwith people online rather than in\nperson?',
        'options': ['Yes', 'No', 'Neutral'],
      },
    ],
  },
];
