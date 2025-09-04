import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // لاستيراد input formatters
import 'package:calmleticsarab/ResetPasswordScreens/Reset.dart';
import 'package:calmleticsarab/constant.dart';
import 'package:calmleticsarab/widgets/custom_button.dart';

class OtpPhone extends StatefulWidget {
  const OtpPhone({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _OtpPhoneState createState() => _OtpPhoneState();
}

class _OtpPhoneState extends State<OtpPhone> {
  final List<TextEditingController> textControllers = List.generate(
    4,
    (index) => TextEditingController(),
  );
  late List<FocusNode> focusNodes;

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
      width: 60, // عرض الحقل
      child: TextField(
        controller: textControllers[index],
        focusNode: focusNodes[index],
        keyboardType: TextInputType.number, // لوحة مفاتيح الأرقام
        textAlign: TextAlign.center, // النص في المنتصف
        textDirection: TextDirection.ltr, // اتجاه النص من اليسار لليمين
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly, // أرقام فقط
        ],
        style: const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Colors.black, // لون النص
        ),
        maxLength: 1, // عدد الحروف المسموح به
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

  void _verifyOTP() {
    String otp = textControllers.map((controller) => controller.text).join();
    if (otp.length == 4 && otp.isNotEmpty) {
      // Navigate to the Reset Password screen
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const ResetPass()),
      );
    } else {
      // Show an error message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter the 4-digit verification code'),
        ),
      );
    }
  }

  void _resendOTP() {
    // Handle resend OTP logic here, like calling an API or sending a request.
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
              const Text(
                'يرجى إدخال الرمز الذي أرسلناه للتو',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey, fontSize: 16),
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
              CustomButton(text: "تحقق", ontap: _verifyOTP),
            ],
          ),
        ),
      ),
    );
  }
}
