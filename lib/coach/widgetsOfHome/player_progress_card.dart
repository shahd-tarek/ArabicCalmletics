import 'package:flutter/material.dart';

class PlayerProgressCard extends StatelessWidget {
  final String playerName;
  final String communityName;
  final String statusMessage;
  final String? playerImage;
  final String imageUrl;

  const PlayerProgressCard({
    super.key,
    required this.playerName,
    required this.communityName,
    required this.statusMessage,
    required this.imageUrl,
    this.playerImage,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          width: double.infinity,
          height: 120,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color.fromRGBO(218, 218, 218, 1)),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile Image
              Container(
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  border: Border.all(
                    color: const Color.fromRGBO(226, 226, 226, 1),
                  ),
                ),
                child: ClipOval(
                  child: playerImage != null
                      ? Image.asset(playerImage!, fit: BoxFit.cover)
                      : Image.asset('assets/images/Coach 3.png',
                          fit: BoxFit.cover),
                ),
              ),
              const SizedBox(width: 12),

              // Text Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Player and Community Texts
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              playerName,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Color.fromRGBO(78, 78, 78, 1),
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              communityName,
                              style: const TextStyle(
                                fontSize: 16,
                                color: Color.fromRGBO(160, 160, 160, 1),
                              ),
                            ),
                          ],
                        ),

                        Container(
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                            image: imageUrl.isNotEmpty
                                ? DecorationImage(
                                    image: NetworkImage(imageUrl),
                                    fit: BoxFit.cover,
                                  )
                                : null,
                          ),
                          child: imageUrl.isEmpty
                              ? const Icon(
                                  Icons.error,
                                  color: Colors.red,
                                  size: 18,
                                )
                              : null,
                        )
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      statusMessage,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color.fromRGBO(78, 78, 78, 1),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}
