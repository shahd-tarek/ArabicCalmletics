import 'package:flutter/material.dart';
import 'package:calmleticsarab/coach/payment.dart';
import 'package:calmleticsarab/widgets/custom_button.dart';

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
                  const SizedBox(height: 10),
                  const Padding(
                    padding: EdgeInsets.all(24),
                    child: Text(
                      "set up your vr\n system to start\n creating and\n managing communities",
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  Image.asset("assets/images/vr glasses.png"),
                  const SizedBox(height: 50),
                  CustomButton(
                    text: "Start",
                    ontap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const PaymentPage(),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 50),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
