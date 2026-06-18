import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class GroundingGameScreen extends StatefulWidget {
  const GroundingGameScreen({super.key});

  @override
  State<GroundingGameScreen> createState() => _GroundingGameScreenState();
}

class _GroundingGameScreenState extends State<GroundingGameScreen> {
  final List<Map<String, dynamic>> _senses = [
    {'label': 'SEE', 'emoji': '👀', 'count': 5, 'color': const Color(0xFF89b4e8)},
    {'label': 'TOUCH', 'emoji': '✋', 'count': 4, 'color': const Color(0xFFb8a8d8)},
    {'label': 'HEAR', 'emoji': '👂', 'count': 3, 'color': const Color(0xFFd4a0b8)},
    {'label': 'SMELL', 'emoji': '👃', 'count': 2, 'color': const Color(0xFFa8c8a8)},
    {'label': 'TASTE', 'emoji': '👅', 'count': 1, 'color': const Color(0xFF89b4e8)},
  ];

  int _currentStep = 0;
  int _tapped = 0;
  bool _finished = false;

  void _onTap() {
    final needed = _senses[_currentStep]['count'] as int;
    setState(() {
      _tapped++;
      if (_tapped >= needed) {
        HapticFeedback.mediumImpact();
        if (_currentStep < _senses.length - 1) {
          _currentStep++;
          _tapped = 0;
        } else {
          HapticFeedback.heavyImpact();
          _finished = true;
        }
      }
    });
  }

  void _reset() {
    setState(() {
      _currentStep = 0;
      _tapped = 0;
      _finished = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1a1f30),
      appBar: AppBar(
        backgroundColor: const Color(0xFF141828),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Color(0xFFb8a8d8)),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          'Grounding Exercise',
          style: TextStyle(color: Color(0xFFeceaf8), fontSize: 17, fontWeight: FontWeight.w500),
        ),
      ),
      body: _finished ? _buildFinishScreen() : _buildGameScreen(),
    );
  }

  Widget _buildGameScreen() {
    final sense = _senses[_currentStep];
    final needed = sense['count'] as int;
    final remaining = needed - _tapped;
    final color = sense['color'] as Color;
    final progress = (_currentStep + (_tapped / needed)) / _senses.length;

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(2),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: const Color(0xFF252a3a),
              valueColor: AlwaysStoppedAnimation<Color>(color),
              minHeight: 3,
            ),
          ),
          const SizedBox(height: 32),
          Text(
            'STEP ${_currentStep + 1} OF 5',
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: color, letterSpacing: 1.5),
          ),
          const SizedBox(height: 10),
          Text(
            'Find $remaining thing${remaining == 1 ? '' : 's'} you can ${sense['label']} ${sense['emoji']}',
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w500, color: Color(0xFFeceaf8)),
          ),
          const SizedBox(height: 8),
          const Text(
            'Look around. Tap each time you find one.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, color: Color(0xFF6a6a88)),
          ),
          const SizedBox(height: 40),
          GestureDetector(
            onTap: _onTap,
            child: Container(
              width: 160,
              height: 160,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF141828),
                border: Border.all(color: color.withOpacity(0.4), width: 2),
              ),
              child: Center(
                child: Text(
                  '$remaining',
                  style: TextStyle(fontSize: 60, fontWeight: FontWeight.w500, color: color),
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text('tap the circle', style: TextStyle(fontSize: 12, color: color.withOpacity(0.5))),
          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _onTap,
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
                'I found one  ✓',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
            ),
          ),
          const SizedBox(height: 32),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            alignment: WrapAlignment.center,
            children: List.generate(_senses.length, (i) {
              final done = i < _currentStep;
              final active = i == _currentStep;
              final chipColor = _senses[i]['color'] as Color;
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                decoration: BoxDecoration(
                  color: done || active ? chipColor.withOpacity(0.1) : const Color(0xFF141828),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: done || active ? chipColor.withOpacity(0.5) : const Color(0xFF252a3a),
                    width: 0.5,
                  ),
                ),
                child: Text(
                  done ? '${_senses[i]['label']} ✓' : '${_senses[i]['label']} ${_senses[i]['count']}',
                  style: TextStyle(fontSize: 11, color: done || active ? chipColor : const Color(0xFF6a6a88)),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildFinishScreen() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('🌿', style: TextStyle(fontSize: 64)),
          const SizedBox(height: 20),
          const Text('You did it!',
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.w500, color: Color(0xFFeceaf8))),
          const SizedBox(height: 12),
          const Text(
            'You are present. You are grounded. Take a slow breath.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 15, color: Color(0xFF8a8aaa), height: 1.7),
          ),
          const SizedBox(height: 32),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF141828),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFF252a3a), width: 0.5),
            ),
            child: Column(
              children: [
                const Text('ALL 5 SENSES COMPLETE',
                    style: TextStyle(fontSize: 11, color: Color(0xFFa8c8a8), letterSpacing: 1.2)),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  alignment: WrapAlignment.center,
                  children: _senses.map((s) {
                    final color = s['color'] as Color;
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: color.withOpacity(0.4), width: 0.5),
                      ),
                      child: Text('${s['label']} ✓', style: TextStyle(fontSize: 11, color: color)),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => Get.back(),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF89b4e8).withOpacity(0.15),
                foregroundColor: const Color(0xFF89b4e8),
                elevation: 0,
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                  side: const BorderSide(color: Color(0xFF89b4e8), width: 0.5),
                ),
              ),
              child: const Text('Back to Calm Corner', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
            ),
          ),
          const SizedBox(height: 16),
          GestureDetector(
            onTap: _reset,
            child: const Text('Play again', style: TextStyle(fontSize: 13, color: Color(0xFF4a4a62))),
          ),
        ],
      ),
    );
  }
}
