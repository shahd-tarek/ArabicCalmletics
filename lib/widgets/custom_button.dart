import 'package:flutter/material.dart';
import 'package:calmleticsarab/constant.dart';

// ignore: must_be_immutable
class CustomButton extends StatelessWidget {
  CustomButton({super.key, required this.text, this.ontap});
  String text;
  VoidCallback? ontap;

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;

    // تحديد أقصى عرض للزر
    const double maxWidth = 350;
    final double buttonWidth = screenWidth * 0.9;
    final double actualWidth = buttonWidth > maxWidth ? maxWidth : buttonWidth;

    // تحديد ارتفاع نسبي لكن بحد أدنى
    final double buttonHeight = actualWidth * 0.15;
    final double actualHeight = buttonHeight > 60 ? 60 : buttonHeight;

    // حجم الخط
    final double fontSize = actualWidth * 0.05;

    return Container(
      decoration: BoxDecoration(
        color: kPrimaryColor,
        borderRadius: BorderRadius.circular(16),
      ),
      width: actualWidth,
      height: actualHeight,
      child: MaterialButton(
        onPressed: ontap,
        child: Text(
          text,
          style: TextStyle(
            fontSize: fontSize,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
