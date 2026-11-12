import 'package:flutter/material.dart';

/// Profile photo in a circle. With no photo (empty, "null" or a broken link)
/// it shows the first letter of the name on the MorphZing rainbow gradient.
/// Used everywhere the user's photo appears, so the look is changed here only.
class ProfileAvatar extends StatelessWidget {
  final String? imageUrl;
  final String name;
  final double size;

  const ProfileAvatar({super.key, this.imageUrl, this.name = '', this.size = 40});

  static const List<Color> _gradient = [
    Color(0xFF8B6FE8),
    Color(0xFFE88FC7),
    Color(0xFF86EFAC),
  ];

  Widget _initial() {
    final trimmed = name.trim();
    final letter = trimmed.isEmpty ? '' : trimmed.characters.first.toUpperCase();
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: _gradient,
        ),
      ),
      child: letter.isEmpty
          ? Icon(Icons.person, color: Colors.white, size: size * 0.6)
          : Text(
              letter,
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'SF Pro Display',
                fontWeight: FontWeight.w700,
                fontSize: size * 0.45,
              ),
            ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final url = (imageUrl ?? '').trim();
    if (url.isEmpty || url == 'null') return _initial();
    return ClipOval(
      child: Image.network(
        url,
        width: size,
        height: size,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stack) => _initial(),
      ),
    );
  }
}
