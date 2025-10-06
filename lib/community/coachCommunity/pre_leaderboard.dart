import 'package:flutter/material.dart';
import 'package:calmleticsarab/http/api.dart';
import 'package:calmleticsarab/widgets/leaderboard_item.dart';
import 'package:calmleticsarab/widgets/leaderboard_tab_bar.dart';
import 'package:calmleticsarab/widgets/top_three.dart';

class PreLeaderboard extends StatefulWidget {
  const PreLeaderboard({super.key});

  @override
  State<PreLeaderboard> createState() => _PreLeaderboardState();
}

class _PreLeaderboardState extends State<PreLeaderboard> {
  String selectedTab = 'Daily';

  List<Map<String, dynamic>> topThreePre = [];
  List<Map<String, dynamic>> otherUsers = [];
  bool isLoading = true;

  Future<void> fetchPreLeaderboardData(String time) async {
    final data = await Api.fetchPreLeaderboard(time);

    setState(() {
      topThreePre = data['top3'] ?? [];
      otherUsers = data['others'] ?? [];
      isLoading = false;
    });
  }

  void onTabSelected(String tab) {
    setState(() {
      selectedTab = tab;
      isLoading = true;
    });
    fetchPreLeaderboardData(tab.toLowerCase());
  }

  @override
  void initState() {
    super.initState();
    fetchPreLeaderboardData("weekly");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("لوحة الصدارة"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: const Color.fromRGBO(255, 252, 249, 1),
      ),
      backgroundColor: const Color.fromRGBO(255, 252, 249, 1),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
            child: Column(
              children: [
                LeaderboardTabBar(
                  selectedTab: selectedTab,
                  onTabSelected: onTabSelected,
                ),
                const SizedBox(height: 20),
                topThreePre.isNotEmpty
                    ? TopThree(topUsers: topThreePre)
                    : const Center(child: Text("No top users available")),
              ],
            ),
          ),
          const SizedBox(height: 16),
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
                    color: Color.fromRGBO(0, 0, 0, 0.2),
                    spreadRadius: 4,
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : otherUsers.isNotEmpty
                        ? ListView.builder(
                            itemCount: otherUsers.length,
                            itemBuilder: (context, index) {
                              final user = otherUsers[index];
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8),
                                child: LeaderboardItem(
                                  rank: user['rank'],
                                  name: user['name'],
                                  points: user['total_score'],
                                  imagePath: user['image'] ??
                                      'assets/images/default.png',
                                ),
                              );
                            },
                          )
                        : const Center(
                            child: Text("لا يوجد لاعبيين في لوحة الصدارة"),
                          ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
