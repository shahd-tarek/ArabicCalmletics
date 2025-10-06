// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:calmleticsarab/constant.dart';
import 'package:calmleticsarab/calm_routine/quick_t3.dart';

class BoxBreathingScreen extends StatefulWidget {
  final int pageIndex;
  final int totalPages;
  const BoxBreathingScreen({
    super.key,
    required this.pageIndex,
    required this.totalPages,
  });

  @override
  State<BoxBreathingScreen> createState() => _BoxBreathingScreenState();
}

class _BoxBreathingScreenState extends State<BoxBreathingScreen>
    with TickerProviderStateMixin {
  late AnimationController _dotController;
  late Animation<Offset> _dotAnimation;

  final List<String> phases = ['استنشق', 'احبس', 'اخرج النفس', 'احبس'];
  int currentPhase = 0;
  int loopCount = 0;
  final int maxLoops = 3;
  bool isStarted = false;

  static const double boxSize = 200;
  static const double dotSize = 12;
  static const double maxOffset = boxSize - dotSize;

  @override
  void initState() {
    super.initState();
    _setupAnimation();
  }

  void _setupAnimation() {
    _dotController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _nextPhase();
        }
      });

    _updateDotAnimation();
  }

  void _updateDotAnimation() {
    final animations = [
      Tween<Offset>(
        begin: const Offset(0, 0),
        end: const Offset(maxOffset, 0),
      ), // top
      Tween<Offset>(
        begin: const Offset(maxOffset, 0),
        end: const Offset(maxOffset, maxOffset),
      ), // right
      Tween<Offset>(
        begin: const Offset(maxOffset, maxOffset),
        end: const Offset(0, maxOffset),
      ), // bottom
      Tween<Offset>(
        begin: const Offset(0, maxOffset),
        end: const Offset(0, 0),
      ), // left
    ];
    _dotAnimation = animations[currentPhase].animate(
      CurvedAnimation(parent: _dotController, curve: Curves.linear),
    );
  }

  void _startBreathing() {
    setState(() {
      isStarted = true;
      currentPhase = 0;
      loopCount = 0;
    });
    _updateDotAnimation();
    _dotController.forward(from: 0);
  }

  void _nextPhase() {
    setState(() {
      currentPhase = (currentPhase + 1) % phases.length;
      if (currentPhase == 0) {
        loopCount++;
      }
    });

    if (loopCount < maxLoops) {
      _updateDotAnimation();
      _dotController.forward(from: 0);
    } else {
      _dotController.stop();
      setState(() {
        isStarted = false;
      });
    }
  }

  @override
  void dispose() {
    _dotController.dispose();
    super.dispose();
  }

  Widget _buildDotAnimationBox() {
    return AnimatedBuilder(
      animation: _dotAnimation,
      builder: (context, child) {
        final dx = _dotAnimation.value.dx;
        final dy = _dotAnimation.value.dy;

        return Stack(
          children: [
            Container(
              width: boxSize,
              height: boxSize,
              decoration: BoxDecoration(
                color: const Color(0xffFFFCF9),
                borderRadius: BorderRadius.circular(16),
              ),
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    phases[currentPhase],
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    "4s",
                    style: TextStyle(fontSize: 20, color: Colors.grey),
                  ),
                ],
              ),
            ),
            Positioned(
              left: dx,
              top: dy,
              child: Container(
                width: dotSize,
                height: dotSize,
                decoration: const BoxDecoration(
                  color: kPrimaryColor,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 243, 240, 240),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
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
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    // Progress bar
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
                    const SizedBox(height: 8),
                    const Text(
                      "خد نفس عميق واسترخِ.",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Breathing Box
                    Container(
                      height: 400,
                      margin: const EdgeInsets.symmetric(horizontal: 24),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: kPrimaryColor,
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Column(
                        children: [
                          const Row(
                            children: [
                              Icon(Icons.refresh, color: Colors.white),
                              SizedBox(width: 6),
                              Text(
                                "3 مرات",
                                style: TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                          const Spacer(),
                          Center(child: _buildDotAnimationBox()),
                          const Spacer(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: phases
                                .map(
                                  (p) => Column(
                                    children: [
                                      Text(
                                        p,
                                        style: const TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                      const Text(
                                        "4s",
                                        style: TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                      const SizedBox(height: 30),
                                    ],
                                  ),
                                )
                                .toList(),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    const Spacer(),
                  ],
                ),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            color: bgcolor,
            child: Center(
              child: SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: (isStarted && loopCount < maxLoops)
                      ? null
                      : () {
                          if (loopCount == maxLoops) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => QuickTaskThree(
                                  pageIndex: widget.pageIndex + 1,
                                  totalPages: widget.totalPages,
                                ),
                              ),
                            );
                          } else {
                            _startBreathing();
                          }
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kPrimaryColor,
                    disabledBackgroundColor: Colors.grey.withOpacity(0.5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Text(
                    loopCount == maxLoops ? "التالي" : "ابدأ الآن",
                    style: const TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
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
