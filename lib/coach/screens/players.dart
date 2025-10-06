// ignore_for_file: avoid_print

import 'package:calmleticsarab/coach/VR/vr_schedula.dart';
import 'package:calmleticsarab/coach/screens/all_community.dart';
import 'package:calmleticsarab/coach/screens/coach_home.dart';
import 'package:calmleticsarab/coach/tabbars/player_tab_bar.dart';
import 'package:calmleticsarab/coach/widget/bottom_navigation_bar.dart';
import 'package:calmleticsarab/coach/widgetsOfHome/player_progress_card.dart';
import 'package:calmleticsarab/http/api.dart';
import 'package:flutter/material.dart';

class Players extends StatefulWidget {
  final bool showBottomBar;

  const Players({super.key, this.showBottomBar = false});

  @override
  State<Players> createState() => _PlayersState();
}

class _PlayersState extends State<Players> {
  String? status;
  int _selectedIndex = 2;
  final Api api = Api();

  List<Map<String, dynamic>> players = [];
  bool isLoading = true;
  final String baseUrl = 'https://calmletics-production.up.railway.app';

  @override
  void initState() {
    super.initState();
    _fetchPlayers();
  }

  Future<void> _fetchPlayers() async {
    List<Map<String, dynamic>> fetchedPlayers = [];

    if (status == null || status!.toLowerCase() == 'الكل') {
      fetchedPlayers = await api.fetchPlayers(); // جلب جميع اللاعبين
    } else {
      fetchedPlayers = await api.fetchFilteredPlayers(
        status!,
      ); // جلب اللاعبين حسب الحالة
    }

    setState(() {
      players = fetchedPlayers;
      isLoading = false;
    });
  }

  void _onItemTapped(int index) {
    if (index != _selectedIndex) {
      setState(() {
        _selectedIndex = index;
      });
      _navigateToScreen(index);
    }
  }

  void _navigateToScreen(int index) {
    switch (index) {
      case 0:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const CoachHome()),
        );
        break;
      case 1:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => VRScheduleScreen()),
        );
        break;
      case 2:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const Players()),
        );
        break;
      case 3:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const AllCommunity()),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(255, 252, 249, 1),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 40),
            Row(
              children: [
                Container(
                  width: 42,
                  height: 39,
                  decoration: BoxDecoration(
                    color: const Color.fromRGBO(106, 149, 122, 1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: GestureDetector(
                    onTap: () {},
                    child: Image.asset('assets/images/setting-4.png'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: "ابحث",
                      prefixIcon: const Icon(Icons.search, color: Colors.grey),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            PlayerTabBar(
              selectedTab: status ?? 'الكل',
              onTabSelected: (tab) {
                setState(() {
                  status = tab;
                  isLoading = true;
                });
                _fetchPlayers();
              },
            ),
            const SizedBox(height: 16),
            const Text(
              "اللاعبون",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color.fromRGBO(78, 78, 78, 1),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : players.isEmpty
                      ? const Center(child: Text("No players found"))
                      : ListView.builder(
                          itemCount: players.length,
                          itemBuilder: (context, index) {
                            var player = players[index];

                            return PlayerProgressCard(
                              playerName: player['player_name'] ?? 'Unknown',
                              communityName:
                                  player['community_name'] ?? 'Unknown',
                              statusMessage:
                                  player['status_message'] ?? 'No status',
                              playerImage: player['image'],
                              imageUrl: player['status_image'] != null
                                  ? '$baseUrl${player['status_image']}'
                                  : '',
                            );
                          },
                        ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: widget.showBottomBar
          ? CustomBottomNavigationBar(
              selectedIndex: _selectedIndex,
              onItemTapped: _onItemTapped,
            )
          : null,
      floatingActionButton: widget.showBottomBar
          ? FloatingActionButton(
              onPressed: () {
                print("FAB tapped");
              },
              backgroundColor: const Color.fromRGBO(106, 149, 122, 1),
              child: const Icon(Icons.add, color: Colors.white, size: 28),
            )
          : null,
      floatingActionButtonLocation: widget.showBottomBar
          ? FloatingActionButtonLocation.centerDocked
          : null,
    );
  }
}
