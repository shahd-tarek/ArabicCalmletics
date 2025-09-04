import 'package:flutter/material.dart';

class StatsCard extends StatelessWidget {
  final String title;
  final String value;
  final String iconPath;

  const StatsCard({
    super.key,
    required this.title,
    required this.value,
    required this.iconPath,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 171,
      height: 197,
      decoration: BoxDecoration(
        color: const Color.fromRGBO(255, 255, 255, 1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color.fromRGBO(223, 223, 223, 1),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          const SizedBox(height: 20),
          Row(
            children: [
              const SizedBox(width: 16),
              Image.asset(
                iconPath,
                width: 24,
                height: 24,
                color: const Color.fromRGBO(106, 149, 122, 1),
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  color: Color.fromRGBO(78, 78, 78, 1),
                ),
              ),
            ],
          ),
          const SizedBox(height: 40),
          Text(
            value,
            style: const TextStyle(
              fontSize: 36,
              color: Color.fromRGBO(78, 78, 78, 1),
            ),
          ),
        ],
      ),
    );
  }
}