import 'package:flutter/material.dart';

class CommunityCard extends StatelessWidget {
  final String title;
  final String level;
  final String date;
  final int players;
  final int cardWidth;
  final VoidCallback? onTap;

  const CommunityCard({
    super.key,
    required this.title,
    required this.level,
    required this.players,
    required this.date,
    required this.cardWidth,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // Colors based on level
    late final Color backgroundColor;
    late final Color textColor;

    switch (level.toLowerCase()) {
      case 'low':
        backgroundColor = const Color.fromRGBO(239, 255, 206, 1);
        textColor = const Color.fromRGBO(153, 194, 70, 1);
        break;
      case 'moderate':
        backgroundColor = const Color.fromRGBO(254, 251, 226, 1);
        textColor = const Color.fromRGBO(212, 193, 17, 1);
        break;
      default: // High
        backgroundColor = const Color.fromRGBO(255, 235, 228, 1);
        textColor = const Color.fromRGBO(212, 60, 10, 1);
        break;
    }

    final double containerWidth = (level.length * 12.0).clamp(40.0, 100.0);
    final double containerHeight = (level.length * 8.0).clamp(30.0, 35.0);

    return Column(
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            width: cardWidth.toDouble(),
            height: 120,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
              border: Border.all(
                color: const Color.fromRGBO(218, 218, 218, 1),
                width: 1,
              ),
            ),
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                Row(
                  children: [
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        title,
                        style: const TextStyle(
                          fontSize: 20,
                          color: Color.fromRGBO(78, 78, 78, 1),
                        ),
                      ),
                    ),
                    Container(
                      width: containerWidth,
                      height: containerHeight,
                      margin: const EdgeInsets.only(right: 10),
                      decoration: BoxDecoration(
                        color: backgroundColor,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        level,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: textColor,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const SizedBox(width: 8),
                    Image.asset(
                      'assets/images/tabler_play-football.png',
                      width: 18,
                      height: 18,
                      color: const Color.fromRGBO(106, 149, 122, 1),
                    ),
                    const SizedBox(width: 5),
                    Text(
                      'Total Players: $players',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color.fromRGBO(66, 66, 66, 0.5),
                      ),
                    ),
                    const SizedBox(width: 15),
                    const Icon(
                      Icons.calendar_month,
                      size: 16,
                      color: Color.fromRGBO(106, 149, 122, 1),
                    ),
                    const SizedBox(width: 5),
                    Text(
                      date,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color.fromRGBO(66, 66, 66, 0.5),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
