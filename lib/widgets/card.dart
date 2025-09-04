import 'package:flutter/material.dart';
import 'package:calmleticsarab/constant.dart';

Widget buildCard({
  required String title,
  required String description,
  required String image,
  required Widget navigateTo,
  required BuildContext context,
}) {
  // الحصول على حجم الشاشة
  final double screenWidth = MediaQuery.of(context).size.width;

  final double cardWidth = screenWidth * 0.85;
  final double cardHeight = cardWidth * 0.5; // نسبة ثابتة: 3:2 تقريبًا

  final double titleFontSize = screenWidth * 0.045; // ~18px على شاشة 400pt
  final double descFontSize = screenWidth * 0.035; // ~14px

  final double imageWidth = cardWidth * 0.4;
  final double paddingSide = screenWidth * 0.04; // هامش من اليسار

  return GestureDetector(
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => navigateTo),
      );
    },
    child: Container(
      width: cardWidth,
      height: cardHeight,
      padding: EdgeInsets.only(
        right: paddingSide,
        top: cardHeight * 0.1,
        bottom: cardHeight * 0.1,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xffDADADA), width: 1.0),
        borderRadius: BorderRadius.circular(32),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: titleFontSize,
                    fontWeight: FontWeight.bold,
                    color: textcolor,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  description,
                  style: TextStyle(fontSize: descFontSize, color: Colors.grey),
                ),
              ],
            ),
          ),
          // الصورة على اليمين (بحجم نسبي)
          Image.asset(
            image,
            fit: BoxFit.cover,
            width: imageWidth,
            height: cardHeight * 0.8,
          ),
        ],
      ),
    ),
  );
}
