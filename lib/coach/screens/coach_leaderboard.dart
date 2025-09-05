
import 'package:calmleticsarab/http/api.dart';
import 'package:calmleticsarab/widgets/leaderboard_item.dart';
import 'package:calmleticsarab/widgets/leaderboard_tab_bar.dart';
import 'package:calmleticsarab/widgets/top_three.dart';
import 'package:flutter/material.dart';


class CoachLeaderboard extends StatefulWidget {
  final String communityId;

  const CoachLeaderboard({super.key, required this.communityId});

  @override
  State<CoachLeaderboard> createState() => _CoachLeaderboardState();
}

class _CoachLeaderboardState extends State<CoachLeaderboard> {
  String selectedTab = 'يوميا';

  List<Map<String, dynamic>> topThreeInCoach = [];
  List<Map<String, dynamic>> otherUsers = [];
  bool isLoading = true;

  Future<void> fetchLeaderboardData(String time) async {
    final data = await Api.fetchCoachLeaderboard(widget.communityId, time);

    setState(() {
      topThreeInCoach = data['top3'] ?? [];
      otherUsers = data['others'] ?? [];
      isLoading = false;
    });
  }

  void onTabSelected(String tab) {
    setState(() {
      selectedTab = tab;
      isLoading = true;
    });
    fetchLeaderboardData(tab.toLowerCase());
  }

  @override
  void initState() {
    super.initState();
    fetchLeaderboardData("اسبوعيا");
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final screenWidth = media.size.width;
    final screenHeight = media.size.height;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'لوحة الصدارة ',
          style: TextStyle(color: Colors.black),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: const Color.fromRGBO(255, 252, 249, 1),
        elevation: 0,
      ),
      backgroundColor: const Color.fromRGBO(255, 252, 249, 1),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: screenWidth * 0.04,
              vertical: screenHeight * 0.015,
            ),
            child: Column(
              children: [
                LeaderboardTabBar(
                  selectedTab: selectedTab,
                  onTabSelected: onTabSelected,
                ),
                SizedBox(height: screenHeight * 0.025),
                topThreeInCoach.isNotEmpty
                    ? TopThree(topUsers: topThreeInCoach)
                    : const Center(child: Text("No top users available")),
              ],
            ),
          ),
          SizedBox(height: screenHeight * 0.02),
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                color: Color.fromRGBO(255, 252, 249, 1),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Color.fromRGBO(0, 0, 0, 0.1),
                    spreadRadius: 3,
                    blurRadius: 8,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
                child: isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : otherUsers.isNotEmpty
                        ? ListView.separated(
                            itemCount: otherUsers.length,
                            separatorBuilder: (_, __) =>
                                SizedBox(height: screenHeight * 0.015),
                            itemBuilder: (context, index) {
                              final user = otherUsers[index];
                              return LeaderboardItem(
                                rank: user['rank'],
                                name: user['name'],
                                points: user['total_score'],
                                imagePath: user['image'] ??
                                    'assets/images/default.png',
                              );
                            },
                          )
                        : const Center(
                            child: Text("No users in the leaderboard"),
                          ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
