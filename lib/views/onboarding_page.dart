import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:calmleticsarab/constant.dart';
import 'package:calmleticsarab/views/user_type.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final controller = PageController();
  bool isLastPage = false;
  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: bgcolor,
      body: Stack(
        children: [
          PageView(
            controller: controller,
            onPageChanged: (index) {
              setState(() {
                currentPageIndex = index;
                isLastPage = index == 2;
              });
            },
            children: [
              buildPage(
                context,
                image: "assets/images/Meditation1.png",
                title: "جاهز؟ أهلًا بيك في Calmletics!",
                subtitle: "هدفنا نساعدك تحافظ على هدوئك وثقتك وتحكمك بنفسك",
              ),
              buildPage(
                context,
                image: "assets/images/Meditation2.png",
                title: "حافظ على هدوئك,العب بثقة",
                subtitle:
                    "حاسس بتوتر قبل المباراة الكبيرة؟ ماتقلقش! جهزنا لك برامج مصممة مخصوص عشان تساعدك تحافظ على هدوءك",
              ),
              buildPage(
                context,
                image: "assets/images/Meditation3.png",
                title: "جاهز؟ خلينا نبدأ!",
                subtitle: "خد أول خطوة معانا وخلي التوتر يتحول لهدوء وقوة",
              ),
            ],
          ),
          if (currentPageIndex < 2)
            Positioned(
              top: screenHeight * 0.03,
              right: screenWidth * 0.05,
              child: TextButton(
                onPressed: () {
                  controller.jumpToPage(2);
                },
                child: Text(
                  "تخطي",
                  style: TextStyle(
                    fontSize: screenWidth * 0.04,
                    color: Colors.grey,
                  ),
                ),
              ),
            ),
        ],
      ),
      bottomSheet: isLastPage
          ? buildGetStartedButton(context)
          : buildBottomNavigation(context),
    );
  }

  Widget buildPage(
    BuildContext context, {
    required String image,
    required String title,
    required String subtitle,
  }) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          image,
          height: screenHeight * 0.35,
          width: double.infinity,
          fit: BoxFit.contain,
        ),
        const SizedBox(height: 20),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
          child: Text(
            title,
            textAlign: TextAlign.left, // 👈 تغيير من center إلى left
            style: TextStyle(
              fontSize: screenWidth * 0.06,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 16),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
          child: Text(
            subtitle,
            textAlign: TextAlign.left, // 👈 تغيير من center إلى left
            style: TextStyle(fontSize: screenWidth * 0.035, color: Colors.grey),
          ),
        ),
        const SizedBox(height: 30),
      ],
    );
  }

  Widget buildGetStartedButton(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: screenWidth * 0.05,
        vertical: 10,
      ),
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const UserType()),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: kPrimaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          minimumSize: Size(double.infinity, screenWidth * 0.13),
        ),
        child: Text(
          "ابدأ الآن",
          style: TextStyle(fontSize: screenWidth * 0.045, color: Colors.white),
        ),
      ),
    );
  }

  Widget buildBottomNavigation(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;

    return Container(
      color: bgcolor,
      padding: EdgeInsets.symmetric(
        horizontal: screenWidth * 0.04,
        vertical: 10,
      ),
      height: 80,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Center(
            child: SmoothPageIndicator(
              controller: controller,
              count: 3,
              effect: WormEffect(
                spacing: screenWidth * 0.02,
                dotColor: Colors.grey,
                dotWidth: screenWidth * 0.03,
                dotHeight: screenWidth * 0.03,
                activeDotColor: kPrimaryColor,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              controller.nextPage(
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeInOut,
              );
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: kPrimaryColor,
              ),
              width: screenWidth * 0.17,
              height: screenWidth * 0.17,
              child: Center(
                child: Text(
                  "التالي",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: screenWidth * 0.040,
                    fontWeight: FontWeight.w700,
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
