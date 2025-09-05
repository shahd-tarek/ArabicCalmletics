// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:calmleticsarab/http/api.dart';
import 'package:calmleticsarab/widgets/leaderboard_item.dart';
import 'package:calmleticsarab/widgets/leaderboard_tab_bar.dart';
import 'package:calmleticsarab/widgets/top_three.dart';

class FreeLeaderboard extends StatefulWidget {
  const FreeLeaderboard({super.key});

  @override
  State<FreeLeaderboard> createState() => _FreeLeaderboardState();
}

class _FreeLeaderboardState extends State<FreeLeaderboard> {
  String selectedTab = 'Daily';

  List<Map<String, dynamic>> topThreeFree = [];
  List<Map<String, dynamic>> otherUsers = [];
  bool isLoading = true;

  Future<void> fetchFreeLeaderboardData(String time) async {
    final data = await Api.fetchFreeLeaderboard(time);

    setState(() {
      topThreeFree = data['top3'] ?? [];
      otherUsers = data['others'] ?? [];
      isLoading = false;
    });
  }

  void onTabSelected(String tab) {
    setState(() {
      selectedTab = tab;
      isLoading = true;
    });
    fetchFreeLeaderboardData(tab.toLowerCase());
  }

  @override
  void initState() {
    super.initState();
    fetchFreeLeaderboardData("weekly");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('لوحة الصدارة'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: const Color.fromRGBO(255, 252, 249, 1),
      ),
      backgroundColor: const Color.fromRGBO(255, 252, 249, 1),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final screenWidth = constraints.maxWidth;
          final screenHeight = constraints.maxHeight;

          // حساب القيم النسبية
          final padding = screenWidth * 0.04; // ~16px عند 400px
          final borderRadius = screenWidth * 0.08; // ~32px
          final fontSizeMedium = screenWidth * 0.045; // ~18px
          final boxShadowSpread = screenWidth * 0.02; // ~8px
          final boxShadowBlur = screenWidth * 0.04; // ~16px
          final sectionSpacing = screenHeight * 0.015; // ~12px

          return Column(
            children: [
              Padding(
                padding: EdgeInsets.only(
                  top: padding,
                  left: padding,
                  right: padding,
                ),
                child: Column(
                  children: [
                    LeaderboardTabBar(
                      selectedTab: selectedTab,
                      onTabSelected: onTabSelected,
                    ),
                    SizedBox(height: sectionSpacing),
                    topThreeFree.isNotEmpty
                        ? TopThree(topUsers: topThreeFree)
                        : Text(
                          "غير متاح لاعبيين",
                          style: TextStyle(fontSize: fontSizeMedium),
                        ),
                  ],
                ),
              ),
              SizedBox(height: sectionSpacing),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color.fromRGBO(255, 252, 249, 1),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(borderRadius),
                      topRight: Radius.circular(borderRadius),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color.fromRGBO(0, 0, 0, 0.2),
                        spreadRadius: boxShadowSpread,
                        blurRadius: boxShadowBlur,
                        offset: Offset(0, screenHeight * 0.01), // ~4px
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: padding),
                    child:
                        isLoading
                            ? const Center(child: CircularProgressIndicator())
                            : otherUsers.isNotEmpty
                            ? ListView.builder(
                              itemCount: otherUsers.length,
                              itemBuilder: (context, index) {
                                final user = otherUsers[index];
                                return Padding(
                                  padding: EdgeInsets.symmetric(
                                    vertical: screenHeight * 0.005,
                                  ),
                                  child: LeaderboardItem(
                                    rank: user['rank'],
                                    name: user['name'],
                                    points: user['total_score'],
                                    imagePath:
                                        user['image'] ??
                                        'assets/images/default.png',
                                  ),
                                );
                              },
                            )
                            : Center(
                              child: Text(
                                "لا يوجد لاعبيين في لوحة الصدارة",
                                style: TextStyle(fontSize: fontSizeMedium),
                              ),
                            ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
