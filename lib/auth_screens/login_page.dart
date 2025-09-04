import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:calmleticsarab/ResetPasswordScreens/forgetpass.dart';
import 'package:calmleticsarab/coach/screens/coach_home.dart';
import 'package:calmleticsarab/constant.dart';
import 'package:calmleticsarab/http/api.dart';
import 'package:calmleticsarab/views/main_screen.dart';
import 'package:calmleticsarab/widgets/custom_button.dart';

class LoginPage extends StatefulWidget {
  final String? selectedRole;
  const LoginPage({super.key, this.selectedRole});
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool visiable = true;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final emailFocusNode = FocusNode();
  final passwordFocusNode = FocusNode();
  bool isEmailFocused = false;
  bool isPasswordFocused = false;
  late String selectedRole;
  final Api api = Api();

  @override
  void initState() {
    super.initState();
    selectedRole = widget.selectedRole!;
    emailFocusNode.addListener(() {
      setState(() {
        isEmailFocused = emailFocusNode.hasFocus;
      });
    });
    passwordFocusNode.addListener(() {
      setState(() {
        isPasswordFocused = passwordFocusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    emailFocusNode.dispose();
    passwordFocusNode.dispose();
    super.dispose();
  }

  void showLoadingDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (_) => const Center(
            child: CircularProgressIndicator(color: kPrimaryColor),
          ),
    );
  }

  void hideLoadingDialog() {
    Navigator.of(context, rootNavigator: true).pop();
  }

  Future<void> handleLogin() async {
    if (!formKey.currentState!.validate()) return;
    showLoadingDialog();
    try {
      final response = await api.loginUser(
        emailController.text.trim(),
        passwordController.text.trim(),
        selectedRole,
      );
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('authToken', response.token);
      hideLoadingDialog();
      Future.delayed(const Duration(), () {
        Widget nextPage =
            selectedRole == "Coach" ? const CoachHome() : const MainScreen();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => nextPage),
        );
      });
    } catch (e) {
      hideLoadingDialog();
      showModernDialog("Oops!", "please try again", success: false);
    }
  }

  void showModernDialog(String title, String message, {bool success = true}) {
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: Row(
              children: [
                Icon(
                  success ? Icons.check_circle : Icons.error,
                  color: success ? Colors.green : Colors.red,
                ),
                const SizedBox(width: 10),
                Text(
                  title,
                  style: TextStyle(
                    color: success ? Colors.green : Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            content: Text(message, style: const TextStyle(fontSize: 16)),
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    final double horizontalPadding = screenWidth * 0.02;

    return Scaffold(
      backgroundColor: bgcolor,
      body: Form(
        key: formKey,
        child: Padding(
          padding: EdgeInsets.all(screenWidth * 0.05),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: screenHeight * 0.05),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      "assets/images/logo.png",
                      width: screenWidth * 0.12,
                      height: screenWidth * 0.12,
                    ),
                    Text(
                      "Calmletics",
                      style: TextStyle(
                        fontSize: screenWidth * 0.06,
                        fontWeight: FontWeight.bold,
                        color: kPrimaryColor,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: screenHeight * 0.03),
                Row(
                  children: [
                    SizedBox(width: horizontalPadding),
                    Text(
                      "تسجيل الدخول إلى حسابك",
                      style: TextStyle(
                        fontSize: screenWidth * 0.05,
                        fontWeight: FontWeight.bold,
                        color: textcolor,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: screenHeight * 0.015),
                Row(
                  children: [
                    SizedBox(width: horizontalPadding),
                    Text(
                      "مرحبًا بعودتك هل أنت مستعد لإدارة صحتك بفعالية؟",
                      style: TextStyle(
                        fontSize: screenWidth * 0.035,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: screenHeight * 0.03),
                TextFormField(
                  controller: emailController,
                  focusNode: emailFocusNode,
                  decoration: InputDecoration(
                    focusedBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: kPrimaryColor),
                    ),
                    floatingLabelStyle: const TextStyle(
                      color: Color.fromARGB(255, 9, 90, 51),
                    ),
                    labelText: "الايميل",
                    labelStyle: TextStyle(
                      fontSize: screenWidth * 0.035,
                      fontWeight: FontWeight.bold,
                    ),
                    prefixIcon: Icon(
                      Icons.email_rounded,
                      color: isEmailFocused ? kPrimaryColor : Colors.grey,
                    ),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter your email";
                    }
                    if (!RegExp(
                      r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$",
                    ).hasMatch(value)) {
                      return "Please enter a valid email";
                    }
                    return null;
                  },
                ),
                SizedBox(height: screenHeight * 0.02),
                TextFormField(
                  controller: passwordController,
                  focusNode: passwordFocusNode,
                  obscureText: visiable,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter your password";
                    }
                    if (value.length < 6) {
                      return "Password is too short";
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    focusedBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: kPrimaryColor),
                    ),
                    floatingLabelStyle: const TextStyle(
                      color: Color.fromARGB(255, 2, 46, 25),
                    ),
                    prefixIcon: Icon(
                      Icons.lock_rounded,
                      color: isPasswordFocused ? kPrimaryColor : Colors.grey,
                    ),
                    labelText: "كلمة السر",
                    labelStyle: TextStyle(
                      fontSize: screenWidth * 0.035,
                      fontWeight: FontWeight.bold,
                    ),
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          visiable = !visiable;
                        });
                      },
                      icon: Icon(
                        visiable ? Icons.visibility_off : Icons.visibility,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: screenHeight * 0.015),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const Forget(),
                          ),
                        );
                      },
                      child: Text(
                        "هل نسيت كلمة السر ؟",
                        style: TextStyle(
                          color: kPrimaryColor,
                          fontSize: screenWidth * 0.04,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: screenHeight * 0.08),
                CustomButton(text: "تسجيل الدخول", ontap: handleLogin),
                SizedBox(height: screenHeight * 0.04),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image(image: AssetImage("assets/images/Ellipse 2.png")),
                    SizedBox(width: 10),
                    Image(image: AssetImage("assets/images/Ellipse 3.png")),
                  ],
                ),
                SizedBox(height: screenHeight * 0.03),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "لا تمتلك حسابًا؟",
                      style: TextStyle(
                        fontSize: screenWidth * 0.035,
                        color: const Color.fromARGB(255, 107, 106, 106),
                      ),
                    ),
                    SizedBox(width: screenWidth * 0.02),
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        "سجل الآن",
                        style: TextStyle(
                          color: kPrimaryColor,
                          fontSize: screenWidth * 0.035,
                          decoration: TextDecoration.underline,
                          decorationColor: kPrimaryColor,
                          decorationThickness: 2,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
