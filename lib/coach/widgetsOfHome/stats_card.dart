// ignore_for_file: use_super_parameters

import 'package:flutter/material.dart';

class StatsCard extends StatelessWidget {
  final String title;
  final String value;
  final String iconPath;

  const StatsCard({
    Key? key,
    required this.title,
    required this.value,
    required this.iconPath,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final screenWidth = media.size.width;
    final screenHeight = media.size.height;

    final isTablet = screenWidth > 600;
    final cardWidth = screenWidth * (isTablet ? 0.42 : 0.45);
    final cardHeight = screenHeight * 0.25;

    return Container(
      width: cardWidth,
      height: cardHeight,
      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color.fromRGBO(223, 223, 223, 1),
          width: 1,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Image.asset(
                iconPath,
                width: isTablet ? 32 : 24,
                height: isTablet ? 32 : 24,
                color: const Color.fromRGBO(106, 149, 122, 1),
              ),
              SizedBox(width: screenWidth * 0.02),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: isTablet ? 20 : 16,
                    color: const Color.fromRGBO(78, 78, 78, 1),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          SizedBox(height: screenHeight * 0.04),
          Center(
            child: Text(
              value,
              style: TextStyle(
                fontSize: isTablet ? 44 : 36,
                fontWeight: FontWeight.bold,
                color: const Color.fromRGBO(78, 78, 78, 1),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
