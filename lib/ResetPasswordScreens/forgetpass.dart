import 'package:flutter/material.dart';
import 'package:calmleticsarab/ResetPasswordScreens/email_verify.dart';
import 'package:calmleticsarab/ResetPasswordScreens/phone_verify.dart';
import 'package:calmleticsarab/constant.dart';
import 'package:calmleticsarab/widgets/custom_button.dart';

class Forget extends StatefulWidget {
  const Forget({super.key});

  @override
  State<Forget> createState() => _ForgetState();
}

class _ForgetState extends State<Forget> {
  bool isEmailSelected = false;
  bool isPhoneSelected = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: bgcolor,
        elevation: 0,
      ),
      backgroundColor: bgcolor,
      body: LayoutBuilder(
        builder: (context, constraints) {
          final double screenWidth = constraints.maxWidth;
          final double screenHeight = constraints.maxHeight;

          // قياسات  بناءً على حجم الشاشة
          final double horizontalPadding = screenWidth * 0.05;
          final double verticalSpacing = screenHeight * 0.015;
          final double titleFontSize = screenWidth * 0.06;
          final double subtitleFontSize = screenWidth * 0.045;

          return Padding(
            padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: screenHeight * 0.03),
                  Text(
                    'نسيت كلمة المرور',
                    style: TextStyle(
                      fontSize: titleFontSize > 28 ? 28 : titleFontSize,
                      fontWeight: FontWeight.bold,
                      color: textcolor,
                    ),
                  ),
                  SizedBox(height: verticalSpacing),
                  Text(
                    'يرجى اختيار الطريقة لإرسال رابط إعادة تعيين كلمة المرور',
                    style: TextStyle(
                      fontSize: subtitleFontSize > 18 ? 18 : subtitleFontSize,
                      color: Colors.grey,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: screenHeight * 0.03),

                  // Reset via Email
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        isEmailSelected = true;
                        isPhoneSelected = false;
                      });
                    },
                    child: Container(
                      height: screenHeight * 0.08,
                      padding: EdgeInsets.symmetric(
                        vertical: screenHeight * 0.015,
                        horizontal: screenWidth * 0.04,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isEmailSelected ? kPrimaryColor : Colors.grey,
                          width: 1.5,
                        ),
                        boxShadow:
                            isEmailSelected
                                ? [
                                  BoxShadow(
                                    color: kPrimaryColor.withOpacity(0.3),
                                    spreadRadius: 2,
                                    blurRadius: 5,
                                    offset: const Offset(0, 3),
                                  ),
                                ]
                                : null,
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.email_rounded,
                            color:
                                isEmailSelected ? kPrimaryColor : Colors.grey,
                          ),
                          SizedBox(width: screenWidth * 0.03),
                          Text(
                            'اعادة التعيين عبر البريد الاكتروني ',
                            style: TextStyle(
                              fontSize: screenWidth * 0.045,
                              color:
                                  isEmailSelected ? kPrimaryColor : Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: screenHeight * 0.03),

                  // Reset via Phone
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        isPhoneSelected = true;
                        isEmailSelected = false;
                      });
                    },
                    child: Container(
                      height: screenHeight * 0.08,
                      padding: EdgeInsets.symmetric(
                        vertical: screenHeight * 0.015,
                        horizontal: screenWidth * 0.04,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isPhoneSelected ? kPrimaryColor : Colors.grey,
                          width: 1.5,
                        ),
                        boxShadow:
                            isPhoneSelected
                                ? [
                                  BoxShadow(
                                    color: kPrimaryColor.withOpacity(0.3),
                                    spreadRadius: 2,
                                    blurRadius: 5,
                                    offset: const Offset(0, 3),
                                  ),
                                ]
                                : null,
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.phone,
                            color:
                                isPhoneSelected ? kPrimaryColor : Colors.grey,
                          ),
                          SizedBox(width: screenWidth * 0.03),
                          Text(
                            'إعادة التعيين عبر الهاتف',
                            style: TextStyle(
                              fontSize: screenWidth * 0.045,
                              color:
                                  isPhoneSelected ? kPrimaryColor : Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: screenHeight * 0.05),

                  // Custom Button
                  SizedBox(
                    width: double.infinity,
                    child: CustomButton(
                      text: "اكمل",
                      ontap: () {
                        if (isEmailSelected || isPhoneSelected) {
                          if (isEmailSelected) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) => const EmailVerificationPage(),
                              ),
                            );
                          } else if (isPhoneSelected) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const PhoneVerify(),
                              ),
                            );
                          }
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                "من فضلك اختار البريد الألكتروني أو الهاتف",
                              ),
                            ),
                          );
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
