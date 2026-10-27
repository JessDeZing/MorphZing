import 'dart:math';

import 'package:flutter/material.dart';
import 'package:morphzing/data/models/home_page/home_page_images.dart';

/// Text quote on a random MorphZing brand gradient.
class QuoteCard extends StatefulWidget {
  final Quote quote;

  const QuoteCard({Key? key, required this.quote}) : super(key: key);

  @override
  State<QuoteCard> createState() => _QuoteCardState();
}

class _QuoteCardState extends State<QuoteCard> {
  static const _gradients = <List<Color>>[
    [Color(0xFF070C1A), Color(0xFF4F6BED)],
    [Color(0xFF4F6BED), Color(0xFF8B6FE8)],
    [Color(0xFF8B6FE8), Color(0xFFE88FC7)],
    [Color(0xFF070C1A), Color(0xFF8B6FE8)],
    [Color(0xFF070C1A), Color(0xFFE88FC7)],
  ];

  late final List<Color> _colors =
      _gradients[Random().nextInt(_gradients.length)];

  String get _text => widget.quote
      .displayText()
      .replaceAll(RegExp('^["\u201C\u201D\'\u2018\u2019\\s]+|["\u201C\u201D\'\u2018\u2019\\s]+\$'), '');

  double _fontSize(int length) {
    if (length <= 70) return 22;
    if (length <= 140) return 18;
    if (length <= 220) return 15;
    return 13;
  }

  @override
  Widget build(BuildContext context) {
    final text = _text;
    final author = widget.quote.author?.trim() ?? '';
    return Container(
      width: double.infinity,
      clipBehavior: Clip.antiAlias,
      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: _colors,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            '\u201C',
            style: TextStyle(
              fontFamily: 'serif',
              fontSize: 52,
              height: 0.8,
              color: Color(0x66FFFFFF),
            ),
          ),
          const SizedBox(height: 4),
          Flexible(
            child: Text(
              text,
              textAlign: TextAlign.center,
              maxLines: 8,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontFamily: 'SF Pro Display',
                fontSize: _fontSize(text.length),
                fontWeight: FontWeight.w700,
                height: 1.3,
                color: Colors.white,
                shadows: const [
                  Shadow(blurRadius: 6, color: Color(0x55000000)),
                ],
              ),
            ),
          ),
          if (author.isNotEmpty) ...[
            const SizedBox(height: 10),
            Text(
              '\u2014 ' + author,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontFamily: 'SF Pro Display',
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: Color(0xDDFFFFFF),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
