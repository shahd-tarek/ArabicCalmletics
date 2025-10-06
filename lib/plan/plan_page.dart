import 'package:flutter/material.dart';
import 'package:calmleticsarab/constant.dart';
import 'package:calmleticsarab/http/api.dart';
import 'package:calmleticsarab/models/plan_model.dart';
import 'package:calmleticsarab/plan/plan_day_task.dart';

class PlanPage extends StatelessWidget {
  const PlanPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgcolor,
      body: LayoutBuilder(
        builder: (context, constraints) {
          final screenWidth = constraints.maxWidth;
          final screenHeight = constraints.maxHeight;

          // حساب القيم النسبية
          final padding = screenWidth * 0.05; // ~20px عند 400px
          final borderRadius = screenWidth * 0.08; // ~32px
          final cardHeight = screenHeight * 0.18; // ~130px على شاشة 720px
          final imageWidth = screenWidth * 0.35; // ~150px
          final progressSize = screenWidth * 0.2; // ~80px عند 400px
          final avatarRadius = progressSize * 0.375; // ~30px
          final fontSizeSmall = screenWidth * 0.04; // ~16px
          final fontSizeMedium = screenWidth * 0.05; // ~18px

          return FutureBuilder(
            future: Api().fetchSessions(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasError) {
                return Center(child: Text("Error: ${snapshot.error}"));
              }

              final data = snapshot.data as Map<String, dynamic>;
              final sessions = data['sessions'] as List<Session>;
              final percentageStr = data['percentage'] as String;
              final count = data['count'] as int;

              final progressValue =
                  double.tryParse(percentageStr.replaceAll('%', '').trim()) ??
                      0.0;

              return Column(
                children: [
                  SizedBox(height: screenHeight * 0.08), // ~60px
                  Center(
                    child: Column(
                      children: [
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            SizedBox(
                              width: progressSize,
                              height: progressSize,
                              child: CircularProgressIndicator(
                                value: progressValue / 100,
                                strokeWidth: 8,
                                backgroundColor: Colors.grey[300],
                                valueColor: const AlwaysStoppedAnimation<Color>(
                                  kPrimaryColor,
                                ),
                              ),
                            ),
                            CircleAvatar(
                              radius: avatarRadius,
                              backgroundColor: Colors.white,
                              child: Icon(
                                Icons.person,
                                size: avatarRadius * 1.3,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: screenHeight * 0.01),
                        Text(
                          "$percentageStr مكتمل",
                          style: TextStyle(
                            fontSize: fontSizeSmall,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.025), // ~20px
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: padding),
                    child: Row(
                      children: [
                        Text(
                          "إجمالي الجلسات",
                          style: TextStyle(
                            fontSize: fontSizeMedium,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(width: screenWidth * 0.02),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: padding * 0.4, // ~8px
                            vertical: padding * 0.2, // ~4px
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE3ECE7),
                            borderRadius: BorderRadius.circular(
                              borderRadius * 0.4,
                            ), // ~12px
                          ),
                          child: Text(
                            "$count",
                            style: const TextStyle(
                              color: Color(0xFF5DB075),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.025),
                  Expanded(
                    child: ListView.builder(
                      padding: EdgeInsets.symmetric(horizontal: padding),
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
                                        "https://calmletics-production.up.railway.app${session.status}",
                                    sessionType: session.sessionType,
                                  ),
                                ),
                              );
                            },
                            child: Container(
                              height: cardHeight,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(
                                  borderRadius,
                                ),
                                border: Border.all(
                                  color: Colors.grey.shade300,
                                  width: 1,
                                ),
                              ),
                              child: Row(
                                children: [
                                  // Left side: title + icon
                                  Expanded(
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                        top: screenHeight * 0.03,
                                        left: padding,
                                        right: padding,
                                        bottom: screenHeight * 0.014,
                                      ),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Image.network(
                                                "https://calmletics-production.up.railway.app${session.status}",
                                                width: screenWidth * 0.06,
                                                height: screenWidth * 0.06,
                                                errorBuilder: (
                                                  context,
                                                  error,
                                                  stackTrace,
                                                ) =>
                                                    Icon(
                                                  Icons.broken_image,
                                                  size: screenWidth * 0.06,
                                                ),
                                              ),
                                              SizedBox(
                                                width: screenWidth * 0.015,
                                              ),
                                              Text(
                                                session.sessionNumber,
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: fontSizeSmall,
                                                  color: Colors.grey,
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: screenHeight * 0.01),
                                          Text(
                                            session.sessionName,
                                            style: TextStyle(
                                              fontSize: fontSizeMedium,
                                              color: textcolor,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  // Right side: fixed image
                                  ClipRRect(
                                    borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(
                                        borderRadius * 0.5,
                                      ),
                                      bottomRight: Radius.circular(
                                        borderRadius * 0.5,
                                      ),
                                    ),
                                    child: Image.asset(
                                      'assets/images/freepik--background-complete--inject-64 1.png',
                                      width: imageWidth,
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
          );
        },
      ),
    );
  }
}
