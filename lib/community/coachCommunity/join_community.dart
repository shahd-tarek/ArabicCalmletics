import 'package:flutter/material.dart';
import 'package:calmleticsarab/community/coachCommunity/community-pop-code.dart';
import 'package:calmleticsarab/constant.dart';
import 'package:calmleticsarab/widgets/custom_button.dart';

class JoinCommunity extends StatelessWidget {
  const JoinCommunity({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgcolor,
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/Sad Face 1.png',
                  height: 388,
                  width: 500,
                ),
                const SizedBox(height: 24),
                const Text(
                  "لم تصبح عضوًا في المجتمع حتى الآن.",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: textcolor,
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  "انضم إلى مجتمعنا للتواصل مع اللاعبين والمدربين، وتبادل الخبرات، وطرح الأسئلة، والحصول على الإلهام معًا، نبني الثقة ونتخطّى التحديات!",
                  style: TextStyle(
                    fontSize: 16,
                    color: Color.fromARGB(121, 35, 35, 37),
                  ),
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: CustomButton(
                    text: " انضم إلى المجتمع",
                    ontap: () {
                      showCommunityDialog(context);
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
