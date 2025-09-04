import 'package:flutter/material.dart';

class TopThree extends StatelessWidget {
  final List<Map<String, dynamic>> topUsers;

  const TopThree({
    super.key,
    required this.topUsers,
  });

  @override
  Widget build(BuildContext context) {
    // عدد المستخدمين اللي عايزين نعرضهم (حتى 3)
    final displayCount = topUsers.length < 3 ? topUsers.length : 3;

    // لو ما فيش مستخدمين، نعرض رسالة بدل الـ Row
    if (displayCount == 0) {
      return const Center(child: Text("No top users available"));
    }

    // نجهز قائمة الأعمدة اللي هنعرضها
    List<Widget> userColumns = [];

    // عشان ترتيب الرتب 1,2,3 مع صور خاصة بكل رتبة
    final rankImages = ['assets/images/1.png', 'assets/images/2.png', 'assets/images/3.png'];

    for (int i = 0; i < displayCount; i++) {
      userColumns.add(_buildUserColumn(topUsers[i], '${i + 1}', rankImages[i]));
    }

    // لو عدد المستخدمين أقل من 3، نملأ الفراغات بعناصر فارغة أو نقدر نوزع الأعمدة بطريقة مختلفة
    // هنا هنعرض بس الأعمدة الموجودة

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: userColumns,
    );
  }

  Widget _buildUserColumn(
      Map<String, dynamic> user, String rank, String image) {
    double topPadding = 0; // Default padding

    if (rank == '2') {
      topPadding = 20;
    } else if (rank == '3') {
      topPadding = 50;
    }

    final imagePath = user['image'] as String?;
    final userName = user['name'] as String? ?? 'Unknown';
    final points = user['total_score'] ?? 0;

    ImageProvider avatarImage;

    if (imagePath != null && imagePath.isNotEmpty) {
      if (imagePath.startsWith('assets/')) {
        avatarImage = AssetImage(imagePath);
      } else {
        avatarImage = NetworkImage(imagePath);
      }
    } else {
      avatarImage = const AssetImage('assets/images/avatar3.png');
    }

    return Column(
      children: [
        SizedBox(height: topPadding),
        CircleAvatar(
          radius: 25,
          backgroundColor: Colors.grey,
          backgroundImage: avatarImage,
        ),
        const SizedBox(height: 10),
        Text(
          userName,
          style: const TextStyle(
            fontSize: 16,
            color: Color.fromRGBO(0, 0, 0, 1),
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        Container(
          width: 55,
          height: 27,
          decoration: BoxDecoration(
            color: const Color.fromRGBO(233, 239, 235, 1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Center(
            child: Text(
              points.toString(),
              style: const TextStyle(
                fontSize: 16,
                color: Color.fromRGBO(106, 149, 122, 1),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        Stack(
          alignment: Alignment.center,
          children: [
            Image.asset(
              image,
              width: rank == '1' ? 108 : 127,
              height: rank == '1' ? 137 : 102,
            ),
            Text(
              rank,
              style: TextStyle(
                fontSize: rank == '1' ? 128 : 96,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
