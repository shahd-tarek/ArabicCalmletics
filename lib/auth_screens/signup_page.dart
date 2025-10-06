// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:calmleticsarab/coach/coach_avatar.dart';
import 'package:calmleticsarab/constant.dart';
import 'package:calmleticsarab/auth_screens/login_page.dart';
import 'package:calmleticsarab/http/api.dart';
import 'package:calmleticsarab/qustions/start.dart';
import 'package:calmleticsarab/widgets/custom_button.dart';

class Signup extends StatefulWidget {
  final String userRole;
  const Signup({super.key, required this.userRole});
  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  TextEditingController emailController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController cpasswordControllerr = TextEditingController();
  bool visiable = true;
  bool pvisiable = true;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final nameFocusNode = FocusNode();
  final emailFocusNode = FocusNode();
  final passwordFocusNode = FocusNode();
  final confirmPasswordFocusNode = FocusNode();
  bool isNameFocused = false;
  bool isEmailFocused = false;
  bool isPasswordFocused = false;
  bool isConfirmPasswordFocused = false;
  final Api api = Api();

  void showLoadingDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(
        child: CircularProgressIndicator(color: kPrimaryColor),
      ),
    );
  }

  void hideLoadingDialog() {
    Navigator.of(context, rootNavigator: true).pop();
  }

  void showModernDialog(String title, String message, {bool success = true}) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
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

  Future<void> handleSignUp() async {
    final name = nameController.text;
    final email = emailController.text;
    final password = passwordController.text;
    final confirmPassword = cpasswordControllerr.text;
    if (password != confirmPassword) {
      showModernDialog("Error", "Passwords do not match", success: false);
      return;
    }
    showLoadingDialog();
    final response = await api.signUp(
      name,
      email,
      password,
      confirmPassword,
      widget.userRole,
    );
    hideLoadingDialog();
    if (response.token.isNotEmpty) {
      String successMessage = widget.userRole == "Coach"
          ? "coach successfully registered"
          : "player successfully registered";
      if (response.message.contains(successMessage)) {
        Widget nextPage =
            widget.userRole == "Coach" ? const CoachAvatar() : const Start();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => nextPage),
        );
      } else {
        showModernDialog("Error", response.message, success: false);
      }
    } else {
      showModernDialog(
        "Error",
        "Registration Failed: ${response.message}",
        success: false,
      );
    }
  }

  @override
  void initState() {
    super.initState();
    nameFocusNode.addListener(() {
      setState(() {
        isNameFocused = nameFocusNode.hasFocus;
      });
    });
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
    confirmPasswordFocusNode.addListener(() {
      setState(() {
        isConfirmPasswordFocused = confirmPasswordFocusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    nameFocusNode.dispose();
    emailFocusNode.dispose();
    passwordFocusNode.dispose();
    confirmPasswordFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    final double horizontalPadding = screenWidth * 0.03;

    return Scaffold(
      backgroundColor: bgcolor,
      body: Form(
        key: formKey,
        child: Padding(
          padding: EdgeInsets.all(horizontalPadding),
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
                      "أنشئ حسابك",
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
                      "مرحبًا بك في التطبيق، حيث تبدأ رحلتك!",
                      style: TextStyle(
                        fontSize: screenWidth * 0.035,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: screenHeight * 0.03),
                TextFormField(
                  controller: nameController,
                  focusNode: nameFocusNode,
                  decoration: InputDecoration(
                    focusedBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: kPrimaryColor),
                    ),
                    floatingLabelStyle: const TextStyle(
                      color: Color.fromARGB(255, 2, 46, 25),
                    ),
                    labelText: "الاسم",
                    labelStyle: TextStyle(
                      fontSize: screenWidth * 0.035,
                      fontWeight: FontWeight.bold,
                    ),
                    prefixIcon: Icon(
                      Icons.account_circle_rounded,
                      color: isNameFocused ? kPrimaryColor : Colors.grey,
                    ),
                  ),
                  keyboardType: TextInputType.name,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return ("من فضلك ادخل اسمك");
                    }
                    return null;
                  },
                ),
                SizedBox(height: screenHeight * 0.02),
                TextFormField(
                  controller: emailController,
                  focusNode: emailFocusNode,
                  decoration: InputDecoration(
                    focusedBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: kPrimaryColor),
                    ),
                    floatingLabelStyle: const TextStyle(
                      color: Color.fromARGB(255, 2, 46, 25),
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
                      return "من فضلك ادخل الايميل";
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
                    if (value!.length < 6) {
                      return ("كلمة المرور قصيرة جدا");
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
                  keyboardType: TextInputType.text,
                ),
                SizedBox(height: screenHeight * 0.02),
                TextFormField(
                  controller: cpasswordControllerr,
                  focusNode: confirmPasswordFocusNode,
                  obscureText: pvisiable,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "من فضلك أكيد كلمة السر";
                    }
                    if (value != passwordController.text) {
                      return "Passwords do not match";
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
                      color: isConfirmPasswordFocused
                          ? kPrimaryColor
                          : Colors.grey,
                    ),
                    labelText: "تأكيد كلمة السر",
                    labelStyle: TextStyle(
                      fontSize: screenWidth * 0.035,
                      fontWeight: FontWeight.bold,
                    ),
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          pvisiable = !pvisiable;
                        });
                      },
                      icon: Icon(
                        pvisiable ? Icons.visibility_off : Icons.visibility,
                      ),
                    ),
                  ),
                  keyboardType: TextInputType.text,
                ),
                SizedBox(height: screenHeight * 0.08),
                CustomButton(
                  text: "انشاء حساب",
                  ontap: () {
                    if (formKey.currentState!.validate()) {
                      handleSignUp();
                    }
                  },
                ),
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
                      "هل لديك حساب بالفعل؟",
                      style: TextStyle(
                        fontSize: screenWidth * 0.035,
                        color: const Color.fromARGB(255, 107, 106, 106),
                      ),
                    ),
                    SizedBox(width: screenWidth * 0.02),
                    InkWell(
                      onTap: () {
                        if (widget.userRole.isEmpty) {
                          showModernDialog(
                            "Error",
                            "Please select a role before proceeding.",
                            success: false,
                          );
                          return;
                        }
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                LoginPage(selectedRole: widget.userRole),
                          ),
                        );
                      },
                      child: Text(
                        "تسجيل الدخول",
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
