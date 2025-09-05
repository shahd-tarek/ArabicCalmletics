
// ignore_for_file: prefer_const_constructors

import 'package:calmleticsarab/coach/screens/payment.dart';
import 'package:calmleticsarab/widgets/custom_button.dart';
import 'package:flutter/material.dart';


class Vr extends StatelessWidget {
  const Vr({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              "assets/images/backgrouq chat.png",
              fit: BoxFit.cover,
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  const Padding(
                    padding: EdgeInsets.all(24),
                    child: Text(
                      "قم بإعداد نظام الـ VR الخاص بك لتبدأ في إنشاء وإدارة مجتمعك",
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Image.asset(
                    "assets/images/vr glasses.png",
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  CustomButton(
                      text: "ابدأ",
                      ontap: () {
                        Navigator.push(
                          context,  
                          MaterialPageRoute(
                              builder: (context) =>  PaymentPage()),
                        );
                      }),
                  const SizedBox(
                    height: 50,
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
