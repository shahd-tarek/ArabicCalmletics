// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously

import 'package:calmleticsarab/features/resetPassword/View/reset.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart'; // المكتبة الجديدة
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:calmleticsarab/constant.dart';
import 'package:calmleticsarab/widgets/custom_button.dart';

class OtpEmail extends StatefulWidget {
  final String email;

  const OtpEmail({required this.email, super.key});

  @override
  _OtpEmailState createState() => _OtpEmailState();
}

class _OtpEmailState extends State<OtpEmail> {
  // نحتاج الآن إلى وحدة تحكم واحدة فقط للـ OTP بالكامل
  TextEditingController otpController = TextEditingController();
  bool _isLoading = false;
  String currentText = "";

  @override
  void dispose() {
    otpController.removeListener(() {});

    super.dispose();
  }

  Future<void> _verifyOTP() async {
    String otp = otpController.text;

    if (otp.length != 4) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('يرجى إدخال رمز التحقق المكون من 4 أرقام')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await http.post(
        Uri.parse('http://10.0.2.2:8000/api/vertifyCode?'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'email': widget.email, 'code': otp}),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['message']?.toLowerCase() == "successfully") {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const ResetPass()),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(data['message'] ?? 'الرمز غير صحيح.')),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('خطأ في التحقق من الرمز.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _resendOTP() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('تم إعادة إرسال رمز التحقق')),
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
        padding: const EdgeInsets.symmetric(horizontal: 30),
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
              Text(
                'يرجى إدخال الرمز الذي أرسلناه للتو إلى\n${widget.email}',
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.grey, fontSize: 16),
              ),
              const SizedBox(height: 40),

              // --- استخدام PinCodeTextField هنا ---
              PinCodeTextField(
                appContext: context,
                length: 4, // عدد الخانات
                obscureText: false,
                animationType: AnimationType.fade,
                pinTheme: PinTheme(
                  shape: PinCodeFieldShape.underline,
                  fieldHeight: 50,
                  fieldWidth: 50,
                  activeColor: kPrimaryColor, // اللون عند الكتابة
                  inactiveColor: Colors.grey, // اللون قبل الكتابة
                  selectedColor: kPrimaryColor, // اللون عند الاختيار
                ),
                animationDuration: const Duration(milliseconds: 300),
                backgroundColor: Colors.transparent,
                enableActiveFill: false,
                controller: otpController,
                keyboardType: TextInputType.number,
                onCompleted: (v) {
                  debugPrint("Completed: $v");
                },
                onChanged: (value) {
                  setState(() {
                    currentText = value;
                  });
                },
                beforeTextPaste: (text) {
                  return true; // السماح بلصق الرمز
                },
              ),
              // -----------------------------------

              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'لم تستلم رمز التحقق؟',
                    style: TextStyle(fontSize: 14),
                  ),
                  TextButton(
                    onPressed: _resendOTP,
                    child: const Text(
                      "إعادة إرسال الرمز",
                      style: TextStyle(
                        color: Color.fromARGB(255, 9, 90, 51),
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              _isLoading
                  ? const CircularProgressIndicator()
                  : CustomButton(text: "تحقق", ontap: _verifyOTP),
            ],
          ),
        ),
      ),
    );
  }
}
