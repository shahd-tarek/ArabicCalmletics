// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:calmleticsarab/constant.dart';
import 'package:calmleticsarab/http/api.dart';
import 'package:calmleticsarab/qustions/finalscore.dart';

class SportsAnxietyTest extends StatefulWidget {
  const SportsAnxietyTest({super.key});

  @override
  _SportsAnxietyTestState createState() => _SportsAnxietyTestState();
}

class _SportsAnxietyTestState extends State<SportsAnxietyTest> {
  Map<int, int> questionScores = {};
  int currentPage = 0;
  final PageController _pageController = PageController();

  final List<Map<String, dynamic>> surveyData = [
    {
      'questions': [
        {
          'question':
              'أنا قلق من أنني قد لا أؤدي بشكل جيد اليوم  كما  كنت أستطيع من  قبل',
          'options': {
            'لا على الإطلاق': 1,
            'إلى حد ما': 2,
            'محايد/ غير متأكد': 3,
            'معتدل': 4,
            'إلى حد كبير جدا': 5,
          },
        },
      ],
    },
    {
      'questions': [
        {
          'question': 'أشعر أن جسمي متوتر',
          'options': {
            'لا على الإطلاق': 1,
            'إلى حد ما': 2,
            'محايد/ غير متأكد': 3,
            'معتدل': 4,
            'إلى حد كبير جدا': 5,
          },
        },
      ],
    },
    {
      'questions': [
        {
          'question': 'أشعر بالثقة بالنفس',
          'options': {
            'لا على الإطلاق': 1,
            'إلى حد ما': 2,
            'محايد/ غير متأكد': 3,
            'معتدل': 4,
            'إلى حد كبير جدا': 5,
          },
        },
      ],
    },
    {
      'questions': [
        {
          'question': 'أشعر بالتوتر في معدتي',
          'options': {
            'لا على الإطلاق': 1,
            'إلى حد ما': 2,
            'محايد/ غير متأكد': 3,
            'معتدل': 4,
            'إلى حد كبير جدا': 5,
          },
        },
      ],
    },
    {
      'questions': [
        {
          'question': 'أشعر بالأمان',
          'options': {
            'لا على الإطلاق': 1,
            'إلى حد ما': 2,
            'محايد/ غير متأكد': 3,
            'معتدل': 4,
            'إلى حد كبير جدا': 5,
          },
        },
      ],
    },
    {
      'questions': [
        {
          'question':
              'أنا واثق من أنني سأتمكن من مواجهة تحديات اليوم وأؤدي بشكل جيد',
          'options': {
            'لا على الإطلاق': 1,
            'إلى حد ما': 2,
            'محايد/ غير متأكد': 3,
            'معتدل': 4,
            'إلى حد كبير جدا': 5,
          },
        },
      ],
    },
    {
      'questions': [
        {
          'question': 'أنا قلق من أنني قد أؤدي بشكل سيئ اليوم',
          'options': {
            'لا على الإطلاق': 1,
            'إلى حد ما': 2,
            'محايد/ غير متأكد': 3,
            'معتدل': 4,
            'إلى حد كبير جدا': 5,
          },
        },
      ],
    },
    {
      'questions': [
        {
          'question': 'قلبي ينبض بسرعة',
          'options': {
            'لا على الإطلاق': 1,
            'إلى حد ما': 2,
            'محايد/ غير متأكد': 3,
            'معتدل': 4,
            'إلى حد كبير جدا': 5,
          },
        },
      ],
    },
    {
      'questions': [
        {
          'question': 'أنا واثق من أنني سأؤدي بشكل جيد اليوم',
          'options': {
            'لا على الإطلاق': 1,
            'إلى حد ما': 2,
            'محايد/ غير متأكد': 3,
            'معتدل': 4,
            'إلى حد كبير جدا': 5,
          },
        },
      ],
    },
    {
      'questions': [
        {
          'question': 'أنا قلق بشأن تحقيق هدفي في الرياضة',
          'options': {
            'لا على الإطلاق': 1,
            'إلى حد ما': 2,
            'محايد/ غير متأكد': 3,
            'معتدل': 4,
            'إلى حد كبير جدا': 5,
          },
        },
      ],
    },
    {
      'questions': [
        {
          'question': 'أشعر بتقلص أو مغص في معدتي',
          'options': {
            'لا على الإطلاق': 1,
            'إلى حد ما': 2,
            'محايد/ غير متأكد': 3,
            'معتدل': 4,
            'إلى حد كبير جدا': 5,
          },
        },
      ],
    },
    {
      'questions': [
        {
          'question':
              'أشعر بالقلق من عدم رضا الآخرين عن أدائي  في مباراة اليوم',
          'options': {
            'لا على الإطلاق': 1,
            'إلى حد ما': 2,
            'محايد/ غير متأكد': 3,
            'معتدل': 4,
            'إلى حد كبير جدا': 5,
          },
        },
      ],
    },
    {
      'questions': [
        {
          'question':
              'أشعر بالثقة في نفسي لأني وضعت لنفسي صورة في عقلي بأني سوف أحقق أهدافي اليوم في المبارة',
          'options': {
            'لا على الإطلاق': 1,
            'إلى حد ما': 2,
            'محايد/ غير متأكد': 3,
            'معتدل': 4,
            'إلى حد كبير جدا': 5,
          },
        },
      ],
    },
    {
      'questions': [
        {
          'question': 'أنا قلق بشأن عدم القدرة على التركيز اليوم',
          'options': {
            'لا على الإطلاق': 1,
            'إلى حد ما': 2,
            'محايد/ غير متأكد': 3,
            'معتدل': 4,
            'إلى حد كبير جدا': 5,
          },
        },
      ],
    },
    {
      'questions': [
        {
          'question': 'أشعر أن جسدي مشدود',
          'options': {
            'لا على الإطلاق': 1,
            'إلى حد ما': 2,
            'محايد/ غير متأكد': 3,
            'معتدل': 4,
            'إلى حد كبير جدا': 5,
          },
        },
      ],
    },
  ];

  int calculateTotalScore() {
    int totalScore = 0;
    for (var score in questionScores.values) {
      totalScore += score;
    }
    return totalScore;
  }

  void nextPage() {
    if (currentPage < surveyData.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
    } else {
      int totalScore = calculateTotalScore();
      int maxScore = surveyData.length * 5;
      double percentage = (totalScore / maxScore) * 100;

      final api = Api();
      api.saveScore(percentage.toInt()).then((success) {
        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Score saved successfully!")),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Failed to save score.")),
          );
        }
      });

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AnxietyScreen(percentage: percentage),
        ),
      );
    }
  }

  bool areAllQuestionsAnswered(int pageIndex) {
    final questions = surveyData[pageIndex]['questions'];
    for (int i = 0; i < questions.length; i++) {
      if (!questionScores.containsKey(pageIndex * 10 + i)) {
        return false;
      }
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    // حساب جميع القيم النسبية هنا
    final double cardWidth = screenWidth * 0.9;
    final double fontSizeQuestion = screenWidth * 0.045;
    final double fontSizeOption = screenWidth * 0.04;
    final double progressHeight = screenHeight * 0.025;
    final double buttonHeight = screenHeight * 0.06;
    final double padding = screenWidth * 0.04;
    final double questionVerticalPadding = screenHeight * 0.015;
    final double cardPadding = screenWidth * 0.03;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
            size: screenWidth * 0.06,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: bgcolor,
      ),
      body: PageView.builder(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            currentPage = index;
          });
        },
        itemCount: surveyData.length,
        itemBuilder: (context, pageIndex) {
          return buildSurveyPage(
            page: surveyData[pageIndex],
            pageIndex: pageIndex,
            cardWidth: cardWidth,
            fontSizeQuestion: fontSizeQuestion,
            fontSizeOption: fontSizeOption,
            progressHeight: progressHeight,
            buttonHeight: buttonHeight,
            padding: padding,
            questionVerticalPadding: questionVerticalPadding,
            cardPadding: cardPadding,
            screenWidth: screenWidth,
            screenHeight: screenHeight,
          );
        },
      ),
    );
  }

  Widget buildSurveyPage({
    required Map<String, dynamic> page,
    required int pageIndex,
    required double cardWidth,
    required double fontSizeQuestion,
    required double fontSizeOption,
    required double progressHeight,
    required double buttonHeight,
    required double padding,
    required double questionVerticalPadding,
    required double cardPadding,
    required double screenWidth,
    required double screenHeight,
  }) {
    return Column(
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(35),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xff808080).withOpacity(0.2),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Padding(
              padding: EdgeInsets.all(padding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: screenHeight * 0.02),
                  Center(
                    child: Text(
                      "اختبار القلق الرياضي",
                      style: TextStyle(
                        fontSize: screenWidth * 0.055,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.015),
                  Row(
                    children: [
                      SizedBox(width: screenWidth * 0.08),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: SizedBox(
                          height: progressHeight,
                          width: screenWidth * 0.6,
                          child: LinearProgressIndicator(
                            value: (pageIndex + 1) / surveyData.length,
                            backgroundColor: Colors.grey[300],
                            valueColor: const AlwaysStoppedAnimation<Color>(
                              kPrimaryColor,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: screenWidth * 0.03),
                      Text(
                        '${pageIndex + 1}/${surveyData.length}',
                        style: TextStyle(
                          fontSize: screenWidth * 0.04,
                          fontWeight: FontWeight.bold,
                          color: kPrimaryColor,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  Expanded(
                    child: ListView.builder(
                      itemCount: page['questions'].length,
                      itemBuilder: (context, questionIndex) {
                        final question = page['questions'][questionIndex];
                        return buildQuestion(
                          question: question,
                          questionId: pageIndex * 10 + questionIndex,
                          cardWidth: cardWidth,
                          fontSizeQuestion: fontSizeQuestion,
                          fontSizeOption: fontSizeOption,
                          verticalPadding: questionVerticalPadding,
                          cardPadding: cardPadding,
                          buttonHeight: buttonHeight,
                          screenWidth: screenWidth,
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        if (pageIndex == surveyData.length - 1)
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: padding,
              vertical: padding / 2,
            ),
            color: Colors.white,
            child: ElevatedButton(
              onPressed: areAllQuestionsAnswered(pageIndex) ? nextPage : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: areAllQuestionsAnswered(pageIndex)
                    ? kPrimaryColor
                    : Colors.green.withOpacity(0.5),
                minimumSize: Size(double.infinity, buttonHeight),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: Text(
                'التالي',
                style: TextStyle(
                  fontSize: screenWidth * 0.045,
                  color: Colors.white,
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget buildQuestion({
    required Map<String, dynamic> question,
    required int questionId,
    required double cardWidth,
    required double fontSizeQuestion,
    required double fontSizeOption,
    required double verticalPadding,
    required double cardPadding,
    required double buttonHeight,
    required double screenWidth,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: verticalPadding),
      child: SizedBox(
        width: cardWidth,
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: const BorderSide(color: Colors.grey, width: 1),
          ),
          color: Colors.white,
          child: Padding(
            padding: EdgeInsets.all(cardPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  question['question'],
                  style: TextStyle(
                    fontSize: fontSizeQuestion,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: verticalPadding),
                ...question['options'].entries.map<Widget>((entry) {
                  final optionText = entry.key;
                  final optionValue = entry.value;
                  final isSelected = questionScores[questionId] == optionValue;
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          questionScores[questionId] = optionValue;
                        });
                        if (areAllQuestionsAnswered(currentPage)) {
                          nextPage();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isSelected
                            ? const Color.fromRGBO(215, 244, 212, 1)
                            : Colors.white,
                        foregroundColor:
                            isSelected ? Colors.black : Colors.grey,
                        minimumSize: Size(double.infinity, buttonHeight),
                        elevation: isSelected ? 2 : 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                          side: BorderSide(
                            color:
                                isSelected ? Colors.transparent : Colors.grey,
                            width: 1,
                          ),
                        ),
                      ),
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          optionText,
                          style: TextStyle(fontSize: fontSizeOption),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
