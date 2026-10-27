import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:morphzing/localization/translation_keys.dart';
import 'package:morphzing/presentation/pages/screens/entry/intro/intro_controller.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';

/// First-launch welcome: 2 swipeable pages over Zing Photography photos.
class FirstIntroScreen extends StatefulWidget {
  const FirstIntroScreen({Key? key}) : super(key: key);

  @override
  State<FirstIntroScreen> createState() => _FirstIntroScreenState();
}

class _FirstIntroScreenState extends State<FirstIntroScreen> {
  final _page = PageController();
  final _intro = Get.put(IntroController());
  int _index = 0;

  static const List<Color> _rainbow = [
    Colors.red, Colors.pink, Colors.purple, Colors.deepPurple, Colors.indigo, Colors.blue,
    Colors.lightBlue, Colors.cyan, Colors.teal, Colors.green, Colors.lightGreen, Colors.lime,
    Colors.yellow, Colors.amber, Colors.orange, Colors.deepOrange,
  ];
  static const _white = TextStyle(fontFamily: 'SF Pro Display', color: Colors.white);

  @override
  void dispose() {
    _page.dispose();
    super.dispose();
  }

  void _next() {
    if (_index == 0) {
      _page.nextPage(duration: const Duration(milliseconds: 350), curve: Curves.easeOut);
    } else {
      _intro.onPressedGetStarted();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: const Color(0xFF0B1026),
        body: Stack(
          fit: StackFit.expand,
          children: [
            PageView(
              controller: _page,
              onPageChanged: (i) => setState(() => _index = i),
              children: [_welcomePage(), _featuresPage()],
            ),
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 4, 20, 20),
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.centerRight,
                      child: AnimatedOpacity(
                        opacity: _index == 0 ? 1 : 0,
                        duration: const Duration(milliseconds: 200),
                        child: TextButton(
                          onPressed: _index == 0 ? _intro.onPressedGetStarted : null,
                          child: Text(introSkip.tr,
                              style: _white.copyWith(fontSize: 15, color: Colors.white70)),
                        ),
                      ),
                    ),
                    const Spacer(),
                    _dots(),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: const Color(0xFF050A41),
                          elevation: 0,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        ),
                        onPressed: _next,
                        child: Text(_index == 0 ? next.tr : getStarted.tr,
                            style: const TextStyle(
                                fontFamily: 'SF Pro Display', fontSize: 17, fontWeight: FontWeight.w600)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _photo(String asset, List<Color> colors, List<double> stops) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Image.asset(asset, fit: BoxFit.cover),
        DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: colors,
              stops: stops,
            ),
          ),
        ),
      ],
    );
  }

  Widget _welcomePage() {
    final tag = _white.copyWith(fontSize: 18, fontWeight: FontWeight.w500);
    return Stack(
      fit: StackFit.expand,
      children: [
        _photo('assets/images/intro/intro_sunset.jpg',
            const [Color(0x000B1026), Color(0x990B1026), Color(0xF20B1026)], const [0.35, 0.62, 1.0]),
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(28, 0, 28, 140),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.asset('assets/images/black_mz_logo.png', width: 84, height: 84),
                ),
                const SizedBox(height: 20),
                Text(introWelcome.tr,
                    textAlign: TextAlign.center,
                    style: _white.copyWith(fontSize: 28, fontWeight: FontWeight.w700)),
                const SizedBox(height: 12),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  GradientText('M', style: tag, colors: _rainbow),
                  Text('orph your future', style: tag),
                ]),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Text('into something ama', style: tag),
                  GradientText('Z', style: tag, colors: _rainbow),
                  Text('ing', style: tag),
                ]),
                const SizedBox(height: 14),
                Text(introCalmLine.tr,
                    textAlign: TextAlign.center,
                    style: _white.copyWith(fontSize: 15, color: Colors.white70, height: 1.45)),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _featuresPage() {
    return Stack(
      fit: StackFit.expand,
      children: [
        _photo('assets/images/intro/intro_ocean.jpg',
            const [Color(0x660B1026), Color(0x990B1026), Color(0xE60B1026)], const [0.0, 0.5, 1.0]),
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(22, 56, 22, 140),
            child: Column(
              children: [
                Text(introEverything.tr,
                    textAlign: TextAlign.center,
                    style: _white.copyWith(fontSize: 26, fontWeight: FontWeight.w700)),
                const SizedBox(height: 6),
                Text(introBilingual.tr,
                    textAlign: TextAlign.center,
                    style: _white.copyWith(fontSize: 15, color: Colors.white70)),
                const Spacer(),
                _feature(Icons.check_circle_outline_rounded, const Color(0xFF3B2A6B), homeTodoLabel.tr, homeTodoSub.tr),
                _feature(Icons.menu_book_rounded, const Color(0xFF7A4126), journal.tr, homeJournalSub.tr),
                _feature(Icons.edit_note_rounded, const Color(0xFF1F5A3A), notes.tr, homeNotesSub.tr),
                _feature(Icons.palette_outlined, const Color(0xFF5E1F45), calmCorner.tr, homeCalmSub.tr),
                const SizedBox(height: 6),
                Text(introFreshQuote.tr,
                    textAlign: TextAlign.center,
                    style: _white.copyWith(fontSize: 13, color: Colors.white70)),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _feature(IconData icon, Color tile, String title, String sub) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.14),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white.withOpacity(0.25), width: 0.6),
            ),
            child: Row(
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(color: tile, borderRadius: BorderRadius.circular(12)),
                  child: Icon(icon, color: Colors.white, size: 22),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title, style: _white.copyWith(fontSize: 16, fontWeight: FontWeight.w600)),
                      const SizedBox(height: 2),
                      Text(sub, style: _white.copyWith(fontSize: 13, color: Colors.white70)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _dots() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        2,
        (i) => AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          margin: const EdgeInsets.symmetric(horizontal: 3),
          width: _index == i ? 20 : 7,
          height: 7,
          decoration: BoxDecoration(
            color: _index == i ? Colors.white : Colors.white38,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ),
    );
  }
}
