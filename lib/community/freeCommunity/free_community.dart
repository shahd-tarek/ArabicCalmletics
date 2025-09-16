// ignore_for_file: camel_case_types

import 'package:flutter/material.dart';
import 'package:calmleticsarab/community/coachCommunity/community-pop-code.dart';
import 'package:calmleticsarab/community/freeCommunity/chat.dart';
import 'package:calmleticsarab/community/freeCommunity/free_Leaderboard.dart';
import 'package:calmleticsarab/http/api.dart';
import 'package:calmleticsarab/plan/plan_page.dart';
import 'package:calmleticsarab/widgets/option_card.dart';

class freeCommunity extends StatefulWidget {
  const freeCommunity({super.key});

  @override
  State<freeCommunity> createState() => freeCommunityState();
}

class freeCommunityState extends State<freeCommunity> {
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
        profileImage = userData['image'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final double padding = size.width * 0.04; // 4% من العرض
    final double avatarRadius = size.width * 0.1; // 12% من العرض
    final double fontSizeSmall = size.width * 0.038;
    final double fontSizeMedium = size.width * 0.042;

    return Scaffold(
      backgroundColor: const Color.fromRGBO(255, 252, 249, 1),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(padding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: padding * 3), // 30 -> نسبي
              // Profile & Points Section
              Row(
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      profileImage == null || profileImage!.isEmpty
                          ? const CircularProgressIndicator(strokeWidth: 2)
                          : CircleAvatar(
                            radius: avatarRadius,
                            backgroundImage: AssetImage(profileImage!),
                            onBackgroundImageError:
                                (_, __) => setState(() {
                                  profileImage = null;
                                }),
                          ),
                    ],
                  ),
                  SizedBox(width: padding * 1.5), // 30 -> نسبي
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            "0",
                            style: TextStyle(
                              fontSize: fontSizeMedium,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(width: padding * 0.3),
                          Text(
                            "نقطة",
                            style: TextStyle(fontSize: fontSizeSmall),
                          ),
                          SizedBox(width: padding * 0.4),
                          Icon(
                            Icons.local_fire_department,
                            color: Colors.orange,
                            size: fontSizeMedium,
                          ),
                        ],
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const FreeLeaderboard(),
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
                          padding: EdgeInsets.symmetric(horizontal: padding),
                        ),
                        child: Row(
                          children: [
                            Text(
                              "لوحة الصدارة",
                              style: TextStyle(
                                color: const Color.fromRGBO(80, 112, 92, 1),
                                fontSize: fontSizeSmall,
                              ),
                            ),
                            SizedBox(width: padding * 0.15),
                            Icon(
                              Icons.arrow_forward_ios,
                              color: const Color.fromRGBO(80, 112, 92, 1),
                              size: fontSizeMedium,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  const Icon(
                    Icons.notifications,
                    size: 24,
                    color: Color.fromRGBO(200, 200, 200, 1),
                  ),
                ],
              ),

              SizedBox(height: padding * 2.5), // 40 -> نسبي
              // Options
              buildOptionCard("ابدأ التمرين اليومي", () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const PlanPage()),
                );
              }),
              SizedBox(height: padding * 1.2), // 20 -> نسبي

              Text(
                "مساحتك الآمنة للتحدث والتعلم",
                style: TextStyle(
                  color: const Color.fromRGBO(78, 78, 78, 1),
                  fontWeight: FontWeight.bold,
                  fontSize: fontSizeMedium,
                ),
              ),

              SizedBox(height: padding * 1.2), // 20 -> نسبي

              buildOptionCardtwo(
                "ناقش استراتيجياتك الشخصية، واحصل على تغذية راجعة فورية، وحسّن أدائك",
                () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ChatPage()),
                  );
                },
              ),
              SizedBox(height: padding * 1.5), // 30 -> نسبي

              Center(
                child: GestureDetector(
                  onTap: () {
                    showCommunityDialog(context);
                  },
                  child: Image.asset(
                    "assets/images/coach comunity.png",
                    width: size.width * 0.9,
                    height: size.height * 0.25,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
