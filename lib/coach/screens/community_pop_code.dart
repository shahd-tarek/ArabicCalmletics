// ignore_for_file: prefer_const_constructors_in_immutables, use_key_in_widget_constructors, deprecated_member_use, curly_braces_in_flow_control_structures, use_build_context_synchronously, avoid_print, prefer_const_constructors

import 'package:calmleticsarab/coach/screens/coach_home.dart';
import 'package:calmleticsarab/coach/screens/coach_leaderboard.dart';
import 'package:calmleticsarab/coach/screens/community_players.dart';
import 'package:calmleticsarab/coach/screens/edit_community.dart';
import 'package:calmleticsarab/coach/widgetsOfHome/player_progress_card.dart';
import 'package:calmleticsarab/coach/widgetsOfHome/stats_card.dart';
import 'package:calmleticsarab/http/api.dart';
import 'package:calmleticsarab/widgets/leaderboard_item.dart';
import 'package:flutter/material.dart';


class CommunityPopCode extends StatefulWidget {
  final String communityId;
  final String otpCode;

  CommunityPopCode({required this.communityId, required this.otpCode});

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

  @override
  void initState() {
    super.initState();
    fetchCommunityData();
    fetchTopPlayers();
  }

  Future<void> fetchTopPlayers() async {
    setState(() => isTopPlayersLoading = true);
    try {
      final playersData = await Api.fetchTopplayer(widget.communityId);
      print('Fetched top players: $playersData');
      setState(() {
        topPlayers = List<Map<String, dynamic>>.from(playersData);
        isTopPlayersLoading = false;
      });
    } catch (e) {
      print('Error fetching top players: $e');
      setState(() {
        isTopPlayersLoading = false;
        topPlayers = []; // Set to empty on error
      });
      // Optionally show a snackbar or error message to the user
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to load top players: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> fetchCommunityData() async {
    try {
      final data = await Api.comDetails(widget.communityId);
      final fetchedComPlayers =
          await Api.fetchCommunityplayer(widget.communityId);

      if (data.isNotEmpty) {
        setState(() {
          communityCode = data['community_code'];
          communityName = data['community_name'] ?? "Unknown";
          playersCount = data['players_count'] ?? 0;
          communityLevel = data['community_level'];
          sessions = List<Map<String, dynamic>>.from(data['sessions'] ?? []);
          players = List<Map<String, dynamic>>.from(fetchedComPlayers);
          isLoading = false;
        });
      } else {
        setState(() {
          communityCode = "Error loading code";
          isLoading = false;
        });
      }
    } catch (e) {
      print('Error fetching community data: $e');
      setState(() {
        isLoading = false;
        communityCode = "Error"; // Indicate an error state
        communityName = "Failed to load";
        playersCount = 0;
        communityLevel = "Unknown";
        sessions = [];
        players = [];
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to load community data: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Color getBackgroundColor(String? level) {
    if (level == "منخفض") return const Color.fromRGBO(239, 255, 206, 1);
    if (level == "متوسط") return const Color.fromRGBO(254, 251, 226, 1);
    if (level == "مرتفع") return const Color.fromRGBO(255, 235, 228, 1);
    return Colors.grey.shade200;
  }

  Color getTextColor(String? level) {
    if (level == "منخفض") return const Color.fromRGBO(153, 194, 70, 1);
    if (level == "متوسط") return const Color.fromRGBO(212, 193, 17, 1);
    if (level == "مرتفع") return const Color.fromRGBO(212, 60, 10, 1);
    return Colors.black;
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    // Define breakpoints for adaptiveness
    final bool isSmallScreen = screenWidth < 600;

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
                if (value == 'تعديل المجتمع') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditCommunity(
                        communityId: widget.communityId,
                      ),
                    ),
                  );
                } else if (value == 'حذف') {
                  delateCommunityDialog(context);
                }
              },
              itemBuilder: (BuildContext context) => [
                PopupMenuItem<String>(
                  value: 'تعديل المجتمع',
                  child: ListTile(
                    leading: const Icon(Icons.edit),
                    title: const Text(
                      'تعديل المجتمع',
                      style: TextStyle(
                          color: Color.fromRGBO(78, 78, 78, 1), fontSize: 16),
                    ),
                    tileColor: const Color.fromRGBO(255, 255, 255, 1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                PopupMenuItem<String>(
                  value: 'حذف',
                  child: ListTile(
                    leading: const Icon(Icons.delete,
                        color: Color.fromRGBO(218, 43, 82, 1)),
                    title: const Text(
                      'حذف',
                      style: TextStyle(
                          color: Color.fromRGBO(218, 43, 82, 1), fontSize: 16),
                    ),
                    tileColor: const Color.fromRGBO(255, 255, 255, 1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: isSmallScreen ? 16 : 24,
                vertical: 16,
              ),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  // Ensure content takes at least the height of the screen
                  minHeight: MediaQuery.of(context).size.height -
                      AppBar().preferredSize.height -
                      MediaQuery.of(context).padding.top,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Community Header
                    _buildCommunityHeader(isSmallScreen),
                    const SizedBox(height: 20),

                    // Plan Section
                    _buildPlanSection(isSmallScreen),
                    const SizedBox(height: 20),

                    // Stats Cards - Using Wrap for better responsiveness
                    _buildStatsCards(isSmallScreen),
                    const SizedBox(height: 20),

                    // Action Buttons - Using Wrap for better responsiveness
                    _buildActionButtons(isSmallScreen),
                    const SizedBox(height: 20),

                    // Top Players Section
                    _buildTopPlayersSection(),
                    const SizedBox(height: 20),

                    // Player Progress Section
                    _buildPlayerProgressSection(),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildCommunityHeader(bool isSmallScreen) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: isSmallScreen ? 30 : 40,
            backgroundColor: Colors.black12,
            backgroundImage: const AssetImage('assets/images/Coach 3.png'),
          ),
          SizedBox(width: isSmallScreen ? 12 : 16),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        communityName ?? '',
                        style: TextStyle(
                          fontSize: isSmallScreen ? 18 : 22,
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    SizedBox(width: 8),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: isSmallScreen ? 8 : 12,
                        vertical: isSmallScreen ? 4 : 6,
                      ),
                      decoration: BoxDecoration(
                        color: getBackgroundColor(communityLevel),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        communityLevel ?? '',
                        style: TextStyle(
                          color: getTextColor(communityLevel),
                          fontSize: isSmallScreen ? 12 : 14,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 4),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: isSmallScreen ? 12 : 16,
                    vertical: isSmallScreen ? 6 : 8,
                  ),
                  decoration: BoxDecoration(
                    color: const Color.fromRGBO(233, 239, 235, 1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.message,
                          color: const Color.fromRGBO(80, 112, 92, 1),
                          size: isSmallScreen ? 16 : 20),
                      SizedBox(width: 4),
                      Text(communityCode ?? '',
                          style: TextStyle(
                              fontSize: isSmallScreen ? 16 : 18,
                              fontWeight: FontWeight.bold,
                              color: const Color.fromRGBO(80, 112, 92, 1)))
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlanSection(bool isSmallScreen) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'الخطة',
          style: TextStyle(
            color: const Color.fromRGBO(78, 78, 78, 1),
            fontSize: isSmallScreen ? 20 : 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: sessions.map((session) {
              double progress = double.tryParse(
                      session['completion_percentage']?.replaceAll('%', '') ??
                          '0')! /
                  100;
              return Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: _buildPlanCard(
                  session['session_number'] ?? '',
                  session['session_name'] ?? '',
                  progress,
                  isSmallScreen,
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildPlanCard(
      String sessions, String title, double progress, bool isSmallScreen) {
    return Container(
      width: isSmallScreen ? 300 : 377,
      height: isSmallScreen ? 110 : 130,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.grey.withOpacity(0.2), width: 1),
      ),
      child: Padding(
        padding: EdgeInsets.all(isSmallScreen ? 12.0 : 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              sessions,
              style: TextStyle(
                fontSize: isSmallScreen ? 12 : 14,
                color: const Color.fromRGBO(133, 133, 133, 1),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: TextStyle(
                fontSize: isSmallScreen ? 14 : 16,
                fontWeight: FontWeight.bold,
                color: const Color.fromRGBO(66, 66, 66, 0.8),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                SizedBox(
                  width: isSmallScreen ? 180 : 217,
                  height: 19,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    child: LinearProgressIndicator(
                      value: progress,
                      backgroundColor: const Color.fromRGBO(237, 237, 237, 1),
                      valueColor: const AlwaysStoppedAnimation<Color>(
                          Color.fromRGBO(106, 149, 122, 1)),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '${(progress * 100).toInt()}%',
                  style: TextStyle(
                    fontSize: isSmallScreen ? 14 : 16,
                    fontWeight: FontWeight.bold,
                    color: const Color.fromRGBO(78, 78, 78, 1),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsCards(bool isSmallScreen) {
    // Using Wrap for better responsiveness on different screen sizes
    return Wrap(
      spacing: isSmallScreen ? 8 : 16, // Horizontal space between cards
      runSpacing: 16, // Vertical space between lines of cards
      alignment: WrapAlignment.center, // Center items if they wrap
      children: [
        SizedBox(
          width: isSmallScreen
              ? MediaQuery.of(context).size.width / 2 - 20
              : null, // Occupy roughly half width on small screens
          child: StatsCard(
            title: 'إجمالي اللاعبين',
            value: playersCount?.toString() ?? '0',
            iconPath: 'assets/images/tabler_play-football.png',
          ),
        ),
        SizedBox(
          width: isSmallScreen
              ? MediaQuery.of(context).size.width / 2 - 20
              : null, // Occupy roughly half width on small screens
          child: StatsCard(
            title: 'الجلسات اليوم',
            value: '3', // This value is hardcoded, consider making it dynamic
            iconPath: 'assets/images/Group.png',
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons(bool isSmallScreen) {
    // Using Wrap for better responsiveness of action buttons
    return Wrap(
      spacing: isSmallScreen ? 12 : 24,
      runSpacing: 12,
      alignment: WrapAlignment.center,
      children: [
        _buildIconButton("تعديل اللاعبون", Icons.edit, isSmallScreen, () {
          print('Edit player tapped');
        }),
        _buildIconButton("عرض الجدول", Icons.calendar_month, isSmallScreen,
            () {
          print('View schedule tapped');
        }),
      ],
    );
  }

  // Added onTap callback to _buildIconButton for functionality
  Widget _buildIconButton(
      String title, IconData icon, bool isSmallScreen, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: isSmallScreen ? 12 : 16,
          vertical: isSmallScreen ? 8 : 10,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            // Optional: Add a subtle shadow for better visual separation
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 3,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: isSmallScreen ? 20 : 24,
              height: isSmallScreen ? 20 : 24,
              decoration: BoxDecoration(
                color: const Color.fromRGBO(106, 149, 122, 1),
                borderRadius: BorderRadius.circular(5),
              ),
              child: Center(
                child: Icon(
                  icon,
                  size: isSmallScreen ? 14 : 16,
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(width: isSmallScreen ? 4 : 8),
            Text(
              title,
              style: TextStyle(
                fontSize: isSmallScreen ? 14 : 16,
                color: const Color.fromRGBO(78, 78, 78, 1),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopPlayersSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader("المتصدر", "لوحة الصدارة "),
        const SizedBox(height: 10),
        isTopPlayersLoading
            ? const Center(child: CircularProgressIndicator())
            : topPlayers.isEmpty
                ? const Center(child: Text('No top players found'))
                : Column(
                    children: topPlayers.asMap().entries.map((entry) {
                      int index = entry.key;
                      Map<String, dynamic> player = entry.value;

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: LeaderboardItem(
                          rank: player['rank'] ?? index + 1,
                          name: player['name'] ?? 'Unknown',
                          points: player['total_score'] ?? 0,
                          imagePath: player['image'] != null &&
                                  player['image']!.isNotEmpty
                              ? (player['image']!.startsWith('assets/')
                                  ? player['image']
                                  : '$baseUrl${player['image']}')
                              : 'assets/images/avatar5.png',
                        ),
                      );
                    }).toList(),
                  ),
      ],
    );
  }

  Widget _buildPlayerProgressSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text(
              'تقدم اللاعب',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color.fromRGBO(78, 78, 78, 1),
              ),
            ),
            const Spacer(),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CommPlayers(
                      communityId: widget.communityId,
                      showBottomBar: true,
                    ),
                  ),
                );
              },
              child: const Text(
                'عرض الكل ',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Column(
          children: [
            if (players.isEmpty)
              const Center(child: Text('No players found'))
            else
              // Only show a limited number of player progress cards for brevity
              Column(
                children: players.take(2).map((player) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
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
          ],
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
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color.fromRGBO(78, 78, 78, 1),
          ),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CoachLeaderboard(
                  communityId: widget.communityId,
                ),
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
                "لوحة الصدارة ",
                style: TextStyle(
                  color: Color.fromRGBO(80, 112, 92, 1),
                  fontSize: 16,
                ),
              ),
              SizedBox(width: 4),
              Icon(
                Icons.arrow_forward_ios,
                color: Color.fromRGBO(80, 112, 92, 1),
                size: 16,
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
              insetPadding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width > 600 ? 100 : 16,
                vertical: 32,
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
                          icon: const Icon(Icons.close,
                              color: Colors.white, size: 32),
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
                      "حذف هذا المجتمع",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Color.fromRGBO(78, 78, 78, 1),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'سيتم حذف هذا المجتمع وكل بياناته المرتبطة بشكل نهائي. هل تريد المتابعة؟',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: Color.fromRGBO(78, 78, 78, 1),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 50),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 145,
                          height: 52,
                          child: ElevatedButton(
                            onPressed: isDeleting
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
                              "الغاء",
                              style: TextStyle(
                                color: Color.fromRGBO(78, 78, 78, 1),
                                fontSize: 20,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        SizedBox(
                          width: 145,
                          height: 52,
                          child: ElevatedButton(
                            onPressed: isDeleting
                                ? null
                                : () async {
                                    setState(() => isDeleting = true);
                                    try {
                                      final result = await Api.delateCommunity(
                                          widget.communityId);

                                      if (result['success'] == true) {
                                        if (mounted)
                                          Navigator.pop(
                                              context); // Close dialog
                                        if (mounted) {
                                          Navigator.pushReplacement(
                                            // Use pushReplacement to avoid going back to this screen
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => CoachHome(),
                                            ),
                                          );
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                            content: Text(result['message']),
                                            backgroundColor: Colors.green,
                                          ));
                                        }
                                      } else {
                                        if (mounted) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                            content: Text(result['error'] ??
                                                'Failed to delete community'),
                                            backgroundColor: Colors.red,
                                          ));
                                          Navigator.pop(
                                              context); // Close dialog
                                        }
                                      }
                                    } catch (e) {
                                      if (mounted) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                          content: Text('Error: $e'),
                                          backgroundColor: Colors.red,
                                        ));
                                        Navigator.pop(context); // Close dialog
                                      }
                                    } finally {
                                      if (mounted) {
                                        setState(() => isDeleting = false);
                                      }
                                    }
                                  },
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  const Color.fromRGBO(218, 43, 82, 1),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            child: isDeleting
                                ? const CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white),
                                  )
                                : const Text(
                                    "حذف",
                                    style: TextStyle(
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
