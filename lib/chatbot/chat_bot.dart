import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:calmleticsarab/coach/widget/chat_buble.dart';
import 'package:calmleticsarab/constant.dart';

class ChatBot extends StatefulWidget {
  const ChatBot({super.key});

  @override
  State<ChatBot> createState() => _ChatBotState();
}

class _ChatBotState extends State<ChatBot> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  List<Map<String, dynamic>> messages = [];
  int? userId;
  String? userAvatar = "assets/images/avatar0.png"; // Default user avatar

  @override
  void initState() {
    super.initState();
  }

  /// Send message to chatbot API
  Future<void> sendMessage(String message) async {
    if (message.isEmpty) return;

    final userMessage = {
      "message": message,
      "user": "You",
      "isMe": true,
      "avatar": userAvatar,
    };

    setState(() {
      messages.add(userMessage);
      _controller.clear();
    });

    _scrollToBottom();

    try {
      final response = await http.post(
        Uri.parse(
          'http://10.0.2.2:8000/chat',
        ), // Make sure your API endpoint is correct
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"prompt": message}), // ✅ Correct key used here
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final botReply = data['response'] ?? "Sorry, I didn't understand that.";

        final botMessage = {
          "message": botReply,
          "user": "Support Bot",
          "isMe": false,
          "avatar": "assets/images/robot.png",
        };

        setState(() {
          messages.add(botMessage);
        });

        _scrollToBottom();
      } else {
        _showError("Error ${response.statusCode}: Could not get a response.");
      }
    } catch (e) {
      _showError("Failed to connect to chatbot API.");
    }
  }

  /// Show error message if API fails
  void _showError(String message) {
    final errorMsg = {
      "message": message,
      "user": "System",
      "isMe": false,
      "avatar": "assets/images/Ellipse 2.png",
    };

    setState(() {
      messages.add(errorMsg);
    });

    _scrollToBottom();
  }

  /// Auto scroll to bottom
  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Chat with Support Bot",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: kPrimaryColor,
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
                    onSubmitted: (_) => sendMessage(_controller.text),
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
