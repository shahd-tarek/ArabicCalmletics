// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'dart:async';
import 'package:calmleticsarab/constant.dart';
import 'package:calmleticsarab/calm_routine/audio_screen.dart';

class AudioInPlace extends StatefulWidget {
  final String imagePath;
  final String audioUrl;
  final int pageIndex;
  final int totalPages;

  const AudioInPlace({
    super.key,
    required this.imagePath,
    required this.audioUrl,
    required this.pageIndex,
    required this.totalPages,
  });

  @override
  State<AudioInPlace> createState() => _AudioInPlaceState();
}

class _AudioInPlaceState extends State<AudioInPlace>
    with SingleTickerProviderStateMixin {
  Duration remainingTime = const Duration(minutes: 1);
  Timer? timer;
  bool isButtonEnabled = false;
  late AudioPlayer _audioPlayer;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    startAudio();
    startCountdown();
  }

  Future<void> startAudio() async {
    try {
      await _audioPlayer.setUrl(widget.audioUrl);
      _audioPlayer.play();
    } catch (e) {
      print('Error loading audio: $e');
    }
  }

  void startCountdown() {
    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (remainingTime.inSeconds > 0) {
        setState(() {
          remainingTime -= const Duration(seconds: 1);
        });
      } else {
        timer?.cancel();
        _audioPlayer.stop();
        setState(() {
          isButtonEnabled = true;
        });
      }
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    _audioPlayer.dispose();
    super.dispose();
  }

  String formatTime(Duration d) {
    return "${d.inMinutes}:${(d.inSeconds % 60).toString().padLeft(2, '0')}";
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final double padding = size.width * 0.04; // 4% من العرض
    final double fontSizeMedium = size.width * 0.042;
    final double fontSizeLarge = size.width * 0.05;
    final double timerContainerSize = size.width * 0.45; // نسبي للعرض
    final double timerFontSize = size.width * 0.1; // يتناسب مع الشاشة

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 243, 240, 240),
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
            size: size.width * 0.06,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: const Color.fromARGB(255, 243, 240, 240),
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: bgcolor,
                borderRadius: BorderRadius.circular(size.width * 0.08),
              ),
              child: Padding(
                padding: EdgeInsets.all(padding),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: SizedBox(
                            height: 20,
                            width: 250,
                            child: LinearProgressIndicator(
                              value: (widget.pageIndex + 1) / widget.totalPages,
                              backgroundColor: Colors.grey[300],
                              valueColor: const AlwaysStoppedAnimation<Color>(
                                kPrimaryColor,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          '${widget.pageIndex + 1}/${widget.totalPages}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: kPrimaryColor,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: padding * 0.5),
                    Text(
                      'صفّي ذهنك لدقيقة.',
                      style: TextStyle(
                        fontSize: fontSizeLarge,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: padding * 0.5),
                    Text(
                      'لو محتاج تهدى بسرعة وتفصل من كتر التفكير، جرّب التمرين ده لمدة دقيقتين بس.',
                      style: TextStyle(
                        fontSize: fontSizeMedium,
                        color: Colors.grey,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: padding * 1.5),

                    // حاوية الصورة مع التايمر
                    Container(
                      width: double.infinity,
                      height: size.height * 0.5, // ارتفاع نسبي
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(widget.imagePath),
                          fit: BoxFit.cover,
                        ),
                        borderRadius: BorderRadius.circular(32),
                      ),
                      child: Center(
                        child: Container(
                          width: timerContainerSize,
                          height: timerContainerSize,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              formatTime(remainingTime),
                              style: TextStyle(
                                fontSize: timerFontSize,
                                color: const Color(0xFF56805C),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // زر Next
          Container(
            padding: EdgeInsets.all(padding),
            color: bgcolor,
            child: Center(
              child: SizedBox(
                width: double.infinity,
                height: size.height * 0.07,
                child: ElevatedButton(
                  onPressed:
                      isButtonEnabled
                          ? () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) => AudioPlayerScreen(
                                      pageIndex: widget.pageIndex + 1,
                                      totalPages: widget.totalPages,
                                    ),
                              ),
                            );
                          }
                          : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kPrimaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'التالي',
                    style: TextStyle(
                      fontSize: fontSizeMedium,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
