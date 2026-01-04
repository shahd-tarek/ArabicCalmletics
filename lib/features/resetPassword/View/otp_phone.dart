// ignore_for_file: library_private_types_in_public_api

import 'package:calmleticsarab/features/resetPassword/View/reset.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart'; // المكتبة الجديدة
import 'package:calmleticsarab/constant.dart';
import 'package:calmleticsarab/widgets/custom_button.dart';

class OtpPhone extends StatefulWidget {
  const OtpPhone({super.key});

  @override
  _OtpPhoneState createState() => _OtpPhoneState();
}

class _OtpPhoneState extends State<OtpPhone> {
  // نحتاج الآن إلى متحكم واحد فقط للرمز بالكامل
  TextEditingController otpController = TextEditingController();
  String currentText = "";
@override
void dispose() {

  otpController.removeListener(() { }); 
  
  super.dispose();
}

  void _verifyOTP() {
    String otp = otpController.text;
    if (otp.length == 4) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const ResetPass()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('يرجى إدخال رمز التحقق المكون من 4 أرقام'),
        ),
      );
    }
  }

  void _resendOTP() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('تم إعادة إرسال رمز التحقق'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 80),
              const Text(
                'رمز التحقق',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: textcolor,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'يرجى إدخال الرمز الذي أرسلناه للتو',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey, fontSize: 16),
              ),
              const SizedBox(height: 40),

              // --- بداية استخدام PinCodeTextField ---
              PinCodeTextField(
                appContext: context,
                length: 4, // طول الرمز
                obscureText: false,
                animationType: AnimationType.fade,
                pinTheme: PinTheme(
                  shape: PinCodeFieldShape
                      .underline, // شكل الخط السفلي كما في تصميمك
                  fieldHeight: 50,
                  fieldWidth: 50,
                  activeColor: kPrimaryColor, // لون الخط عند الامتلاء
                  selectedColor: kPrimaryColor, // لون الخط عند التحديد
                  inactiveColor: Colors.grey[300], // لون الخط وهو فارغ
                ),
                animationDuration: const Duration(milliseconds: 300),
                backgroundColor: Colors.transparent,
                enableActiveFill: false,
                controller: otpController,
                keyboardType: TextInputType.number,
                onCompleted: (v) {
                  // يمكن استدعاء التحقق تلقائياً هنا عند اكتمال الـ 4 أرقام
                  _verifyOTP();
                },
                onChanged: (value) {
                  setState(() {
                    currentText = value;
                  });
                },
              ),

              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'لم تستلم رمز التحقق؟',
                    style: TextStyle(fontSize: 15),
                  ),
                  TextButton(
                    onPressed: _resendOTP,
                    child: const Text(
                      "إعادة إرسال الرمز",
                      style: TextStyle(
                        color: Color.fromARGB(255, 9, 90, 51),
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),
              CustomButton(text: "تحقق", ontap: _verifyOTP),
            ],
          ),
        ),
      ),
    );
  }
}
