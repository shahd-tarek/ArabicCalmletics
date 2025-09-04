import 'package:flutter/material.dart';
import 'package:calmleticsarab/community/coachCommunity/join_community.dart';
import 'package:calmleticsarab/community/freeCommunity/free_community.dart';
import 'package:calmleticsarab/http/api.dart';
import 'package:calmleticsarab/widgets/community_card.dart';

class Community extends StatefulWidget {
  const Community({super.key});

  @override
  State<Community> createState() => _CommunityState();
}

class _CommunityState extends State<Community> {
  final Api api = Api();
  bool isLoading = false;
  bool isJoined = false;
  Map<String, dynamic>? communityData;

  @override
  void initState() {
    super.initState();
    fetchCommunityData(); // Fetch community data on initialization
  }

  /// Fetches community data from API
  void fetchCommunityData() async {
    setState(() {
      isLoading = true;
    });
  }

  /// Handles joining the free community
  void handleJoinCommunity() async {
    setState(() {
      isLoading = true;
    });

    bool success = await api.joinFreeCommunity();

    setState(() {
      isLoading = false;
      isJoined = success;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          success
              ? "Successfully joined Free Community! 🎉"
              : "Failed to join Free Community.",
        ),
      ),
    );

    if (success) {
      fetchCommunityData(); // Refresh community data after joining
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(255, 252, 249, 1),
      body: Column(
        children: [
          const SizedBox(height: 50),
          Container(
            width: double.infinity,
            height: 280,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            child: Image.asset(
              'assets/images/Team spirit-cuate 1.png',
              fit: BoxFit.cover,
            ),
          ),
          Expanded(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 5,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          CommunityCard(
                            title: 'المجتمع المجاني',
                            description:
                                'انضم إلى مجتمع داعم من الأفراد الذين يشاركونك نفس الأهداف. اعملوا معًا بدون الحاجة لمدرب.',
                            features: const [
                              'مناقشات جماعية',
                              'دعم الأقران',
                              'تحديات',
                              'لوائح الصدارة',
                              'محادثة',
                            ],
                            onPressed: () {
                              handleJoinCommunity();
                              fetchCommunityData();

                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const freeCommunity(),
                                ),
                              );
                            },
                          ),
                          const SizedBox(width: 30),
                          CommunityCard(
                            title: 'مجتمع المدرب',
                            description:
                                'انضم إلى مجتمع داعم من الأفراد الذين يشاركونك نفس الأهداف. اعملوا معًا مع مدرب خاص.',
                            features: const [
                              'تدريب فردي (واحد لواحد)',
                              'جلسات واقع افتراضي',
                              'تحديات',
                              'لوائح الصدارة',
                              'محادثة',
                            ],
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const JoinCommunity(),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
