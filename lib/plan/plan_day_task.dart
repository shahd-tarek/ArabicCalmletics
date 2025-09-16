import 'package:flutter/material.dart';
import 'package:calmleticsarab/community/coachCommunity/book-vr.dart';
import 'package:calmleticsarab/constant.dart';
import 'package:calmleticsarab/http/api.dart';
import 'package:calmleticsarab/plan%20widgets/audio_plan.dart';
import 'package:calmleticsarab/plan%20widgets/text_plan.dart';
import 'package:calmleticsarab/plan%20widgets/video_plan.dart';
import 'package:calmleticsarab/plan/task_tab.dart';

class PlanDayTask extends StatefulWidget {
  final int sessionId;
  final String sessionName;
  final String sessionNumber;
  final String status;
  final int sessionType;

  const PlanDayTask({
    super.key,
    required this.sessionId,
    required this.sessionName,
    required this.sessionNumber,
    required this.status,
    required this.sessionType,
  });

  @override
  State<PlanDayTask> createState() => _PlanDayTaskState();
}

class _PlanDayTaskState extends State<PlanDayTask>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late Future<Map<String, dynamic>> _sessionContentFuture;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _sessionContentFuture = Api().fetchSessionContent(widget.sessionId);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // استخدم LayoutBuilder للحصول على أبعاد الحاوية
    return LayoutBuilder(
      builder: (context, constraints) {
        final screenWidth = constraints.maxWidth;
        final screenHeight = constraints.maxHeight;

        // حساب الأبعاد النسبية
        final cardHeight = screenHeight * 0.16; // 25% من ارتفاع الشاشة
        final imageWidth = screenWidth * 0.35;
        final padding = screenWidth * 0.04;
        final fontSizeTitle = screenWidth * 0.05;
        final fontSizeSubtitle = screenWidth * 0.04;

        return Scaffold(
          backgroundColor: bgcolor,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () => Navigator.of(context).pop(),
            ),
            elevation: 0,
          ),
          body: FutureBuilder<Map<String, dynamic>>(
            future: _sessionContentFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }
              final data = snapshot.data!;
              final content = data['content'];
              final task = data['task'];
              final practical = data['practical'];

              return Column(
                children: [
                  // الجزء العلوي (الكارد)
                  Center(
                    child: Container(
                      height: cardHeight,
                      width: screenWidth * 0.95,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(screenWidth * 0.08),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.all(padding),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Image.network(
                                        widget.status,
                                        width: screenWidth * 0.06,
                                        height: screenWidth * 0.06,
                                        errorBuilder:
                                            (context, error, stackTrace) =>
                                                Icon(
                                                  Icons.broken_image,
                                                  size: screenWidth * 0.06,
                                                ),
                                      ),
                                      SizedBox(width: screenWidth * 0.02),
                                      Text(
                                        widget.sessionNumber,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: fontSizeSubtitle,
                                          color: const Color.fromARGB(
                                            255,
                                            127,
                                            124,
                                            124,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: screenHeight * 0.01),
                                  Text(
                                    widget.sessionName,
                                    style: TextStyle(
                                      fontSize: fontSizeTitle,
                                      color: textcolor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          ClipRRect(
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(screenWidth * 0.04),
                              bottomRight: Radius.circular(screenWidth * 0.04),
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
                  SizedBox(height: screenHeight * 0.01),
                  Expanded(
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(32),
                          topRight: Radius.circular(32),
                        ),
                      ),
                      child: Column(
                        children: [
                          TabBar(
                            controller: _tabController,
                            labelColor: Colors.black,
                            unselectedLabelColor: Colors.grey,
                            indicatorColor: kPrimaryColor,
                            tabs: const [
                              Tab(text: 'الجلسة'),
                              Tab(text: 'مهمة'),
                            ],
                          ),
                          Expanded(
                            child: TabBarView(
                              controller: _tabController,
                              children: [
                                _SessionTab(
                                  content: content,
                                  sessionType: widget.sessionType,
                                  sessionId: widget.sessionId,
                                ),
                                TaskTab(
                                  taskDescription: task,
                                  practical: practical,
                                  sessionId: widget.sessionId,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }
}

class _SessionTab extends StatelessWidget {
  final String content;
  final int sessionType;
  final int sessionId;

  const _SessionTab({
    required this.content,
    required this.sessionType,
    required this.sessionId,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    String contentType = content.split('.').last.toLowerCase();
    Widget contentWidget;

    if (contentType == 'mp4') {
      contentWidget = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: screenHeight * 0.5, // 50% من الارتفاع
            child: VideoPlayerWidget(url: content),
          ),
          if (sessionType == 1) ...[
            SizedBox(height: screenHeight * 0.05),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    side: const BorderSide(color: Colors.grey),
                    padding: EdgeInsets.symmetric(
                      horizontal: screenWidth * 0.04,
                      vertical: screenHeight * 0.02,
                    ),
                    textStyle: TextStyle(
                      fontSize: screenWidth * 0.04,
                      fontWeight: FontWeight.bold,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(screenWidth * 0.05),
                    ),
                  ),
                  child: const Text('علي هاتفك'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) =>
                                BookVRSessionPage(sessionId: sessionId),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kPrimaryColor,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(
                      horizontal: screenWidth * 0.04,
                      vertical: screenHeight * 0.02,
                    ),
                    textStyle: TextStyle(
                      fontSize: screenWidth * 0.04,
                      fontWeight: FontWeight.bold,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(screenWidth * 0.05),
                    ),
                  ),
                  child: const Text('احجز جلسة vr'),
                ),
              ],
            ),
          ],
        ],
      );
    } else if (contentType == 'mp3') {
      contentWidget = SizedBox(
        height: screenHeight * 0.7, // 70% من الارتفاع
        child: AudioPlayerWidget(url: content),
      );
    } else if (contentType.toLowerCase().contains('txt')) {
      contentWidget = TextViewerWidget(url: content);
    } else {
      contentWidget = const Text('Unsupported content type');
    }

    return SingleChildScrollView(
      padding: EdgeInsets.all(screenWidth * 0.04),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [contentWidget],
      ),
    );
  }
}
