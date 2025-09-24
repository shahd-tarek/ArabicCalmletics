import 'dart:convert';
import 'package:calmleticsarab/qustions/mindfulness_scale.dart';
import 'package:calmleticsarab/qustions/self_confidence_test.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:calmleticsarab/calm_routine/quick_t1.dart';
import 'package:calmleticsarab/constant.dart';
import 'package:calmleticsarab/helper/token_helper.dart';
import 'package:calmleticsarab/http/api.dart';
import 'package:calmleticsarab/models/progress_data.dart';
import 'package:calmleticsarab/views/user_profile.dart';
import 'package:calmleticsarab/widgets/card.dart';
import 'package:calmleticsarab/qustions/sports_anxiety_test.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? profileImage;
  final Api api = Api();
  late Future<ProgressData> progressFuture;

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
    progressFuture = fetchProgress();
  }

  Future<void> _loadUserProfile() async {
    final userData = await api.fetchUserData();
    if (userData != null && mounted) {
      setState(() {
        profileImage = userData['image'];
      });
    }
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
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    // ثوابت نسبية
    final double horizontalPadding = screenWidth * 0.04;
    final double cardSpacing = screenHeight * 0.02;
    final double topSectionHeight = screenHeight * 0.03;
    final double progressCardHeight = screenHeight * 0.18;

    return Scaffold(
      backgroundColor: bgcolor,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: horizontalPadding,
            vertical: topSectionHeight,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top bar
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const UserProfileOverview(),
                        ),
                      );
                    },
                    child: profileImage == null || profileImage!.isEmpty
                        ? const CircularProgressIndicator()
                        : CircleAvatar(
                            radius: screenWidth * 0.07,
                            backgroundImage: AssetImage(profileImage!),
                            onBackgroundImageError: (_, __) => setState(() {
                              profileImage = null;
                            }),
                          ),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.notifications_rounded,
                      size: screenWidth * 0.08,
                    ),
                    onPressed: () {},
                  ),
                ],
              ),
              SizedBox(height: screenHeight * 0.02),
              Text(
                'جاهز تتغلب على قلقك اليوم؟',
                style: TextStyle(
                  fontSize: screenWidth * 0.055,
                  color: textcolor,
                ),
              ),
              SizedBox(height: screenHeight * 0.03),

              // Content
              Expanded(
                child: ListView(
                  children: [
                    buildCard(
                      context: context,
                      title: 'اختبار القلق الرياضي',
                      description:
                          'هل تشعر بالقلق؟ خذ هذا الاختبار لتعرف حالتك.',
                      image: 'assets/images/card1.png',
                      navigateTo: const SportsAnxietyTest(),
                    ),
                    SizedBox(height: cardSpacing),
                    buildCard(
                      context: context,
                      title: 'اختبار اليقظة',
                      description: "قيّم مدى وعيك وتركيزك في اللحظة الحالية.",
                      image: 'assets/images/card22.png',
                      navigateTo: const MindfulnesScale(),
                    ),
                    SizedBox(height: cardSpacing),

                    buildCard(
                      context: context,
                      title: "اختبار الثقة بالنفس",
                      description: 'اكتشف مستوى ثقتك بنفسك اليوم.',
                      image: 'assets/images/card33.png',
                      navigateTo: const SelfConfidenceTest(),
                    ),
                    SizedBox(height: cardSpacing),

                    /// Plan & Task Progress Section
                    FutureBuilder<ProgressData>(
                      future: progressFuture,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        } else if (snapshot.hasError) {
                          return Center(
                            child: Text('Error: ${snapshot.error}'),
                          );
                        } else if (!snapshot.hasData) {
                          return const Center(child: Text('No data'));
                        }

                        final progress = snapshot.data!;
                        return Row(
                          children: [
                            Expanded(
                              child: Container(
                                height: progressCardHeight,
                                padding: EdgeInsets.all(screenWidth * 0.03),
                                margin: EdgeInsets.only(
                                  right: screenWidth * 0.01,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: const Color(0xffDADADA),
                                    width: 1.0,
                                  ),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'خطتك',
                                      style: TextStyle(
                                        fontSize: screenWidth * 0.04,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(height: screenHeight * 0.01),
                                    Text(
                                      'Session ${progress.sessionNumber}: ${progress.sessionName}',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: screenWidth * 0.03,
                                      ),
                                    ),
                                    SizedBox(height: screenHeight * 0.02),
                                    LinearProgressIndicator(
                                      value: progress.planPercentage,
                                      color: kPrimaryColor,
                                      backgroundColor: Colors.grey.shade200,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(width: screenWidth * 0.01),
                            Expanded(
                              child: Container(
                                height: progressCardHeight,
                                padding: EdgeInsets.all(screenWidth * 0.03),
                                margin: EdgeInsets.only(
                                  left: screenWidth * 0.01,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: const Color(0xffDADADA),
                                    width: 1.0,
                                  ),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "مهام اليوم:",
                                      style: TextStyle(
                                        fontSize: screenWidth * 0.04,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(height: screenHeight * 0.01),
                                    Text(
                                      progress.taskProgress,
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: screenWidth * 0.03,
                                      ),
                                    ),
                                    SizedBox(height: screenHeight * 0.015),
                                    LinearProgressIndicator(
                                      value: progress.taskPercentage,
                                      color: kPrimaryColor,
                                      backgroundColor: Colors.grey.shade200,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),

                    SizedBox(height: cardSpacing),
                    buildCard(
                      context: context,
                      title: 'روتين الهدوء قبل المباراة:',
                      description:
                          'روتين سريع وبسيط لتهدئة عقلك وإعادة تركيزك قبل اللعب.',
                      image: 'assets/images/card2.png',
                      navigateTo: const QuickTaskOne(
                        pageIndex: 0,
                        totalPages: 4,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
