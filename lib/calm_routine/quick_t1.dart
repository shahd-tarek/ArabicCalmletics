import 'package:flutter/material.dart';
import 'package:calmleticsarab/calm_routine/box_breathing.dart';
import 'package:calmleticsarab/constant.dart';

class QuickTaskOne extends StatefulWidget {
  final int pageIndex;
  final int totalPages;

  const QuickTaskOne({
    super.key,
    required this.pageIndex,
    required this.totalPages,
  });

  @override
  State<QuickTaskOne> createState() => _QuickTaskOneState();
}

class _QuickTaskOneState extends State<QuickTaskOne> {
  final List<Map<String, String>> tips = [
    {
      'image': 'assets/images/img-card1.png',
      'text':
          'ابتسم، حتى لو اضطررت لتصنعها. الابتسامة تهدّئ الجسد والعقل معًا.',
    },
    {
      'image': 'assets/images/img-card2.png',
      'text': "تذكّر أنك جاهز ومدرَّب جيدًا، وهذا وقتك لتُظهر جهدك.",
    },
    {
      'image': 'assets/images/img-card3.png',
      'text':
          "القلق ليس ضعفًا، بل علامة على أنك تهتم. المهم هو كيف تتعامل معه.",
    },
    {
      'image': 'assets/images/img-card4.png',
      'text':
          'ابتسم، حتى لو اضطررت لتصنعها. الابتسامة تهدّئ الجسد والعقل معًا.',
    },
    {
      'image': 'assets/images/img-card5.png',
      'text': 'في كل مرة تراودك فكرة سلبية، استبدلها بعبارة إيجابية.',
    },
    {
      'image': 'assets/images/img-card6.png',
      'text': 'تذكّر دائمًا: اللعب متعة، وليس ضغطًا.',
    },
  ];

  int currentIndex = 0;
  final PageController _pageController = PageController(viewportFraction: 0.85);

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final double padding = size.width * 0.04; // 4% من العرض
    final double fontSizeMedium = size.width * 0.042;
    final double fontSizeLarge = size.width * 0.05;
    final double cardHeight = size.height * 0.5; // ارتفاع الكارد نسبي
    final double progressBarWidth = size.width * 0.7;

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 243, 240, 240),
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
            size: size.width * 0.06,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: const Color.fromARGB(255, 243, 240, 240),
        elevation: 0,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // الجزء العلوي (الكارد الأبيض)
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(size.width * 0.08), // نسبي
              ),
              child: Padding(
                padding: EdgeInsets.all(padding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // شريط التقدم
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: SizedBox(
                            height: size.width * 0.08,
                            width: progressBarWidth,
                            child: LinearProgressIndicator(
                              value: (widget.pageIndex + 1) / widget.totalPages,
                              backgroundColor: Colors.grey[300],
                              valueColor: const AlwaysStoppedAnimation<Color>(
                                kPrimaryColor,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: padding * 0.8),
                        Text(
                          '${widget.pageIndex + 1}/${widget.totalPages}',
                          style: TextStyle(
                            fontSize: fontSizeMedium,
                            fontWeight: FontWeight.bold,
                            color: kPrimaryColor,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: padding * 1.2),
                    Center(
                      child: Text(
                        'نصائح سريعة قبل المباراة',
                        style: TextStyle(
                          fontSize: fontSizeLarge,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(height: padding * 1.5),

                    // PageView للنصائح
                    SizedBox(
                      height: cardHeight,
                      child: PageView.builder(
                        controller: _pageController,
                        itemCount: tips.length,
                        onPageChanged: (index) {
                          setState(() {
                            currentIndex = index;
                          });
                        },
                        itemBuilder: (context, index) {
                          final tip = tips[index];
                          return Container(
                            margin: EdgeInsets.symmetric(
                              horizontal: padding * 1,
                            ),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade300),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            padding: EdgeInsets.all(padding),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  tip['image']!,
                                  height: size.width * 0.5, // نسبة من العرض
                                  fit: BoxFit.contain,
                                ),
                                SizedBox(height: padding * 0.7),
                                if (index == 4)
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        tip['text']!,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: fontSizeMedium,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black87,
                                        ),
                                      ),
                                      SizedBox(height: padding * 0.5),
                                      LayoutBuilder(
                                        builder: (context, constraints) {
                                          return SizedBox(
                                            width:
                                                constraints.maxWidth *
                                                0.8, // 80% من العرض المتاح
                                            child: Wrap(
                                              alignment: WrapAlignment.center,
                                              spacing: padding * 0.8,
                                              runSpacing: padding * 0.4,
                                              children: const [
                                                PositivePhraseChip(
                                                  text: 'أنا جاهز ',
                                                ),
                                                PositivePhraseChip(
                                                  text: 'أنا قادر',
                                                ),
                                                PositivePhraseChip(
                                                  text: 'سأبذل قصارى جهدي',
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                      ),
                                    ],
                                  )
                                else
                                  Text(
                                    tip['text']!,
                                    style: TextStyle(
                                      fontSize: fontSizeMedium,
                                      color: Colors.grey.shade800,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                    SizedBox(height: padding * 0.6),

                    // النقاط المؤشرة (Indicator Dots)
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(tips.length, (index) {
                          return Container(
                            margin: const EdgeInsets.symmetric(horizontal: 4.0),
                            width: 10,
                            height: 10,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color:
                                  currentIndex == index
                                      ? kPrimaryColor
                                      : Colors.grey.shade300,
                            ),
                          );
                        }),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // زر "Next" في الأسفل
          Container(
            padding: EdgeInsets.all(padding),
            color: bgcolor,
            child: Center(
              child: SizedBox(
                width: double.infinity,
                height: size.height * 0.07,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) => BoxBreathingScreen(
                              pageIndex: widget.pageIndex + 1,
                              totalPages: widget.totalPages,
                            ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kPrimaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Text(
                    'التالي',
                    style: TextStyle(
                      fontSize: fontSizeMedium,
                      color: const Color.fromRGBO(255, 255, 255, 1),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Custom widget for positive phrases
class PositivePhraseChip extends StatelessWidget {
  final String text;

  const PositivePhraseChip({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final double fontSizeChip = size.width * 0.034;

    return Container(
      padding: EdgeInsets.all(size.width * 0.02),
      decoration: BoxDecoration(
        color: const Color.fromRGBO(222, 247, 227, 1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: const Color(0xFF4B9F72),
          fontSize: fontSizeChip,
        ),
      ),
    );
  }
}
