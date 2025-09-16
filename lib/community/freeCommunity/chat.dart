// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:calmleticsarab/constant.dart';
import 'dart:convert';

import 'package:calmleticsarab/widgets/chat_buble.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  List<Map<String, dynamic>> messages = [];
  int? userId;
  String? userAvatar = "assets/images/default_avatar.png";

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("user_token");
    int? userId = prefs.getInt("user_id");
    print("Loaded user_id: $userId");

    final response = await http.get(
      Uri.parse(
        'https://calmletics-production.up.railway.app/api/player/userInfo',
      ),
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      setState(() {
        userId = data['id'];
        userAvatar =
            data['image'] ??
            "assets/images/Coach 1.png"; //  Assign avatar dynamically
      });

      fetchMessages(); //  Fetch messages after getting user info
    } else {
      print("Failed to fetch user data: ${response.body}");
    }
  }

  Future<void> fetchMessages() async {
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("user_token");
    userId = prefs.getInt("user_id");
    final response = await http.get(
      Uri.parse(
        'https://calmletics-production.up.railway.app/api/player/community/messages',
      ),
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List<dynamic> fetchedMessages = data['messages'];

      setState(() {
        messages =
            fetchedMessages.map((msg) {
              return {
                "user": msg['user']['name'],
                "message": msg['message'],
                "avatar": msg['user']['image'] ?? "assets/images/Coach 1.png",
                "isMe":
                    msg['user']['id'] == userId, // مقارنة مع user_id الحقيقي
              };
            }).toList();
      });
    } else {
      print("Failed to fetch messages: ${response.body}");
    }
  }

  Future<void> sendMessage(String message) async {
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("user_token");
    await prefs.setString("user_token", token!);

    if (message.isEmpty) return;

    final response = await http.post(
      Uri.parse(
        'https://calmletics-production.up.railway.app/api/player/community/message/send',
      ),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: jsonEncode({"message": message}),
    );

    if (response.statusCode == 200) {
      setState(() {
        messages.add({
          "user": "You",
          "message": message,
          "avatar": userAvatar,
          "isMe": true,
        });
      });

      _controller.clear();
      _scrollToBottom();
    } else {
      print("Failed to send message: ${response.body}");
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgcolor,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text("الدعم الفني", style: TextStyle(color: Colors.white)),
        backgroundColor: kPrimaryColor,
        actions: [
          IconButton(
            icon: const Icon(Icons.call, color: Colors.white),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              itemCount: messages.length,
              itemBuilder: (context, index) {
                return ChatBubble(
                  message: messages[index]["message"],
                  username: messages[index]["user"],
                  isMe: messages[index]["isMe"],
                  avatar: messages[index]["avatar"],
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: "اكتب رسالة...",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send, color: Color(0xff6A957A)),
                  onPressed: () {
                    sendMessage(_controller.text);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
