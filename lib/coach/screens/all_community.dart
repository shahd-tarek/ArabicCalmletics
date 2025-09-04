import 'package:flutter/material.dart';
import 'package:calmleticsarab/coach/VR/vr_schedula.dart';
import 'package:calmleticsarab/coach/screens/coach_home.dart';
import 'package:calmleticsarab/coach/screens/players.dart';
import 'package:calmleticsarab/coach/tabbars/community_tab_bar.dart';
import 'package:calmleticsarab/coach/widget/bottom_navigation_bar.dart';
import 'package:calmleticsarab/coach/widgetsOfHome/community_card.dart';
import 'package:calmleticsarab/http/api.dart';
import 'package:calmleticsarab/coach/screens/community_pop_code.dart';

class AllCommunity extends StatefulWidget {
  final bool showBottomBar;

  const AllCommunity({super.key, this.showBottomBar = false});

  @override
  State<AllCommunity> createState() => _AllCommunityState();
}

class _AllCommunityState extends State<AllCommunity> {
  String selectedTab = 'all';
  int _selectedIndex = 3;
  final Api api = Api();

  List<Map<String, dynamic>> communities = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchCommunities('all');
  }

  Future<void> fetchCommunities(String level) async {
    setState(() {
      isLoading = true;
    });

    try {
      final data = await api.fetchFilterCommunity(level);
      setState(() {
        communities = data;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Error fetching communities: $e');
    }
  }

  void _onItemTapped(int index) {
    if (index != _selectedIndex) {
      setState(() => _selectedIndex = index);
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
          MaterialPageRoute(builder: (context) => const VRScheduleScreen()),
        );
        break;
      case 2:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const Players()),
        );
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
            TextField(
              decoration: InputDecoration(
                hintText: "Search",
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
            const SizedBox(height: 20),
            CommunityTabBar(
              selectedTab: selectedTab,
              onTabSelected: (tab) {
                setState(() {
                  selectedTab = tab;
                });
                fetchCommunities(tab);
              },
            ),
            const SizedBox(height: 16),
            const Text(
              "Community",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color.fromRGBO(78, 78, 78, 1),
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child:
                  isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : communities.isEmpty
                      ? const Center(child: Text("No communities found"))
                      : ListView.builder(
                        itemCount: communities.length,
                        itemBuilder: (context, index) {
                          final community = communities[index];
                          final communityId =
                              community['community_id'].toString();
                          final code = community['code'] ?? 'N/A';

                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (context) => CommunityPopCode(
                                          communityId: communityId,
                                          otpCode: code,
                                        ),
                                  ),
                                );
                              },
                              child: CommunityCard(
                                cardWidth:
                                    MediaQuery.of(context).size.width.toInt(),
                                title: community['name'] ?? 'No Name',
                                level: community['level'] ?? 'N/A',
                                players: community['players_count'] ?? 0,
                                date: community['created_at'] ?? '',
                              ),
                            ),
                          );
                        },
                      ),
            ),
          ],
        ),
      ),
      bottomNavigationBar:
          widget.showBottomBar
              ? CustomBottomNavigationBar(
                selectedIndex: _selectedIndex,
                onItemTapped: _onItemTapped,
              )
              : null,
      floatingActionButton:
          widget.showBottomBar
              ? FloatingActionButton(
                onPressed: () => print("FAB tapped"),
                backgroundColor: const Color.fromRGBO(106, 149, 122, 1),
                child: const Icon(Icons.add, color: Colors.white, size: 28),
              )
              : null,
      floatingActionButtonLocation:
          widget.showBottomBar
              ? FloatingActionButtonLocation.centerDocked
              : null,
    );
  }
}
