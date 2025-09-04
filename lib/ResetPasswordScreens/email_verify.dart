import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:calmleticsarab/ResetPasswordScreens/otp_email.dart';
import 'package:calmleticsarab/constant.dart';
import 'package:calmleticsarab/widgets/custom_button.dart';

class EmailVerificationPage extends StatefulWidget {
  const EmailVerificationPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _EmailVerificationPageState createState() => _EmailVerificationPageState();
}

class _EmailVerificationPageState extends State<EmailVerificationPage> {
  final TextEditingController _emailController = TextEditingController();
  bool _isLoading = false;
  final FocusNode emailFocusNode = FocusNode();

  @override
  void dispose() {
    emailFocusNode.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _checkEmailAndNavigate() async {
    final email = _emailController.text.trim();

    if (email.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please enter your email')));
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await http.post(
        Uri.parse('http://10.0.2.2:8000/api/sendCode'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'email': email}),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['message'] == "Code sent successfully to your email.") {
          // Navigate to OTP page with email
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => OtpEmail(email: email), // Pass email here
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(data['message'] ?? 'Unexpected error occurred'),
            ),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Error verifying email. Please try again later.'),
          ),
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 50),
            const Text(
              "تابع عبر البريد الإلكتروني",
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: textcolor,
              ),
            ),
            const SizedBox(height: 13),
            const Text(
              "أدخل بريدك الإلكتروني، سنرسل لك رمز التحقق عبر البريد الإلكتروني",
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _emailController,
              focusNode: emailFocusNode,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                focusedBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: kPrimaryColor),
                ),
                floatingLabelStyle: const TextStyle(color: kPrimaryColor),
                labelText: "الايميل",
                labelStyle: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
                prefixIcon: Icon(
                  Icons.email_rounded,
                  color: emailFocusNode.hasFocus ? kPrimaryColor : Colors.grey,
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "email can't be null";
                }
                if (!RegExp(
                  r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$",
                ).hasMatch(value)) {
                  return "Please enter a valid email";
                }
                return null;
              },
              onTap: () => setState(() {}),
            ),
            const SizedBox(height: 100),
            _isLoading
                ? const CircularProgressIndicator()
                : CustomButton(text: "ارسال", ontap: _checkEmailAndNavigate),
          ],
        ),
      ),
    );
  }
}
