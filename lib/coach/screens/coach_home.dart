// ignore_for_file: prefer_const_constructors

import 'package:calmleticsarab/coach/VR/vr_schedula.dart';
import 'package:calmleticsarab/coach/screens/all_community.dart';
import 'package:calmleticsarab/coach/screens/community_pop_code.dart';
import 'package:calmleticsarab/coach/screens/create_community.dart';
import 'package:calmleticsarab/coach/screens/players.dart';
import 'package:calmleticsarab/coach/widget/bottom_navigation_bar.dart';
import 'package:calmleticsarab/coach/widgetsOfHome/community_card.dart';
import 'package:calmleticsarab/coach/widgetsOfHome/player_progress_card.dart';
import 'package:calmleticsarab/coach/widgetsOfHome/stats_card.dart';
import 'package:calmleticsarab/http/api.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class CoachHome extends StatefulWidget {
  const CoachHome({super.key});

  @override
  State<CoachHome> createState() => _CoachHomeState();
}

class _CoachHomeState extends State<CoachHome> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  final List<Widget> _screens = [
    const HomeContent(),
    VRScheduleScreen(),
    Players(),
    const AllCommunity(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(255, 252, 249, 1),
      bottomNavigationBar: CustomBottomNavigationBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CreateCommunity()),
          );
        },
        backgroundColor: const Color.fromRGBO(106, 149, 122, 1),
        shape: const CircleBorder(),
        child: const Icon(Icons.add, color: Colors.white, size: 28),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: IndexedStack(index: _selectedIndex, children: _screens),
    );
  }
}

class HomeContent extends StatefulWidget {
  const HomeContent({super.key});

  @override
  State<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  String? profileImage;
  final Api api = Api();

  List<Map<String, dynamic>> communities = [];
  List<Map<String, dynamic>> players = [];
  int? playerCount;

  final String baseUrl = 'https://calmletics-production.up.railway.app';

  @override
  void initState() {
    super.initState();
    loadUserProfile();
    loadCommunities();
    loadPlayers();
    loadPlayerCount();
  }

  Future<void> loadUserProfile() async {
    try {
      final userData = await api.fetchUserData();
      if (userData != null && mounted) {
        setState(() {
          profileImage = userData['image'];
        });
      }
    } catch (e) {
      if (kDebugMode) print('Error loading user profile: $e');
    }
  }

  Future<void> loadCommunities() async {
    try {
      final data = await api.fetchCommunities();
      if (mounted) setState(() => communities = data);
    } catch (e) {
      if (kDebugMode) print('Error loading communities: $e');
    }
  }

  Future<void> loadPlayers() async {
    try {
      final data = await api.fetchPlayers();
      if (mounted) setState(() => players = data);
    } catch (e) {
      if (kDebugMode) print('Error loading players: $e');
    }
  }

  Future<void> loadPlayerCount() async {
    try {
      final count = await api.fetchPlayerCount();
      if (mounted) setState(() => playerCount = count);
    } catch (e) {
      if (kDebugMode) print('Error loading player count: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final width = media.size.width;
    final height = media.size.height;
    final isTablet = width > 600;

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.all(width * 0.04),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: height * 0.03),

              /// Top bar (profile + notifications)
              Row(
                children: [
                  Container(
                    height: isTablet ? 100 : 75,
                    width: isTablet ? 100 : 75,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      border: Border.all(
                        color: const Color.fromRGBO(226, 226, 226, 1),
                        width: 1,
                      ),
                    ),
                    child: profileImage == null || profileImage!.isEmpty
                        ? const CircularProgressIndicator()
                        : CircleAvatar(
                            radius: 32,
                            backgroundImage: AssetImage(profileImage!),
                            onBackgroundImageError: (_, __) => setState(() {
                              profileImage = null;
                            }),
                          ),
                  ),
                  const Spacer(),
                  const Icon(Icons.notifications, size: 32, color: Colors.grey),
                ],
              ),
              SizedBox(height: height * 0.02),

              /// Community section
              _buildSectionHeader(
                context,
                title: 'المجتمع',
                onSeeAll: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          const AllCommunity(showBottomBar: true),
                    ),
                  );
                },
              ),
              SizedBox(
                height: height * 0.2,
                child: communities.isEmpty
                    ? const Center(child: Text('No communities found'))
                    : ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: communities.take(2).length,
                        separatorBuilder: (_, __) =>
                            SizedBox(width: width * 0.03),
                        itemBuilder: (context, index) {
                          final community = communities.take(2).toList()[index];
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => CommunityPopCode(
                                    communityId:
                                        community['community_id'].toString(),
                                    otpCode: community['code'] ?? 'N/A',
                                  ),
                                ),
                              );
                            },
                            child: CommunityCard(
                              cardWidth: isTablet ? 400 : 323,
                              title: community['name'],
                              level: community['level'],
                              players: community['players_count'],
                              date: community['created_at'],
                            ),
                          );
                        },
                      ),
              ),

              /// Player Progress Section
              _buildSectionHeader(
                context,
                title: 'تقدم اللاعبون',
                onSeeAll: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Players(showBottomBar: true),
                    ),
                  );
                },
              ),
              if (players.isEmpty)
                const Center(child: Text('No players found'))
              else
                Column(
                  children: players.take(2).map((player) {
                    return Padding(
                      padding: EdgeInsets.only(bottom: height * 0.015),
                      child: PlayerProgressCard(
                        playerName: player['player_name'] ?? 'Unknown',
                        communityName: player['community_name'] ?? 'Unknown',
                        statusMessage: player['status_message'] ?? 'No status',
                        playerImage: player['image'],
                        imageUrl: player['status_image'] != null
                            ? '$baseUrl${player['status_image']}'
                            : '',
                      ),
                    );
                  }).toList(),
                ),

              /// Stats Section
              SizedBox(height: height * 0.02),
              Row(
                children: [
                  Expanded(
                    child: StatsCard(
                      title: 'إجمالي اللاعبين',
                      value: playerCount?.toString() ?? '0',
                      iconPath: 'assets/images/tabler_play-football.png',
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: StatsCard(
                      title: 'الجلسات اليوم',
                      value: '6',
                      iconPath: 'assets/images/Group.png',
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(
    BuildContext context, {
    required String title,
    required VoidCallback onSeeAll,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const Spacer(),
          TextButton(
            onPressed: onSeeAll,
            child: const Text(
              'عرض الكل',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }
}
