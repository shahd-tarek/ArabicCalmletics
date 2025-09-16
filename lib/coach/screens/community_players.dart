// ignore_for_file: avoid_print


import 'package:calmleticsarab/coach/tabbars/player_tab_bar.dart';
import 'package:calmleticsarab/coach/widgetsOfHome/player_progress_card.dart';
import 'package:calmleticsarab/http/api.dart';
import 'package:flutter/material.dart';


class CommPlayers extends StatefulWidget {
  final bool showBottomBar;
  final String communityId; // Required community ID

  const CommPlayers({
    super.key,
    required this.communityId,
    this.showBottomBar = false,
  });

  @override
  State<CommPlayers> createState() => _CommPlayersState();
}

class _CommPlayersState extends State<CommPlayers> {
  String? status;
  List<Map<String, dynamic>> players = [];
  bool isLoading = true;

  final String baseUrl = 'https://calmletics-production.up.railway.app';

  @override
  void initState() {
    super.initState();
    _fetchPlayers();
  }

  Future<void> _fetchPlayers() async {
    setState(() => isLoading = true);

    try {
      final fetchedPlayers = await Api.fetchCommunityFilterplayer(
        widget.communityId,
        status ?? 'الكل',
      );

      setState(() {
        players = fetchedPlayers;
        isLoading = false;
      });
    } catch (e) {
      print("Error fetching players: $e");
      setState(() => isLoading = false);
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
                      hintText: "البحث",
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
                            final player = players[index];
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
    );
  }
}
