// leaderboard_item.dart
import 'package:flutter/material.dart';

class LeaderboardItem extends StatelessWidget {
  final int rank;
  final String name;
  final int points;
  final String imagePath;

  const LeaderboardItem({
    super.key,
    required this.rank,
    required this.name,
    required this.points,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 74,
      decoration: BoxDecoration(
        color: const Color.fromRGBO(255, 255, 255, 1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color:  const Color(0xffDADADA),
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Text(
              rank.toString(),
              style: const TextStyle(
                fontSize: 16,
                color: Color.fromRGBO(0, 0, 0, 1),
              ),
            ),
            const SizedBox(width: 10),
            CircleAvatar(
              radius: 25,
              backgroundColor: Colors.grey,
              backgroundImage: AssetImage(imagePath),
            ),
            const SizedBox(width: 10),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Color.fromRGBO(0, 0, 0, 1),
                  ),
                ),
                Text(
                  "$points points",
                  style: const TextStyle(
                    fontSize: 16,
                    color: Color.fromRGBO(127, 127, 127, 1),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}