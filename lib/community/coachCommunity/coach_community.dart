// ignore_for_file: camel_case_types

import 'package:flutter/material.dart';
import 'package:calmleticsarab/community/coachCommunity/pre_leaderboard.dart';

import 'package:calmleticsarab/community/freeCommunity/chat.dart';
import 'package:calmleticsarab/http/api.dart';
import 'package:calmleticsarab/plan/plan_page.dart';
import 'package:calmleticsarab/widgets/option_card.dart';

class coachCommunity extends StatefulWidget {
  const coachCommunity({super.key});

  @override
  State<coachCommunity> createState() => coachCommunityState();
}

class coachCommunityState extends State<coachCommunity> {
  double progressValue = 0.25;
  String? profileImage;
  final Api api = Api();

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    final userData = await api.fetchUserData();
    if (userData != null && mounted) {
      setState(() {
        profileImage = userData['image']; // Get the image URL
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(255, 252, 249, 1),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 30),
              Row(
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      profileImage == null || profileImage!.isEmpty
                          ? const CircularProgressIndicator()
                          : CircleAvatar(
                            radius: 40,
                            backgroundImage: AssetImage(profileImage!),
                            onBackgroundImageError:
                                (_, __) => setState(() {
                                  profileImage = null;
                                }),
                          ),
                    ],
                  ),
                  const SizedBox(width: 30),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Text(
                            "240",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(width: 4),
                          Text("نقطة", style: TextStyle(fontSize: 20)),
                          SizedBox(width: 10),
                          Icon(
                            Icons.local_fire_department,
                            color: Colors.orange,
                            size: 20,
                          ),
                        ],
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const PreLeaderboard(),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromRGBO(
                            233,
                            239,
                            235,
                            1,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                        ),
                        child: const Row(
                          children: [
                            Text(
                              "لوحة الصدارة",
                              style: TextStyle(
                                color: Color.fromRGBO(80, 112, 92, 1),
                                fontSize: 16,
                              ),
                            ),
                            SizedBox(width: 4),
                            Icon(
                              Icons.arrow_forward_ios,
                              color: Color.fromRGBO(80, 112, 92, 1),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  const Icon(
                    Icons.notifications,
                    size: 32,
                    color: Color.fromRGBO(200, 200, 200, 1),
                  ),
                ],
              ),
              const SizedBox(height: 40),
              buildOptionCard("ابدأ التمرين اليومي", () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const PlanPage()),
                );
              }),
              const SizedBox(height: 20),
              const Text(
                "مساحتك الآمنة للتحدث والتعلم",
                style: TextStyle(
                  color: Color.fromRGBO(78, 78, 78, 1),
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 20),
              buildOptionCardtwo(
                "ناقش استراتيجياتك الشخصية، واحصل على تغذية راجعة فورية، وحسّن أدائك",
                () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ChatPage()),
                  );
                },
              ),
              const SizedBox(height: 20),
              const Text(
                "احجز جلسات الواقع الأفتراضي",
                style: TextStyle(
                  color: Color.fromRGBO(78, 78, 78, 1),
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 20),
              buildOptionCard(
                "Step Into Virtual Reality for Peak\nPerformance!",
                () {
                  /*  Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const BookVRSessionPage()),
                );*/
                },
              ),
              const SizedBox(height: 20),
              const Text(
                "إليك دائرة دعمك",
                style: TextStyle(
                  color: Color.fromRGBO(78, 78, 78, 1),
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 20),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: List.generate(10, (index) {
                    return const Padding(
                      padding: EdgeInsets.only(right: 8.0),
                      child: CircleAvatar(
                        radius: 25,
                        backgroundColor: Colors.grey,
                      ),
                    );
                  }),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
