import 'package:flutter/material.dart';
import 'package:calmleticsarab/constant.dart';
import 'package:calmleticsarab/auth_screens/signup_page.dart';
import 'package:calmleticsarab/widgets/custom_button.dart';

class UserType extends StatefulWidget {
  const UserType({super.key});

  @override
  State<UserType> createState() => _UserTypeState();
}

class _UserTypeState extends State<UserType> {
  String selectedRole = '';

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: bgcolor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: screenHeight * 0.05),
            Text(
              "اختر دورك",
              style: TextStyle(
                color: const Color(0xff3B3B3B),
                fontSize: screenWidth * 0.08,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: screenHeight * 0.02),
            GestureDetector(
              onTap: () {
                setState(() {
                  selectedRole = 'Coach';
                });
              },
              child: Stack(
                alignment: Alignment.center,
                children: [
                  CircleAvatar(
                    radius: screenWidth * 0.22,
                    backgroundColor:
                        selectedRole == 'Coach'
                            ? Colors.green[100]
                            : Colors.white,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(screenWidth * 0.2),
                        border: Border.all(
                          color:
                              selectedRole == 'Coach'
                                  ? kPrimaryColor
                                  : Colors.grey,
                          width: 2,
                        ),
                      ),
                      child: CircleAvatar(
                        radius: screenWidth * 0.2,
                        backgroundImage: const AssetImage(
                          'assets/images/Coach 1.jpg',
                        ),
                      ),
                    ),
                  ),
                  if (selectedRole == 'Coach')
                    Positioned(
                      top: screenWidth * 0.03,
                      left: screenWidth * 0.6,
                      child: CircleAvatar(
                        radius: screenWidth * 0.03,
                        backgroundColor: kPrimaryColor,
                        child: Icon(
                          Icons.check,
                          size: screenWidth * 0.025,
                          color: Colors.white,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            SizedBox(height: screenHeight * 0.01),
            Text(
              "مدرب",
              style: TextStyle(
                color: const Color(0xff3B3B3B),
                fontSize: screenWidth * 0.06,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: screenHeight * 0.03),
            GestureDetector(
              onTap: () {
                setState(() {
                  selectedRole = 'Player';
                });
              },
              child: Stack(
                alignment: Alignment.center,
                children: [
                  CircleAvatar(
                    radius: screenWidth * 0.22,
                    backgroundColor:
                        selectedRole == 'Player'
                            ? Colors.green[100]
                            : Colors.white,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(screenWidth * 0.2),
                        border: Border.all(
                          color:
                              selectedRole == 'Player'
                                  ? kPrimaryColor
                                  : Colors.grey,
                          width: 2,
                        ),
                      ),
                      child: CircleAvatar(
                        radius: screenWidth * 0.2,
                        backgroundImage: const AssetImage(
                          'assets/images/Coach 2.jpg',
                        ),
                      ),
                    ),
                  ),
                  if (selectedRole == 'Player')
                    Positioned(
                      top: screenWidth * 0.03,
                      left: screenWidth * 0.6,
                      child: CircleAvatar(
                        radius: screenWidth * 0.03,
                        backgroundColor: kPrimaryColor,
                        child: Icon(
                          Icons.check,
                          size: screenWidth * 0.025,
                          color: Colors.white,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            SizedBox(height: screenHeight * 0.01),
            Text(
              "لاعب",
              style: TextStyle(
                color: const Color(0xff3B3B3B),
                fontSize: screenWidth * 0.06,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: screenHeight * 0.07),
            CustomButton(
              text: "التالي",
              ontap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Signup(userRole: selectedRole),
                  ),
                );
              },
            ),
            SizedBox(height: screenHeight * 0.04),
          ],
        ),
      ),
    );
  }
}
