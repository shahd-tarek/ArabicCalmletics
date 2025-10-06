// ignore_for_file: use_key_in_widget_constructors, library_private_types_in_public_api, sized_box_for_whitespace, deprecated_member_use, use_build_context_synchronously, avoid_print, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:calmleticsarab/coach/screens/choose_plan.dart';
import 'package:calmleticsarab/coach/screens/community_pop_code.dart';
import 'package:calmleticsarab/coach/tabbars/tab_bar.dart';
import 'package:calmleticsarab/http/api.dart';
import 'package:flutter/material.dart';

class CreateCommunity extends StatefulWidget {
  @override
  _CreateCommunityState createState() => _CreateCommunityState();
}

class _CreateCommunityState extends State<CreateCommunity> {
  String? selectedLevel;
  String? selectedPlanId;
  final TextEditingController _communityNameController =
      TextEditingController();

  List<Map<String, dynamic>> plans = [];
  final String baseUrl = 'https://calmletics-production.up.railway.app';
  final Api api = Api();

  get communityId => null;

  @override
  void initState() {
    super.initState();
  }

  void fetchPlans(String level) async {
    try {
      final response = await api.fetchPlans(level);
      setState(() {
        plans = response;
      });

      List<String> planIds =
          response.map((plan) => plan['plan_id'].toString()).toList();
      print("Plan IDs: $planIds");
    } catch (e) {
      print('Error fetching plans: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(255, 252, 249, 1),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: const Color.fromRGBO(255, 252, 249, 1),
        elevation: 0,
        title: const Text(
          " إنشاء مجتمع",
          style: TextStyle(color: Colors.black, fontSize: 20),
        ),
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            height: 300,
            child: Image.asset(
              'assets/images/Team spirit-cuate 1.png',
              fit: BoxFit.cover,
            ),
          ),
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(25),
                  topLeft: Radius.circular(25),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 5,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextField(
                        controller: _communityNameController,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(
                            Icons.edit,
                            color: Colors.grey,
                          ),
                          hintText: "اسم المجتمع",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: Colors.grey[200],
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        " اختر المستوى",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color.fromRGBO(78, 78, 78, 1),
                        ),
                      ),
                      const SizedBox(height: 10),
                      CustomTabBar(
                        selectedLevel: selectedLevel,
                        onTabSelected: (tab) {
                          setState(() {
                            selectedLevel = tab;
                            selectedPlanId = null;
                          });
                          if (tab.isNotEmpty) {
                            fetchPlans(tab);
                          }
                        },
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        "اختر الخطة",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color.fromRGBO(78, 78, 78, 1),
                        ),
                      ),
                      const SizedBox(height: 10),
                      selectedLevel == null
                          ? const Text(
                              "Please select a level to view plans.",
                              style: TextStyle(color: Colors.red),
                            )
                          : SizedBox(
                              height: 145,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: plans.length,
                                itemBuilder: (context, index) {
                                  final plan = plans[index];
                                  bool isSelected =
                                      plan['plan_id'].toString() ==
                                          selectedPlanId;

                                  return GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        selectedPlanId =
                                            plan['plan_id'].toString();
                                      });
                                    },
                                    child: Container(
                                      margin: const EdgeInsets.only(right: 16),
                                      padding: const EdgeInsets.all(16),
                                      width: 280,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        border: Border.all(
                                          color: const Color.fromRGBO(
                                            218,
                                            218,
                                            218,
                                            1,
                                          ),
                                          width: 1,
                                        ),
                                        borderRadius: BorderRadius.circular(30),
                                        boxShadow: isSelected
                                            ? [
                                                BoxShadow(
                                                  color: Colors.black
                                                      .withOpacity(0.1),
                                                  blurRadius: 5,
                                                  spreadRadius: 2,
                                                ),
                                              ]
                                            : [],
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              const Text(
                                                'إجمالي الجلسات',
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                              const SizedBox(width: 10),
                                              CircleAvatar(
                                                radius: 16,
                                                backgroundColor:
                                                    const Color.fromRGBO(
                                                  233,
                                                  239,
                                                  235,
                                                  1,
                                                ),
                                                child: Text(
                                                  '${plan['sessions_count']}',
                                                  style: const TextStyle(
                                                    color: Color.fromRGBO(
                                                      80,
                                                      112,
                                                      92,
                                                      1,
                                                    ),
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                              const Spacer(),
                                              GestureDetector(
                                                onTap: () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          ChoosePlanPage(
                                                        planId: plan['plan_id']
                                                            .toString(),
                                                      ),
                                                    ),
                                                  );
                                                },
                                                child: const Icon(
                                                  Icons.arrow_forward_ios,
                                                  size: 16,
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 20),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              SessionItem(
                                                imageUrl: plan['audio_image'] !=
                                                        null
                                                    ? '$baseUrl${plan['audio_image']}'
                                                    : '',
                                                label:
                                                    '${plan['audio_percentage']}% Audio',
                                              ),
                                              SessionItem(
                                                imageUrl: plan['video_image'] !=
                                                        null
                                                    ? '$baseUrl${plan['video_image']}'
                                                    : '',
                                                label:
                                                    '${plan['video_percentage']}% Video',
                                              ),
                                              SessionItem(
                                                imageUrl: plan['pdf_image'] !=
                                                        null
                                                    ? '$baseUrl${plan['pdf_image']}'
                                                    : '',
                                                label:
                                                    '${plan['pdf_percentage']}% Articles',
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                      const SizedBox(height: 70),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () async {
                            if (_communityNameController.text.trim().isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    "Please enter a community name",
                                  ),
                                ),
                              );
                              return;
                            }
                            if (selectedLevel == null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Please select a level first"),
                                ),
                              );
                              return;
                            }

                            String planId = selectedPlanId ?? '';
                            if (planId.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Please select a plan first"),
                                ),
                              );
                              return;
                            }

                            try {
                              final response = await api.createcom(
                                _communityNameController.text.trim(),
                                selectedLevel!,
                                planId,
                              );

                              print("API Response: $response");

                              if (response['data'] != null &&
                                  response['data']['code'] != null) {
                                String otpCode =
                                    response['data']['code'].toString();
                                String communityId =
                                    response['data']['id'].toString();

                                createCommunityPopDialog(
                                  context,
                                  otpCode,
                                  communityId,
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("Failed to create community"),
                                  ),
                                );
                              }
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    "Error occurred. Please try again later.",
                                  ),
                                ),
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color.fromRGBO(
                              106,
                              149,
                              122,
                              1,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                          ),
                          child: const Text(
                            "التالي",
                            style: TextStyle(fontSize: 18, color: Colors.white),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void createCommunityPopDialog(
    BuildContext context,
    String otpCode,
    String communityId,
  ) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                    icon: const Icon(
                      Icons.close,
                      color: Colors.black,
                      size: 32,
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
                const Text(
                  "تهانينا!",
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 30),
                Image.asset(
                  "assets/images/Coach 3.png",
                  width: 100,
                  height: 100,
                ),
                const SizedBox(height: 30),
                Text(
                  "رمزك: $otpCode",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CommunityPopCode(
                          otpCode: otpCode,
                          communityId: communityId,
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromRGBO(106, 149, 122, 1),
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  child: const Text(
                    "التالي",
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class SessionItem extends StatelessWidget {
  final String imageUrl;
  final String label;

  const SessionItem({super.key, required this.imageUrl, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 16,
          backgroundColor: const Color.fromRGBO(233, 239, 235, 1),
          backgroundImage: imageUrl.isNotEmpty ? NetworkImage(imageUrl) : null,
          child: imageUrl.isEmpty
              ? const Icon(Icons.error, color: Colors.red, size: 18)
              : null,
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: Colors.black87),
        ),
      ],
    );
  }
}
