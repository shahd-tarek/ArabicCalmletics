import 'package:flutter/material.dart';
import 'package:calmleticsarab/coach/screens/coach_home.dart';
import 'package:calmleticsarab/coach/screens/coach_leaderboard.dart';
import 'package:calmleticsarab/coach/screens/community_players.dart';
import 'package:calmleticsarab/coach/screens/edit_community.dart';
import 'package:calmleticsarab/coach/widgetsOfHome/player_progress_card.dart';
import 'package:calmleticsarab/coach/widgetsOfHome/stats_card.dart';
import 'package:calmleticsarab/http/api.dart';
import 'package:calmleticsarab/widgets/leaderboard_item.dart';

class CommunityPopCode extends StatefulWidget {
  final String communityId;
  final String otpCode;

  const CommunityPopCode({
    super.key,
    required this.communityId,
    required this.otpCode,
  });

  @override
  State<CommunityPopCode> createState() => _CommunityPopCodeState();
}

class _CommunityPopCodeState extends State<CommunityPopCode> {
  String? communityCode;
  String? communityName;
  String? communityLevel;
  int? playersCount;
  List<Map<String, dynamic>> sessions = [];
  List<Map<String, dynamic>> players = [];
  List<Map<String, dynamic>> topPlayers = [];
  bool isTopPlayersLoading = true;
  final String baseUrl = 'https://calmletics-production.up.railway.app';

  bool isLoading = true;

  String? playerName;
  String? statusMessage;
  String? imageUrl;

  @override
  void initState() {
    super.initState();
    fetchCommunityData();
    fetchTopPlayers();
  }

  Future<void> fetchTopPlayers() async {
    setState(() => isTopPlayersLoading = true);
    final players = await Api.fetchTopplayer(widget.communityId);
    print('Fetched top players: $players');
    setState(() {
      topPlayers = players;
      isTopPlayersLoading = false;
    });
  }

  Future<void> fetchCommunityData() async {
    final data = await Api.comDetails(widget.communityId);
    final fetchedComPlayers = await Api.fetchCommunityplayer(
      widget.communityId,
    );

    if (data.isNotEmpty) {
      setState(() {
        communityCode = data['community_code'];
        communityName = data['community_name'] ?? "Unknown";
        playersCount = data['players_count'] ?? 0;
        communityLevel = data['community_level'];
        sessions = List<Map<String, dynamic>>.from(data['sessions'] ?? []);
        players = fetchedComPlayers;
        isLoading = false;
      });
    } else {
      setState(() {
        communityCode = "Error loading code";
        isLoading = false;
      });
    }
  }

  Color getBackgroundColor(String? level) {
    if (level == "Low") return const Color.fromRGBO(239, 255, 206, 1);
    if (level == "Moderate") return const Color.fromRGBO(254, 251, 226, 1);
    if (level == "High") return const Color.fromRGBO(255, 235, 228, 1);
    return Colors.grey.shade200;
  }

  Color getTextColor(String? level) {
    if (level == "Low") return const Color.fromRGBO(153, 194, 70, 1);
    if (level == "Moderate") return const Color.fromRGBO(212, 193, 17, 1);
    if (level == "High") return const Color.fromRGBO(212, 60, 10, 1);
    return Colors.black;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(255, 252, 249, 1),
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(255, 252, 249, 1),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          Theme(
            data: Theme.of(context).copyWith(
              popupMenuTheme: PopupMenuThemeData(
                color: const Color.fromRGBO(255, 255, 255, 1),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            child: PopupMenuButton<String>(
              icon: const Icon(Icons.list, color: Colors.black),
              onSelected: (String value) {
                if (value == 'edit') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) =>
                              EditCommunity(communityId: widget.communityId),
                    ),
                  );
                } else if (value == 'delete') {
                  delateCommunityDialog(context);
                }
              },
              itemBuilder:
                  (BuildContext context) => [
                    PopupMenuItem<String>(
                      value: 'edit',
                      child: ListTile(
                        leading: const Icon(Icons.edit),
                        title: const Text(
                          'Edit community',
                          style: TextStyle(
                            color: Color.fromRGBO(78, 78, 78, 1),
                            fontSize: 16,
                          ),
                        ),
                        tileColor: const Color.fromRGBO(255, 255, 255, 1),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                    PopupMenuItem<String>(
                      value: 'delete',
                      child: ListTile(
                        leading: const Icon(
                          Icons.delete,
                          color: Color.fromRGBO(218, 43, 82, 1),
                        ),
                        title: const Text(
                          'Delete',
                          style: TextStyle(
                            color: Color.fromRGBO(218, 43, 82, 1),
                            fontSize: 16,
                          ),
                        ),
                        tileColor: const Color.fromRGBO(255, 255, 255, 1),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ],
            ),
          ),
        ],
      ),
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Row(
                        children: [
                          const CircleAvatar(
                            radius: 30,
                            backgroundColor: Colors.black12,
                            backgroundImage: AssetImage(
                              'assets/images/Coach 3.png',
                            ),
                          ),
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    communityName ?? '',
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: getBackgroundColor(communityLevel),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      communityLevel ?? '',
                                      style: TextStyle(
                                        color: getTextColor(communityLevel),
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color.fromRGBO(233, 239, 235, 1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.message,
                                      color: Color.fromRGBO(80, 112, 92, 1),
                                      size: 16,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      communityCode ?? '',
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Color.fromRGBO(80, 112, 92, 1),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Plan',
                      style: TextStyle(
                        color: Color.fromRGBO(78, 78, 78, 1),
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children:
                            sessions.map((session) {
                              double progress =
                                  double.tryParse(
                                    session['completion_percentage']
                                            ?.replaceAll('%', '') ??
                                        '0',
                                  )! /
                                  100;
                              return Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: _buildPlanCard(
                                  session['session_number'] ?? '',
                                  session['session_name'] ?? '',
                                  progress,
                                ),
                              );
                            }).toList(),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        StatsCard(
                          title: 'Total Players',
                          value: playersCount?.toString() ?? '0',
                          iconPath: 'assets/images/tabler_play-football.png',
                        ),
                        const Spacer(),
                        const StatsCard(
                          title: 'Sessions Today',
                          value: '3',
                          iconPath: 'assets/images/Group.png',
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        _buildIconButton("Edit player", Icons.edit),
                        const SizedBox(width: 100),
                        _buildIconButton("View schedule", Icons.calendar_month),
                      ],
                    ),
                    const SizedBox(height: 20),
                    _buildSectionHeader("Top player", "Leader board"),
                    const SizedBox(height: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // عرض التوب بلايرز
                        isTopPlayersLoading
                            ? const Center(child: CircularProgressIndicator())
                            : topPlayers.isEmpty
                            ? const Center(child: Text('No top players found'))
                            : Column(
                              children:
                                  topPlayers.asMap().entries.map((entry) {
                                    int index = entry.key;
                                    Map<String, dynamic> player = entry.value;

                                    return Padding(
                                      padding: const EdgeInsets.only(
                                        bottom: 8.0,
                                      ),
                                      child: LeaderboardItem(
                                        rank: player['rank'] ?? index + 1,
                                        name: player['name'] ?? 'Unknown',
                                        points: player['total_score'] ?? 0,
                                        imagePath:
                                            player['image'] != null &&
                                                    player['image']!.isNotEmpty
                                                ? (player['image']!.startsWith(
                                                      'assets/',
                                                    )
                                                    ? player['image']
                                                    : '$baseUrl${player['image']}')
                                                : 'assets/images/avatar5.png',
                                      ),
                                    );
                                  }).toList(),
                            ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Text(
                          'Player Progress',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Spacer(),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) => CommPlayers(
                                      communityId: widget.communityId,
                                      showBottomBar: true,
                                    ),
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
                          const Center(child: Text('No players found'))
                        else
                          Column(
                            children:
                                players.take(2).map((player) {
                                  return Padding(
                                    padding: const EdgeInsets.only(
                                      bottom: 16.0,
                                    ),
                                    child: PlayerProgressCard(
                                      playerName:
                                          player['player_name'] ?? 'Unknown',
                                      communityName:
                                          player['community_name'] ?? 'Unknown',
                                      statusMessage:
                                          player['status_message'] ??
                                          'No status',
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
                  ],
                ),
              ),
    );
  }

  Widget _buildPlanCard(String sessions, String title, double progress) {
    return Container(
      width: 377,
      height: 130,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.grey.withOpacity(0.2), width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              sessions,
              style: const TextStyle(
                fontSize: 14,
                color: Color.fromRGBO(133, 133, 133, 1),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color.fromRGBO(66, 66, 66, 0.8),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                SizedBox(
                  width: 217,
                  height: 19,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    child: LinearProgressIndicator(
                      value: progress,
                      backgroundColor: const Color.fromRGBO(237, 237, 237, 1),
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        Color.fromRGBO(106, 149, 122, 1),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '${(progress * 100).toInt()}%',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color.fromRGBO(78, 78, 78, 1),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIconButton(String title, IconData icon) {
    return Row(
      children: [
        Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            color: const Color.fromRGBO(106, 149, 122, 1),
            borderRadius: BorderRadius.circular(5),
          ),
          child: Center(child: Icon(icon, size: 16, color: Colors.white)),
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            color: Color.fromRGBO(78, 78, 78, 1),
          ),
        ),
      ],
    );
  }

  Widget _buildSectionHeader(String title, String actionText) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder:
                    (context) =>
                        CoachLeaderboard(communityId: widget.communityId),
              ),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color.fromRGBO(233, 239, 235, 1),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16),
          ),
          child: const Row(
            children: [
              Text(
                "Leader board",
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
    );
  }

  Future<void> delateCommunityDialog(BuildContext context) async {
    bool isDeleting = false;

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Dialog(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Align(
                      alignment: Alignment.topRight,
                      child: Container(
                        height: 48,
                        width: 48,
                        decoration: BoxDecoration(
                          color: const Color.fromRGBO(218, 43, 82, 1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: IconButton(
                          icon: const Icon(
                            Icons.close,
                            color: Colors.white,
                            size: 32,
                          ),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ),
                    ),
                    const SizedBox(height: 60),
                    Container(
                      width: 112,
                      height: 112,
                      decoration: BoxDecoration(
                        color: const Color.fromRGBO(255, 235, 228, 1),
                        borderRadius: BorderRadius.circular(500),
                      ),
                      child: const Icon(
                        Icons.delete,
                        color: Color.fromRGBO(218, 43, 82, 1),
                        size: 64,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      "Remove this community",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Color.fromRGBO(78, 78, 78, 1),
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'This community all associated data will\nbe permanently deleted. Do you want to\nproceed?',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: Color.fromRGBO(78, 78, 78, 1),
                      ),
                    ),
                    const SizedBox(height: 50),
                    Row(
                      children: [
                        SizedBox(
                          width: 145,
                          height: 52,
                          child: ElevatedButton(
                            onPressed:
                                isDeleting
                                    ? null
                                    : () {
                                      Navigator.pop(context);
                                    },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                                side: const BorderSide(
                                  color: Color.fromRGBO(78, 78, 78, 1),
                                  width: 1,
                                ),
                              ),
                            ),
                            child: const Text(
                              "Cancel",
                              style: TextStyle(
                                color: Color.fromRGBO(78, 78, 78, 1),
                                fontSize: 20,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        SizedBox(
                          width: 145,
                          height: 52,
                          child: ElevatedButton(
                            onPressed:
                                isDeleting
                                    ? null
                                    : () async {
                                      setState(() => isDeleting = true);
                                      try {
                                        final result =
                                            await Api.delateCommunity(
                                              widget.communityId,
                                            );

                                        if (result['success'] == true) {
                                          Navigator.pop(context);
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder:
                                                  (context) =>
                                                      const CoachHome(),
                                            ),
                                          );
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            SnackBar(
                                              content: Text(result['message']),
                                              backgroundColor: Colors.green,
                                            ),
                                          );
                                        } else {
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                result['error'] ??
                                                    'Failed to delete community',
                                              ),
                                              backgroundColor: Colors.red,
                                            ),
                                          );
                                          Navigator.pop(context);
                                        }
                                      } catch (e) {
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          SnackBar(
                                            content: Text('Error: $e'),
                                            backgroundColor: Colors.red,
                                          ),
                                        );
                                        Navigator.pop(context);
                                      }
                                    },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color.fromRGBO(
                                218,
                                43,
                                82,
                                1,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            child: Text(
                              isDeleting ? "Deleting..." : "Delete",
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
