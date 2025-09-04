import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class TextViewerWidget extends StatelessWidget {
  final String url;

  const TextViewerWidget({super.key, required this.url});

  Future<String> fetchTextContent() async {
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      return response.body; // النص المرسل من الرابط
    } else {
      throw Exception('Failed to load text');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: fetchTextContent(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (snapshot.hasData) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Text(
              snapshot.data!,
              style: const TextStyle(fontSize: 18,fontWeight: FontWeight.w500),
            ),
          );
        } else {
          return const Center(child: Text('No data available'));
        }
      },
    );
  }
}