import 'package:flutter/material.dart';
import 'package:calmleticsarab/auth_screens/login_page.dart';
import 'package:calmleticsarab/constant.dart';
import 'package:calmleticsarab/http/api.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class UserProfileOverview extends StatefulWidget {
  const UserProfileOverview({super.key});

  @override
  _UserProfileOverviewState createState() => _UserProfileOverviewState();
}

class _UserProfileOverviewState extends State<UserProfileOverview> {
  Map<String, dynamic>? userData;
  bool isLoading = true;
  String? profileImage;
  final Api api = Api();

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    final data = await api.fetchUserData();
    if (data != null) {
      setState(() {
        userData = data;
        profileImage = userData?['image'];
        isLoading = false;
      });
    }
  }

  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("user_token");

    final response = await http.post(
      Uri.parse(
        'https://calmletics-production.up.railway.app/api/player/logout',
      ),
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
    );

    print("Logout Response: ${response.statusCode} - ${response.body}");

    if (response.statusCode == 200) {
      final responseBody = response.body;
      if (responseBody.contains("User successfully logged out")) {
        print("User successfully logged out");
        await prefs.remove("user_token"); // Clear token on logout
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginPage()),
        );
      } else {
        print("Unexpected response: $responseBody");
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Logout response unexpected. Please try again."),
          ),
        );
      }
    } else {
      print("Error logging out: ${response.body}");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to log out. Please try again.")),
      );
    }
  }

  Future<void> _logoutcom() async {
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("user_token");

    final response = await http.post(
      Uri.parse('https://calmletics-production.up.railway.app/api/logoutcom'),
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
    );

    print("Logout Response: ${response.statusCode} - ${response.body}");

    if (response.statusCode == 200) {
      final responseBody = response.body;
      if (responseBody.contains("User successfully logged out")) {
        print("User successfully logged out");
        await prefs.remove("user_token"); // Clear token on logout
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginPage()),
        );
      } else {
        print("Unexpected response: $responseBody");
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Logout response unexpected. Please try again."),
          ),
        );
      }
    } else {
      print("Error logging out: ${response.body}");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to log out. Please try again.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: bgcolor),
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : userData == null
              ? const Center(child: Text("Error fetching user data"))
              : Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      profileImage == null || profileImage!.isEmpty
                          ? const CircularProgressIndicator()
                          : CircleAvatar(
                            radius: 32,
                            backgroundImage: AssetImage(profileImage!),
                            onBackgroundImageError:
                                (_, __) => setState(() {
                                  profileImage =
                                      null; // Handle broken image links
                                }),
                          ),
                      const SizedBox(height: 10),
                      Text(
                        userData!['name'],
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        userData!['email'],
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 20),
                      ListTile(
                        leading: const Icon(Icons.edit),
                        title: const Text("تعديل البيانات"),
                        trailing: const Icon(Icons.arrow_forward_ios, size: 18),
                        onTap: () async {
                          final updated = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const UserProfileEdit(),
                            ),
                          );

                          if (updated == true) {
                            _fetchUserData();
                          }
                        },
                      ),
                      ListTile(
                        leading: const Icon(Icons.lock),
                        title: const Text("تغيير كلمة المرور"),
                        trailing: const Icon(Icons.arrow_forward_ios, size: 18),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) => const ChangePasswordScreen(),
                            ),
                          );
                        },
                      ),
                      ListTile(
                        leading: const Icon(
                          Icons.logout,
                          color: Color(0xffDA2B52),
                        ),
                        trailing: const Icon(
                          Icons.arrow_forward_ios,
                          color: Color(0xffDA2B52),
                          size: 18,
                        ),
                        title: const Text(
                          "تسجيل الخروج",
                          style: TextStyle(color: Color(0xffDA2B52)),
                        ),
                        onTap: _logout,
                      ),
                      const Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(top: 16, left: 16),
                            child: Text(
                              "مجتمعك",
                              style: TextStyle(
                                fontSize: 22,
                                color: textcolor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      ListTile(
                        leading: const Icon(
                          Icons.logout,
                          color: Color(0xffDA2B52),
                        ),
                        title: const Text(
                          "تسجيل الخروج",
                          style: TextStyle(color: Color(0xffDA2B52)),
                        ),
                        trailing: const Icon(
                          Icons.arrow_forward_ios,
                          color: Color(0xffDA2B52),
                          size: 18,
                        ),
                        onTap: _logoutcom,
                      ),
                    ],
                  ),
                ),
              ),
    );
  }
}

class UserProfileEdit extends StatefulWidget {
  const UserProfileEdit({super.key});

  @override
  _UserProfileEditState createState() => _UserProfileEditState();
}

class _UserProfileEditState extends State<UserProfileEdit> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  String selectedCountry = "مصر";
  String? profileImage; // Store profile image URL
  bool isLoading = true;
  final Api api = Api();

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    final userData = await api.fetchUserData();

    if (userData != null) {
      setState(() {
        nameController.text = userData['name'];
        emailController.text = userData['email'];
        selectedCountry = userData['flag'] ?? "Egypt";
        profileImage = userData['image']; // Store image URL
        isLoading = false;
      });
    }
  }

  Future<void> _updateUserProfile() async {
    bool success = await api.updateUserProfile(
      nameController.text,
      emailController.text,
      selectedCountry,
    );

    if (success) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Profile Updated!")));
      Navigator.pop(context, true);
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Error updating profile")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: bgcolor),
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      profileImage == null || profileImage!.isEmpty
                          ? const CircularProgressIndicator()
                          : CircleAvatar(
                            radius: 32,
                            backgroundImage: AssetImage(profileImage!),
                            onBackgroundImageError:
                                (_, __) => setState(() {
                                  profileImage =
                                      null; // Handle broken image links
                                }),
                          ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: nameController,
                        decoration: const InputDecoration(
                          labelText: "الاسم",
                          prefixIcon: Icon(Icons.person),
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: emailController,
                        decoration: const InputDecoration(
                          labelText: "الايميل",
                          prefixIcon: Icon(Icons.email),
                        ),
                      ),
                      const SizedBox(height: 10),
                      DropdownButtonFormField<String>(
                        value: selectedCountry,
                        decoration: const InputDecoration(
                          labelText: "البلد",
                          prefixIcon: Icon(Icons.flag),
                        ),
                        items:
                            ["Egypt", "USA", "Canada", "UK", "Germany"]
                                .map(
                                  (country) => DropdownMenuItem(
                                    value: country,
                                    child: Text(country),
                                  ),
                                )
                                .toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedCountry = value!;
                          });
                        },
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: _updateUserProfile,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: kPrimaryColor,
                          minimumSize: const Size(double.infinity, 50),
                        ),
                        child: const Text(
                          "حفظ",
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
    );
  }
}

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final TextEditingController currentPasswordController =
      TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  final Api api = Api();

  Future<void> _changePassword() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      isLoading = true;
    });

    bool success = await api.changePassword(
      currentPasswordController.text,
      newPasswordController.text,
      confirmPasswordController.text,
    );

    setState(() {
      isLoading = false;
    });

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Password updated successfully!")),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Error updating password")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(backgroundColor: Colors.white),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const Text(
                "غير كلمة المرور",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: textcolor,
                ),
              ),
              const Text(
                "يجب أن تكون كلمة المرور مكوّنة من 8 أحرف على الأقل، وتحتوي على مزيج من الحروف والأرقام.",
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: currentPasswordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: "كلمة المرور الحالية",
                  prefixIcon: Icon(Icons.lock),
                ),
              ),
              const SizedBox(height: 5),
              TextFormField(
                controller: newPasswordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: "كلمة المرور الجديدة",
                  prefixIcon: Icon(Icons.lock),
                ),
              ),
              const SizedBox(height: 5),
              TextFormField(
                controller: confirmPasswordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: "تأكيد كلمة المرور الجديدة",
                  prefixIcon: Icon(Icons.lock),
                ),
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: kPrimaryColor,
                  minimumSize: const Size(double.infinity, 50),
                ),
                onPressed: isLoading ? null : _changePassword,
                child:
                    isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                          "تأكيد",
                          style: TextStyle(color: Colors.white, fontSize: 22),
                        ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
