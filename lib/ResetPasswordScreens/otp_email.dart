import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:calmleticsarab/ResetPasswordScreens/Reset.dart';
import 'package:calmleticsarab/constant.dart';
import 'package:calmleticsarab/widgets/custom_button.dart';

class OtpEmail extends StatefulWidget {
  final String email;

  const OtpEmail({required this.email, super.key});

  @override
  _OtpEmailState createState() => _OtpEmailState();
}

class _OtpEmailState extends State<OtpEmail> {
  final List<TextEditingController> textControllers = List.generate(
    4,
    (index) => TextEditingController(),
  );
  late List<FocusNode> focusNodes;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    focusNodes = List.generate(4, (index) => FocusNode());
  }

  @override
  void dispose() {
    for (var node in focusNodes) {
      node.dispose();
    }
    for (var controller in textControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  Widget _buildOTPBox(int index) {
    return SizedBox(
      width: 60,
      child: TextField(
        controller: textControllers[index],
        focusNode: focusNodes[index],
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        textDirection: TextDirection.ltr,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        style: const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
        maxLength: 1,
        decoration: const InputDecoration(
          counterText: "",
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: kPrimaryColor),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: kPrimaryColor, width: 2),
          ),
        ),
        onChanged: (value) {
          if (value.isNotEmpty) {
            if (index < 3) {
              FocusScope.of(context).requestFocus(focusNodes[index + 1]);
            } else {
              focusNodes[index].unfocus();
            }
          } else if (value.isEmpty && index > 0) {
            FocusScope.of(context).requestFocus(focusNodes[index - 1]);
          }
        },
      ),
    );
  }

  Future<void> _verifyOTP() async {
    String otp = textControllers.map((controller) => controller.text).join();

    if (otp.length != 4 || otp.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter the 4-digit verification code'),
        ),
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
            SnackBar(content: Text(data['message'] ?? 'Invalid code.')),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error verifying the code.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _resendOTP() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('The verification code has been sent again'),
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
        padding: const EdgeInsets.all(16),
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
                'يرجى إدخال الرمز الذي أرسلناه للتو إلى ${widget.email}',
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.grey, fontSize: 16),
              ),
              const SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(4, (index) => _buildOTPBox(index)),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'لم تستلم رمز التحقق؟',
                    style: TextStyle(fontSize: 16),
                  ),
                  TextButton(
                    onPressed: _resendOTP,
                    child: const Text(
                      "إعادة إرسال الرمز",
                      style: TextStyle(
                        color: Color.fromARGB(255, 9, 90, 51),
                        fontSize: 15,
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
