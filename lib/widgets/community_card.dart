import 'package:flutter/material.dart';

class CommunityCard extends StatelessWidget {
  final String title;
  final String description;
  final List<String> features;
  final VoidCallback onPressed;

  const CommunityCard({
    super.key,
    required this.title,
    required this.description,
    required this.features,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 297,
      height: 360,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.grey, width: 1),
      ),
      child: Column(
        children: [
          const SizedBox(height: 10),
          Text(
            title,
            style: const TextStyle(
              fontSize: 24,
              color: Color.fromRGBO(40, 40, 40, 1),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            description,
            style: const TextStyle(
              fontSize: 12,
              color: Color.fromRGBO(118, 118, 118, 1),
            ),
          ),
          const SizedBox(height: 5),
          const Divider(
            color: Colors.grey,
            thickness: 1,
          ),
          const SizedBox(height: 5),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: features
                .map((feature) => Padding(
                      padding: const EdgeInsets.only(left: 0),
                      child: Text(
                        '• $feature',
                        style: const TextStyle(
                          fontSize: 16,
                          color: Color.fromRGBO(66, 66, 66, 0.8),
                        ),
                      ),
                    ))
                .toList(),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: 257,
            height: 52,
            child: ElevatedButton(
              onPressed: onPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromRGBO(106, 149, 122, 1),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: const Text(
                "جرب الآن",
                style: TextStyle(
                  color: Color.fromRGBO(255, 255, 255, 1),
                  fontSize: 20,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
