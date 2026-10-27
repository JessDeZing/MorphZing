import 'calm_colors.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vibration/vibration.dart';
import 'package:morphzing/localization/translation_keys.dart' as translation;

class BreathingScreen extends StatefulWidget {
  const BreathingScreen({super.key});

  @override
  State<BreathingScreen> createState() => _BreathingScreenState();
}

class _BreathingScreenState extends State<BreathingScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnim;

  final List<Map<String, dynamic>> _phases = [
    {'label': 'Inhale', 'seconds': 4, 'scale': 1.0},
    {'label': 'Hold', 'seconds': 4, 'scale': 1.0},
    {'label': 'Exhale', 'seconds': 4, 'scale': 0.0},
    {'label': 'Hold', 'seconds': 4, 'scale': 0.0},
  ];

  String _phaseLabel(String key) {
    switch (key) {
      case 'Inhale': return translation.phaseInhale.tr;
      case 'Hold': return translation.phaseHold.tr;
      case 'Exhale': return translation.phaseExhale.tr;
      default: return key;
    }
  }

  int _phaseIndex = 0;
  int _countdown = 4;
  bool _running = false;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
    _scaleAnim = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _timer?.cancel();
    super.dispose();
  }

  void _start() {
    setState(() {
      _running = true;
      _phaseIndex = 0;
      _countdown = 4;
    });
    _runPhase();
  }

  void _stop() {
    _timer?.cancel();
    _controller.stop();
    setState(() {
      _running = false;
      _phaseIndex = 0;
      _countdown = 4;
    });
  }

  void _runPhase() {
    final phase = _phases[_phaseIndex];
    final seconds = phase['seconds'] as int;
    final targetScale = phase['scale'] as double;

    setState(() => _countdown = seconds);

    if (_phaseIndex == 0) {
      _controller.duration = Duration(seconds: seconds);
      _controller.forward(from: 0);
    } else if (_phaseIndex == 2) {
      _controller.duration = Duration(seconds: seconds);
      _controller.reverse(from: 1);
    }

    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) return;
      setState(() => _countdown--);
      if (_countdown <= 0) {
        t.cancel();
        if (!_running) return;
        Vibration.vibrate(duration: 50);
          setState(() => _phaseIndex = (_phaseIndex + 1) % _phases.length);
        _runPhase();
      }
    });
  }

  Color get _phaseColor {
    switch (_phaseIndex) {
      case 0: return CalmColors.blue;
      case 1: return CalmColors.lavender;
      case 2: return CalmColors.rose;
      case 3: return CalmColors.sage;
      default: return CalmColors.blue;
    }
  }

  @override
  Widget build(BuildContext context) {
    final phase = _phases[_phaseIndex];
    final color = _phaseColor;

    return Scaffold(
      backgroundColor: CalmColors.bg,
      appBar: AppBar(
        backgroundColor: CalmColors.surface,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: CalmColors.lavender),
          onPressed: () {
            _stop();
            Get.back();
          },
        ),
        title: Text(
            translation.breathingExercise.tr,
          style: TextStyle(color: CalmColors.title, fontSize: 17, fontWeight: FontWeight.w500),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              translation.boxBreathing.tr,
              style: TextStyle(fontSize: 13, color: color, letterSpacing: 1.5),
            ),
            const SizedBox(height: 8),
            Text(
                translation.breathingCount.tr,
              style: TextStyle(fontSize: 13, color: CalmColors.dim, letterSpacing: 2),
            ),
            const SizedBox(height: 60),
            AnimatedBuilder(
              animation: _scaleAnim,
              builder: (context, child) {
                final size = 160.0 + (_scaleAnim.value * 80);
                return Container(
                  width: size,
                  height: size,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: color.withOpacity(0.08),
                    border: Border.all(color: color.withOpacity(0.4), width: 2),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          _running ? _phaseLabel(phase['label'] as String) : translation.breathingReady.tr,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                            color: _running ? color : CalmColors.dim,
                          ),
                        ),
                        if (_running) ...[
                          const SizedBox(height: 6),
                          Text(
                            '$_countdown',
                            style: TextStyle(fontSize: 36, fontWeight: FontWeight.w300, color: color),
                          ),
                        ],
                      ],
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 60),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _running ? _stop : _start,
                style: ElevatedButton.styleFrom(
                  backgroundColor: color.withOpacity(0.15),
                  foregroundColor: color,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                    side: BorderSide(color: color.withOpacity(0.4), width: 0.5),
                  ),
                ),
                child: Text(
                  _running ? translation.stop.tr : translation.start.tr,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
            translation.breathingFooter.tr,
              style: TextStyle(fontSize: 12, color: CalmColors.dim, letterSpacing: 1),
            ),
          ],
        ),
      ),
    );
  }
}
