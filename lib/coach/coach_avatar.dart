import 'package:flutter/material.dart';
import 'package:calmleticsarab/coach/VR/vr.dart';
import 'package:calmleticsarab/constant.dart';
import 'package:calmleticsarab/http/api.dart';

class CoachAvatar extends StatefulWidget {
  const CoachAvatar({super.key});

  @override
  State<CoachAvatar> createState() => _CoachAvatarState();
}

class _CoachAvatarState extends State<CoachAvatar> {
  int? selectedAvatarIndex;
  String? selectedAvatarUrl;
  final Api api = Api();

  final List<String> avatarImages = List.generate(
    6,
    (index) => 'assets/images/coach$index.png',
  );

  void _onAvatarSelected(int index) {
    setState(() {
      selectedAvatarIndex = index;
      selectedAvatarUrl = avatarImages[index];
    });
  }

  Future<void> _saveAvatarAndProceed() async {
    if (selectedAvatarUrl == null) return;

    bool success = await api.saveSelectedAvatar(selectedAvatarUrl!);

    if (success) {
      print("Avatar saved successfully!");
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const Vr()),
      );
    } else {
      print("Failed to save avatar.");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Failed to save avatar. Please try again."),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgcolor,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, size: 30),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(32),
          color: Colors.white,
        ),
        child: Padding(
          padding: const EdgeInsets.all(35),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                "Select an avatar for your profile",
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: textcolor,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              const Text(
                "This will represent your picture on your profile. We like you to protect your identity.",
                style: TextStyle(fontSize: 16, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 5),
                  child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                        ),
                    itemCount: avatarImages.length,
                    itemBuilder: (context, index) {
                      bool isSelected = selectedAvatarIndex == index;
                      return GestureDetector(
                        onTap: () => _onAvatarSelected(index),
                        child: Stack(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                border:
                                    isSelected
                                        ? Border.all(
                                          color: kPrimaryColor,
                                          width: 2,
                                        )
                                        : null,
                                shape: BoxShape.circle,
                              ),
                              child: CircleAvatar(
                                radius: 45,
                                backgroundImage: AssetImage(
                                  avatarImages[index],
                                ),
                              ),
                            ),
                            if (isSelected)
                              const Positioned(
                                top: 5,
                                left: 70,
                                child: CircleAvatar(
                                  radius: 12,
                                  backgroundColor: kPrimaryColor,
                                  child: Icon(
                                    Icons.check,
                                    size: 16,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
              ElevatedButton(
                onPressed:
                    selectedAvatarIndex != null ? _saveAvatarAndProceed : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: kPrimaryColor,
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: const Text(
                  "Next",
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
