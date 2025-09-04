import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:just_audio/just_audio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:calmleticsarab/constant.dart';
import 'package:calmleticsarab/views/main_screen.dart';

class AudioPlayerScreen extends StatefulWidget {
  final int pageIndex;
  final int totalPages;

  const AudioPlayerScreen({
    super.key,
    required this.pageIndex,
    required this.totalPages,
  });

  @override
  State<AudioPlayerScreen> createState() => _AudioPlayerScreenState();
}

class _AudioPlayerScreenState extends State<AudioPlayerScreen> {
  late AudioPlayer _player;
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;
  bool isPlaying = false;
  bool isLoading = true;
  String? audioUrl;
  bool isAudioFinished = false;

  @override
  void initState() {
    super.initState();
    _player = AudioPlayer();
    _fetchAudioUrl();
  }

  Future<void> _fetchAudioUrl() async {
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("user_token");
    print("Token: $token");
    final response = await http.post(
      Uri.parse(
        "https://calmletics-production.up.railway.app/api/file/upload/rec3 ",
      ),
      headers: {"Authorization": "Bearer $token", "Accept": "application/json"},
    );
    print("Response status: ${response.statusCode}");
    print("Response body: ${response.body}");
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        audioUrl = data['rec3'];
        isLoading = false;
      });
      print("Audio URL: $audioUrl");
      if (audioUrl == null) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Failed to load audio.')));
      } else {
        _loadAudio();
      }
    } else {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Error loading audio URL.')));
    }
  }

  Future<void> _loadAudio() async {
    if (audioUrl == null) return;
    await _player.setUrl(audioUrl!);
    _player.durationStream.listen((d) {
      setState(() {
        _duration = d ?? Duration.zero;
      });
    });
    _player.positionStream.listen((p) {
      setState(() {
        _position = p;
      });
    });
    _player.playerStateStream.listen((state) {
      setState(() {
        isPlaying = state.playing;
        if (state.processingState == ProcessingState.completed) {
          isAudioFinished = true;
        }
      });
    });
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final double padding = size.width * 0.04; // 4% من العرض
    final double fontSizeSmall = size.width * 0.038;
    final double fontSizeMedium = size.width * 0.042;
    final double fontSizeLarge = size.width * 0.05;
    final double imageHeight = size.height * 0.4; // 40% من الارتفاع
    final double iconButtonSize = size.width * 0.15; // 15% من العرض

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
                borderRadius: BorderRadius.circular(30),
              ),
              child: Padding(
                padding: EdgeInsets.all(padding),
                child: Column(
                  children: [
                    // ✅ شريط التقدم (تم الحفاظ عليه كما هو - بدون تغيير)
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
                    SizedBox(height: padding * 1.2),

                    // النص
                    Text(
                      "خذ لحظة لتتخيل نفسك تحقق النجاح.",
                      style: TextStyle(
                        fontSize: fontSizeLarge,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: padding * 1.2),

                    // الصورة
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.asset(
                        'assets/images/audio.png',
                        height: imageHeight, // ارتفاع نسبي
                        fit: BoxFit.cover,
                      ),
                    ),
                    SizedBox(height: padding * 1.2),

                    Text(
                      "تخيّل النجاح",
                      style: TextStyle(
                        fontSize: fontSizeMedium,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: padding * 0.6),

                    // شريط التقدم (Progress)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _formatDuration(_position),
                          style: TextStyle(fontSize: fontSizeSmall),
                        ),
                        Expanded(
                          child: Slider(
                            min: 0,
                            max: _duration.inSeconds.toDouble(),
                            value:
                                _position.inSeconds
                                    .clamp(0, _duration.inSeconds)
                                    .toDouble(),
                            onChanged: (value) {
                              _player.seek(Duration(seconds: value.toInt()));
                            },
                            activeColor: kPrimaryColor,
                            inactiveColor: Colors.grey[300],
                          ),
                        ),
                        Text(
                          _formatDuration(_duration),
                          style: TextStyle(fontSize: fontSizeSmall),
                        ),
                      ],
                    ),

                    // زر التشغيل
                    IconButton(
                      iconSize: iconButtonSize,
                      icon: Icon(
                        isPlaying
                            ? Icons.pause_circle_filled
                            : Icons.play_circle_fill,
                        color: kPrimaryColor,
                      ),
                      onPressed: () {
                        if (isPlaying) {
                          _player.pause();
                        } else {
                          _player.play();
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),

          // زر Done
          Container(
            padding: EdgeInsets.all(padding),
            color: bgcolor,
            child: Center(
              child: SizedBox(
                width: double.infinity,
                height: size.height * 0.07,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        isAudioFinished ? kPrimaryColor : Colors.grey,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  onPressed:
                      isAudioFinished
                          ? () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const MainScreen(),
                              ),
                            );
                          }
                          : null,
                  child: Text(
                    "تم الاستعداد",
                    style: TextStyle(
                      fontSize: fontSizeMedium,
                      fontWeight: FontWeight.bold,
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

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return "$minutes:$seconds";
  }
}

// Widget منفصل للتحكم في الصوت (إذا تم استخدامه)
class AudioPlayerWidget extends StatefulWidget {
  final String url;

  const AudioPlayerWidget({super.key, required this.url});

  @override
  _AudioPlayerWidgetState createState() => _AudioPlayerWidgetState();
}

class _AudioPlayerWidgetState extends State<AudioPlayerWidget> {
  late AudioPlayer _audioPlayer;
  bool isPlaying = false;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow, size: 32),
      onPressed: () async {
        if (isPlaying) {
          await _audioPlayer.pause();
        } else {
          await _audioPlayer.setUrl(widget.url);
          _audioPlayer.play();
        }
        setState(() {
          isPlaying = !isPlaying;
        });
      },
    );
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }
}
