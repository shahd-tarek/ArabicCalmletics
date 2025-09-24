// ignore_for_file: avoid_print, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:calmleticsarab/constant.dart';
import 'package:calmleticsarab/http/api.dart';
import 'package:calmleticsarab/qustions/recommend_plan.dart';
import 'package:calmleticsarab/qustions/sports_anxiety_test.dart';
import 'package:calmleticsarab/views/main_screen.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class AnxietyScreen extends StatefulWidget {
  final double percentage;
  const AnxietyScreen({super.key, required this.percentage});

  @override
  State<AnxietyScreen> createState() => _AnxietyScreenState();
}

class _AnxietyScreenState extends State<AnxietyScreen> {
  Future<void> fetchAndSendCluster() async {
    try {
      Api api = Api();
      print("Fetching user answers...");
      Map<String, dynamic>? answers = await api.getUserAnswers();
      print("✅ User Answers Retrieved:");
      answers!.forEach((key, value) {
        print("$key: $value");
      });
      print("Sending answers to AI API...");
      Map<String, dynamic>? aiResponse = await api.sendAnswersToAI(answers);
      if (aiResponse != null) {
        print("✅ AI API Response:");
        aiResponse.forEach((key, value) {
          print("$key: $value");
        });
        if (aiResponse.containsKey("cluster")) {
          int clusterNumber = aiResponse["cluster"];
          print("🎯 Cluster Number: $clusterNumber");
          bool clusterSent = await api.sendClusterNumber(clusterNumber);
          if (clusterSent) {
            print("✅ Cluster number sent successfully!");
          } else {
            print("❌ Failed to send cluster number.");
          }
        } else {
          print("❌ Cluster number not found in AI API response.");
        }
      } else {
        print("❌ Failed to get response from AI API.");
      }
    } catch (e) {
      print("⚠️ Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    // تحديد أحجام نسبية
    final double horizontalPadding = screenWidth * 0.04;
    final double titleFontSize = screenWidth * 0.05;
    final double subtitleFontSize = screenWidth * 0.04;
    final double cardCornerRadius = screenWidth * 0.04;
    final double buttonWidth = screenWidth * 0.42;
    final double buttonHeight = screenHeight * 0.07;
    final double buttonFontSize = screenWidth * 0.045;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
            size: screenWidth * 0.06,
          ),
          onPressed: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const MainScreen()),
              (route) => false,
            );
          },
        ),
        backgroundColor: bgcolor,
      ),
      backgroundColor: bgcolor,
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: screenHeight * 0.01),
                    Text(
                      "مستوى القلق لديك",
                      style: TextStyle(
                        fontSize: titleFontSize,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.01),
                    SizedBox(
                      height: screenHeight * 0.35,
                      child: _buildAnxietyGauge(screenWidth),
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    Text(
                      "معنى نتيجتك",
                      style: TextStyle(
                        fontSize: titleFontSize,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.01),
                    Text(
                      "يبدو أنك تواجه بعض التحديات، لا تقلق لقد أعددنا خطة لمساعدتك",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: subtitleFontSize,
                        color: Colors.grey,
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.03),
                    _buildResultsCard(
                      context,
                      screenWidth,
                      cardCornerRadius,
                      subtitleFontSize,
                    ),
                  ],
                ),
              ),
            ),
          ),
          // ✅ تمرير القيم النسبية للدالة
          _buildActionButtons(
            context: context,
            buttonWidth: buttonWidth,
            buttonHeight: buttonHeight,
            fontSize: buttonFontSize,
          ),
        ],
      ),
    );
  }

  Widget _buildAnxietyGauge(double screenWidth) {
    return SizedBox(
      height: screenWidth * 0.7, // ارتفاع أكبر بناءً على العرض
      child: SfRadialGauge(
        axes: <RadialAxis>[
          RadialAxis(
            startAngle: 180,
            endAngle: 0,
            showTicks: false,
            showLabels: false,
            radiusFactor: 0.85, // زاد من 0.8 إلى 0.9 (أكبر شوية)
            axisLineStyle: AxisLineStyle(
              thickness: 0.16, // زاد السماكة قليلًا
              thicknessUnit: GaugeSizeUnit.factor,
              cornerStyle: CornerStyle.bothFlat,
              color: Colors.grey[200],
            ),
            ranges: <GaugeRange>[
              GaugeRange(
                startValue: 0,
                endValue: 33,
                color: const Color.fromRGBO(164, 206, 78, 1),
                startWidth: 60, // من 50 إلى 60
                endWidth: 60,
              ),
              GaugeRange(
                startValue: 33,
                endValue: 66,
                color: const Color.fromRGBO(241, 221, 36, 1),
                startWidth: 60,
                endWidth: 60,
              ),
              GaugeRange(
                startValue: 66,
                endValue: 100,
                color: const Color.fromRGBO(238, 86, 36, 1),
                startWidth: 60,
                endWidth: 60,
              ),
            ],
            pointers: <GaugePointer>[
              NeedlePointer(
                value: widget.percentage,
                needleLength: 0.6, // من 0.6 إلى 0.7 (إبرة أطول)
                enableAnimation: true,
                animationType: AnimationType.easeOutBack,
                needleColor: Colors.black,
                knobStyle: const KnobStyle(
                  knobRadius: 0.06, // من 0.06 إلى 0.07 (رأس الإبرة أكبر)
                  sizeUnit: GaugeSizeUnit.factor,
                  color: Colors.black,
                ),
              ),
            ],
            annotations: <GaugeAnnotation>[
              GaugeAnnotation(
                widget: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "${widget.percentage.toInt()}%",
                      style: TextStyle(
                        fontSize: screenWidth * 0.11, // كبر الخط شوية
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      _getAnxietyStatus(),
                      style: TextStyle(
                        fontSize: screenWidth * 0.065, // خط الحالة أكبر شوية
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
                angle: 90,
                positionFactor: 0.5,
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _getAnxietyStatus() {
    if (widget.percentage <= 33) {
      return "منخفض";
    } else if (widget.percentage <= 66) {
      return "متوسط";
    } else {
      return "عالي";
    }
  }

  Widget _buildResultsCard(
    BuildContext context,
    double screenWidth,
    double cardCornerRadius,
    double fontSize,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(cardCornerRadius),
        border: Border.all(color: Colors.grey, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            height: 10,
            decoration: BoxDecoration(
              color: kPrimaryColor,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(cardCornerRadius),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(screenWidth * 0.04),
            child: Column(
              children: [
                _buildScoreRow(
                  "الأعراض الجسدية",
                  _getPercentage(widget.percentage, 75),
                  fontSize,
                ),
                const Divider(),
                _buildScoreRow(
                  "القلق بشأن الأداء",
                  _getPercentage(widget.percentage - 10, 75),
                  fontSize,
                ),
                const Divider(),
                _buildScoreRow(
                  "مستوى الثقة بالنفس",
                  _getPercentage(widget.percentage - 20, 75),
                  fontSize,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getPercentage(double score, double maxScore) {
    double percentage = (score / maxScore) * 100;
    return "${percentage.toStringAsFixed(1)}%";
  }

  Widget _buildScoreRow(String title, String value, double fontSize) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: TextStyle(fontSize: fontSize, color: Colors.grey)),
        Text(
          value,
          style: TextStyle(
            fontSize: fontSize * 1.2,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ],
    );
  }

  // ✅ التعديل: إضافة المعاملات (parameters)
  Widget _buildActionButtons({
    required BuildContext context,
    required double buttonWidth,
    required double buttonHeight,
    required double fontSize,
  }) {
    return Container(
      padding: EdgeInsets.all(buttonHeight * 0.3),
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          SizedBox(
            width: buttonWidth,
            height: buttonHeight,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SportsAnxietyTest(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                side: const BorderSide(
                  color: Color.fromRGBO(106, 149, 122, 1),
                  width: 1,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: Text(
                "إعادة الاختبار",
                style: TextStyle(
                  color: const Color.fromRGBO(106, 149, 122, 1),
                  fontSize: fontSize,
                ),
              ),
            ),
          ),
          SizedBox(
            width: buttonWidth,
            height: buttonHeight,
            child: ElevatedButton(
              onPressed: () {
                fetchAndSendCluster();
                showRecommendationDialog(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromRGBO(106, 149, 122, 1),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: Text(
                "التالي",
                style: TextStyle(color: Colors.white, fontSize: fontSize),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
