import 'package:flutter/material.dart';
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
import 'package:calmleticsarab/views/user_profile.dart';

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
    const VRScheduleScreen(),
    const Players(),
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
            MaterialPageRoute(builder: (context) => const CreateCommunity()),
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

  Future<void> loadUserProfile() async {
    try {
      final userData = await api.fetchUserData();
      if (userData != null && mounted) {
        setState(() {
          profileImage = userData['image'];
        });
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error loading user profile: $e');
      }
    }
  }

  Future<void> loadCommunities() async {
    try {
      final data = await api.fetchCommunities();
      if (mounted) {
        setState(() {
          communities = data;
        });
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error loading communities: $e');
      }
    }
  }

  Future<void> loadPlayers() async {
    try {
      final data = await api.fetchPlayers();
      if (mounted) {
        setState(() {
          players = data;
        });
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error loading players: $e');
      }
    }
  }

  Future<void> loadPlayerCount() async {
    try {
      final count = await api.fetchPlayerCount();
      if (mounted) {
        setState(() {
          playerCount = count;
        });
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error loading player count: $e');
      }
    }
  }

  @override
  void initState() {
    super.initState();
    loadUserProfile();
    loadCommunities();
    loadPlayers();
    loadPlayerCount();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 40),
            Row(
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
                  child: Container(
                    height: 70,
                    width: 70,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      border: Border.all(
                        color: const Color.fromRGBO(226, 226, 226, 1),
                        width: 1,
                      ),
                    ),
                    child:
                        profileImage == null || profileImage!.isEmpty
                            ? const CircularProgressIndicator()
                            : CircleAvatar(
                              radius: 32,
                              backgroundImage: AssetImage(profileImage!),
                              onBackgroundImageError:
                                  (_, __) => setState(() {
                                    profileImage = null;
                                  }),
                            ),
                  ),
                ),
                const Spacer(),
                const Icon(Icons.notifications, size: 32, color: Colors.grey),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Text(
                  'Community',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) =>
                                const AllCommunity(showBottomBar: true),
                      ),
                    );
                  },
                  child: const Text(
                    'See All',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 140,
              child:
                  communities.isEmpty
                      ? const Center(child: CircularProgressIndicator())
                      : ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: communities.take(2).length,
                        separatorBuilder: (_, __) => const SizedBox(width: 8),
                        itemBuilder: (context, index) {
                          final community = communities.take(2).toList()[index];
                          final communityId =
                              community['community_id'].toString();
                          final otpCode = community['code'] ?? 'N/A';

                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (context) => CommunityPopCode(
                                        communityId: communityId,
                                        otpCode: otpCode,
                                      ),
                                ),
                              );
                            },
                            child: CommunityCard(
                              cardWidth: 323,
                              title: community['name'],
                              level: community['level'],
                              players: community['players_count'],
                              date: community['created_at'],
                            ),
                          );
                        },
                      ),
            ),
            Row(
              children: [
                const Text(
                  'Player Progress',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                TextButton(
                  onPressed: () {
                    // No communityId is passed here when navigating from CoachHome
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) => const Players(showBottomBar: true),
                      ),
                    );
                  },
                  child: const Text(
                    'See All',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Column(
              children: [
                if (players.isEmpty)
                  const Center(child: CircularProgressIndicator())
                else
                  Column(
                    children:
                        players.take(2).map((player) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 16.0),
                            child: PlayerProgressCard(
                              playerName: player['player_name'] ?? 'Unknown',
                              communityName:
                                  player['community_name'] ?? 'Unknown',
                              statusMessage:
                                  player['status_message'] ?? 'No status',
                              playerImage: player['image'],
                              imageUrl:
                                  player['status_image'] != null
                                      ? '$baseUrl${player['status_image']}'
                                      : '',
                            ),
                          );
                        }).toList(),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                StatsCard(
                  title: 'Total Players',
                  value: playerCount?.toString() ?? '0',
                  iconPath: 'assets/images/tabler_play-football.png',
                ),
                const Spacer(),
                const StatsCard(
                  title: 'Sessions Today',
                  value: '6',
                  iconPath: 'assets/images/Group.png',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
