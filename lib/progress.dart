import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:calmleticsarab/constant.dart';
import 'package:calmleticsarab/helper/token_helper.dart';
import 'package:calmleticsarab/http/api.dart';
import 'package:calmleticsarab/models/progress_data.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class ProgressPage extends StatefulWidget {
  const ProgressPage({super.key});

  @override
  _ProgressPageState createState() => _ProgressPageState();
}

class _ProgressPageState extends State<ProgressPage>
    with SingleTickerProviderStateMixin {
  final Api api = Api();
  late Future<ProgressData> progressFuture;

  List<Map<String, dynamic>> weekEmotions = [
    {
      "day": "الاثنين",
      "date": "17",
      "emotion": "assets/images/very_anxious.png"
    },
    {"day": "الثلاثاء", "date": "18", "emotion": "assets/images/anxious.png"},
    {"day": "الأربعاء", "date": "19", "emotion": "assets/images/tense.png"},
    {"day": "الخميس", "date": "20", "emotion": "assets/images/neutral.png"},
    {
      "day": "الجمعة",
      "date": "21",
      "emotion": "assets/images/slightly_calm.png"
    },
    {"day": "السبت", "date": "22", "emotion": "assets/images/calm.png"},
  ];

  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
    _animationController.forward();
    progressFuture = fetchProgress();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<ProgressData> fetchProgress() async {
    String? token = await TokenHelper.getToken();
    final url = Uri.parse(
      'https://calmletics-production.up.railway.app/api/player/get-progress ',
    );
    final response = await http.get(
      url,
      headers: {'Authorization': 'Bearer $token'},
    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return ProgressData.fromJson(data);
    } else {
      throw Exception('Failed to load progress');
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final double padding = size.width * 0.04; // 4% من العرض
    final double cardHeight = size.height * 0.18;
    final double chartHeight = size.height * 0.22;
    final double emotionItemWidth = size.width * 0.22;
    final double taskCardWidth = size.width * 0.92; // 92% من العرض
    final double rankCardWidth = size.width * 0.90;

    return Scaffold(
      backgroundColor: bgcolor,
      appBar: AppBar(
        title: Text(
          "التقدّم",
          style: TextStyle(
            fontSize: size.width * 0.05,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
            size: size.width * 0.06,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(padding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: padding * 1.2),
            Text(
              "إنتاجيتك",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: size.width * 0.045,
              ),
            ),
            SizedBox(height: padding * 0.8),
            SizedBox(
              height: chartHeight,
              child: SfCartesianChart(
                primaryXAxis: CategoryAxis(
                  labelStyle: TextStyle(fontSize: size.width * 0.032),
                ),
                primaryYAxis: const NumericAxis(isVisible: false),
                series: <CartesianSeries>[
                  SplineAreaSeries<ChartData, String>(
                    dataSource: [
                      ChartData('٤ أبريل', 3),
                      ChartData('٥ أبريل', 2),
                      ChartData('٦ أبريل', 2.5),
                      ChartData('٧ أبريل', 4),
                      ChartData('٨ أبريل', 3),
                      ChartData('٩ أبريل', 3.5),
                      ChartData('اليوم', 4.5),
                    ],
                    xValueMapper: (ChartData data, _) => data.x,
                    yValueMapper: (ChartData data, _) => data.y,
                    gradient: LinearGradient(
                      colors: [
                        Colors.green.withOpacity(0.5),
                        Colors.green.withOpacity(0.1),
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                    borderWidth: 3,
                    borderColor: Colors.green.shade700,
                  ),
                ],
              ),
            ),
            SizedBox(height: padding * 1.2),
            Text(
              "الحالة المزاجية",
              style: TextStyle(
                fontSize: size.width * 0.045,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: padding * 0.8),
            SizedBox(
              height: size.height * 0.11,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: weekEmotions.length,
                separatorBuilder: (context, index) =>
                    SizedBox(width: padding * 0.6),
                itemBuilder: (context, index) {
                  bool isSelected = index == 1; // simulate "today"
                  return Column(
                    children: [
                      Container(
                        width: emotionItemWidth,
                        padding: EdgeInsets.symmetric(
                          horizontal: padding * 0.8,
                          vertical: padding * 0.4,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected ? kPrimaryColor : Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: isSelected
                                ? kPrimaryColor
                                : Colors.grey.shade300,
                          ),
                        ),
                        child: Column(
                          children: [
                            Text(
                              weekEmotions[index]['day'],
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: isSelected ? Colors.white : Colors.black,
                                fontSize: size.width * 0.035,
                              ),
                            ),
                            Text(
                              weekEmotions[index]['date'],
                              style: TextStyle(
                                color: isSelected ? Colors.white : Colors.black,
                                fontSize: size.width * 0.035,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: padding * 0.3),
                      Image.asset(
                        weekEmotions[index]['emotion'],
                        height: size.width * 0.06,
                      ),
                    ],
                  );
                },
              ),
            ),
            SizedBox(height: padding * 1.2),
            FutureBuilder<ProgressData>(
              future: progressFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text("Error: ${snapshot.error}"));
                } else if (!snapshot.hasData) {
                  return const Center(child: Text("No data available"));
                }
                final progress = snapshot.data!;
                final double completionRate = progress.planPercentage;
                return Row(
                  children: [
                    // ====== Left card: Circular Progress ======
                    Expanded(
                      child: Container(
                        height: cardHeight,
                        padding: EdgeInsets.all(padding),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: Colors.grey.withOpacity(0.3),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.4),
                              blurRadius: 10,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Stack(
                              alignment: Alignment.center,
                              children: [
                                SizedBox(
                                  height: size.width * 0.18,
                                  width: size.width * 0.18,
                                  child: CircularProgressIndicator(
                                    value: completionRate,
                                    strokeWidth: 4,
                                    backgroundColor: Colors.grey.shade200,
                                    color: kPrimaryColor,
                                  ),
                                ),
                                Text(
                                  "${(completionRate * 100).toInt()}%مكتمل",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: size.width * 0.032,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: padding * 0.2),
                            Text(
                              "8/28 أيام مكتملة",
                              style: TextStyle(fontSize: size.width * 0.032),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(width: padding * 0.4),
                    // ====== Right card: Session Info ======
                    Expanded(
                      child: Container(
                        height: cardHeight,
                        padding: EdgeInsets.all(padding),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: Colors.grey.withOpacity(0.3),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.4),
                              blurRadius: 10,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Session ${progress.sessionNumber}',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: size.width * 0.04,
                                    ),
                                  ),
                                  Text(
                                    progress.sessionName,
                                    style: TextStyle(
                                      fontSize: size.width * 0.034,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Image.asset(
                              "assets/images/Sad Face 1.png",
                              height: size.width * 0.18,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
            SizedBox(height: padding * 1.5),
            // ====== Task Progress Card ======
            FutureBuilder<ProgressData>(
              future: progressFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text("Error: ${snapshot.error}"));
                } else if (!snapshot.hasData) {
                  return const Center(child: Text("No data available"));
                }
                final progress = snapshot.data!;
                return Center(
                  child: Container(
                    width: taskCardWidth,
                    padding: EdgeInsets.all(padding),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.grey.withOpacity(0.3)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.4),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "المهام",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: size.width * 0.05,
                          ),
                        ),
                        Text(
                          "نسبة إنجاز المهام الخاصة بك",
                          style: TextStyle(fontSize: size.width * 0.035),
                        ),
                        SizedBox(height: padding * 0.6),
                        LinearProgressIndicator(
                          value: progress.taskPercentage,
                          color: kPrimaryColor,
                          backgroundColor: Colors.grey.shade200,
                          minHeight: 6,
                        ),
                        SizedBox(height: padding * 0.4),
                        Text(
                          "985 مكتملة     215 متبقية",
                          style: TextStyle(fontSize: size.width * 0.032),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            SizedBox(height: padding * 1.2),
            Center(
              child: Container(
                width: rankCardWidth,
                padding: EdgeInsets.all(padding * 1.2),
                height: size.height * 0.18,
                decoration: BoxDecoration(
                  color: kPrimaryColor,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Center(
                  child: Text.rich(
                    TextSpan(
                      text: "الترتيب\n",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: size.width * 0.06,
                        fontWeight: FontWeight.bold,
                      ),
                      children: [
                        TextSpan(
                          text: "44/50",
                          style: TextStyle(
                            fontSize: size.width * 0.07,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ChartData {
  final String x;
  final double y;
  ChartData(this.x, this.y);
}
