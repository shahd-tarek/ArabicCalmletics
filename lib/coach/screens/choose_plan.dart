import 'package:calmleticsarab/constant.dart';
import 'package:calmleticsarab/http/api.dart';
import 'package:calmleticsarab/models/session_model.dart';
import 'package:calmleticsarab/plan/plan_day_task.dart';
import 'package:flutter/material.dart';

class ChoosePlanPage extends StatelessWidget {
  final String planId;

  const ChoosePlanPage({
    super.key,
    required this.planId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgcolor,
      body: FutureBuilder(
        future: Api().fetchSessionsByPlanId(planId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          final data = snapshot.data as Map<String, dynamic>;
          final sessions = (data['sessions'] as List)
              .map((json) => SessionModel.fromJson(json))
              .toList();
          final count = data['sessions_count'] as int;

          return Column(
            children: [
              const SizedBox(height: 90),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    const Text(
                      "إجمالي الجلسات",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE3ECE7),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        "$count",
                        style: const TextStyle(
                          color: kPrimaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: sessions.length,
                  itemBuilder: (context, index) {
                    final session = sessions[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PlanDayTask(
                                sessionId: session.sessionId,
                                sessionName: session.sessionName,
                                sessionNumber: session.sessionNumber,
                                status:
                                    "https://calmletics-production.up.railway.app${session.icon}",
                                sessionType: session.sessionTypeInt,
                              ),
                            ),
                          );
                        },
                        child: Container(
                          height: 120,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(32),
                            border: Border.all(
                              color: Colors.grey.shade300,
                              width: 1,
                            ),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      top: 24, left: 24, right: 24, bottom: 10),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Image.network(
                                            "https://calmletics-production.up.railway.app${session.icon}",
                                            width: 24,
                                            height: 24,
                                            errorBuilder: (context, error,
                                                    stackTrace) =>
                                                const Icon(Icons.broken_image,
                                                    size: 24),
                                          ),
                                          const SizedBox(width: 6),
                                          Text(
                                            session.sessionNumber,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        session.sessionName,
                                        style: const TextStyle(
                                          fontSize: 18,
                                          color: textcolor,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              ClipRRect(
                                borderRadius: const BorderRadius.only(
                                  topRight: Radius.circular(16),
                                  bottomRight: Radius.circular(16),
                                ),
                                child: Image.asset(
                                  'assets/images/freepik--background-complete--inject-64 1.png',
                                  width: 150,
                                  height: double.infinity,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
