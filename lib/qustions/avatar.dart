// ignore_for_file: avoid_print, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:calmleticsarab/constant.dart';
import 'package:calmleticsarab/http/api.dart';
import 'package:calmleticsarab/qustions/survey.dart';

class AvatarSelectionPage extends StatefulWidget {
  const AvatarSelectionPage({super.key});

  @override
  State<AvatarSelectionPage> createState() => _AvatarSelectionPageState();
}

class _AvatarSelectionPageState extends State<AvatarSelectionPage> {
  int? selectedAvatarIndex;
  String? selectedAvatarUrl;
  final Api api = Api();

  final List<String> avatarImages = List.generate(
    9,
    (index) => 'assets/images/avatar$index.png',
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
        MaterialPageRoute(builder: (context) => const SurveyScreen()),
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
    // حساب الأبعاد النسبية
    final size = MediaQuery.of(context).size;
    final double padding = size.width * 0.05; // 5% من العرض
    final double fontSizeTitle = size.width * 0.055;
    final double fontSizeSubtitle = size.width * 0.038;
    final double avatarRadius = size.width * 0.12; // نسبي
    final double checkRadius = avatarRadius * 0.25; // 25% من حجم الأفاتار

    return Scaffold(
      backgroundColor: bgcolor,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, size: size.width * 0.07),
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
        margin: EdgeInsets.all(padding),
        child: Padding(
          padding: EdgeInsets.all(padding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "اختر صورة رمزية لملفك الشخصي",
                style: TextStyle(
                  fontSize: fontSizeTitle,
                  fontWeight: FontWeight.bold,
                  color: textcolor,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: padding * 0.5),
              Text(
                "دي هتكون صورتك في ملفك الشخصي علشان نحافظ على هويتك",
                style: TextStyle(
                  fontSize: fontSizeSubtitle,
                  color: Colors.grey,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: padding),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(left: padding * 0.2),
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: padding,
                      mainAxisSpacing: padding,
                      childAspectRatio: 1.0, // يحافظ على الشكل الدائري
                    ),
                    itemCount: avatarImages.length,
                    itemBuilder: (context, index) {
                      bool isSelected = selectedAvatarIndex == index;
                      return GestureDetector(
                        onTap: () => _onAvatarSelected(index),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            SizedBox(
                              width: avatarRadius * 2,
                              height: avatarRadius * 2,
                              child: Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: isSelected
                                      ? Border.all(
                                          color: kPrimaryColor,
                                          width: 3,
                                        )
                                      : null,
                                ),
                                child: CircleAvatar(
                                  radius: avatarRadius,
                                  backgroundImage: AssetImage(
                                    avatarImages[index],
                                  ),
                                  backgroundColor: Colors.transparent,
                                ),
                              ),
                            ),
                            if (isSelected)
                              Positioned(
                                top: avatarRadius * 0.2,
                                right: avatarRadius * 0.001,
                                child: CircleAvatar(
                                  radius: checkRadius,
                                  backgroundColor: kPrimaryColor,
                                  child: Icon(
                                    Icons.check,
                                    size: checkRadius * 0.9,
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
              SizedBox(height: padding),
              ElevatedButton(
                onPressed:
                    selectedAvatarIndex != null ? _saveAvatarAndProceed : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: kPrimaryColor,
                  minimumSize: Size(double.infinity, size.height * 0.07),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  "التالي",
                  style: TextStyle(
                    fontSize: fontSizeTitle * 0.8,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
