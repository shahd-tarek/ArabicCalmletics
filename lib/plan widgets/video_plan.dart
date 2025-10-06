// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:calmleticsarab/constant.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerWidget extends StatefulWidget {
  final String url;

  const VideoPlayerWidget({super.key, required this.url});

  @override
  State<VideoPlayerWidget> createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late VideoPlayerController _controller;
  bool isPlaying = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.url)
      ..initialize().then((_) {
        setState(() {});
        _controller.addListener(() {
          setState(() {
            isPlaying = _controller.value.isPlaying;
          });
        });
      });
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return "$minutes:$seconds";
  }

  @override
  Widget build(BuildContext context) {
    if (!_controller.value.isInitialized) {
      return const Center(child: CircularProgressIndicator());
    }

    final duration = _controller.value.duration;
    final position = _controller.value.position;

    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AspectRatio(
            aspectRatio: _controller.value.aspectRatio,
            child: VideoPlayer(_controller),
          ),
          const SizedBox(height: 20),

          // Progress bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                Text(_formatDuration(position)),
                Expanded(
                  child: Slider(
                    min: 0,
                    max: duration.inSeconds.toDouble(),
                    value: position.inSeconds
                        .clamp(0, duration.inSeconds)
                        .toDouble(),
                    onChanged: (value) {
                      _controller.seekTo(Duration(seconds: value.toInt()));
                    },
                    activeColor: kPrimaryColor,
                    inactiveColor: Colors.grey[300],
                  ),
                ),
                Text(_formatDuration(duration)),
              ],
            ),
          ),

          // Play/Pause button
          IconButton(
            iconSize: 50,
            icon: Icon(
              isPlaying ? Icons.pause_circle_filled : Icons.play_circle_fill,
              color: kPrimaryColor,
            ),
            onPressed: () {
              setState(() {
                isPlaying ? _controller.pause() : _controller.play();
              });
            },
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
