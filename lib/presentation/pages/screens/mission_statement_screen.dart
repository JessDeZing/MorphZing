import 'package:flutter/material.dart';
import 'package:morphzing/localization/translation_keys.dart';
import 'package:morphzing/presentation/widgets/app_bar.dart';
import 'package:get/get.dart';

class MissionStatementScreen extends StatefulWidget {
  const MissionStatementScreen({Key? key}) : super(key: key);

  @override
  State<MissionStatementScreen> createState() => _MissionStatementScreenState();
}

class _MissionStatementScreenState extends State<MissionStatementScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeIn;
  late Animation<double> _slideUp;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _fadeIn = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _slideUp = Tween<double>(begin: 40, end: 0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF070C1A),
      appBar: StaticAppBar.subHomeAppBar(context, missionStatement.tr, false, ''),
      body: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Opacity(
            opacity: _fadeIn.value,
            child: Transform.translate(
              offset: Offset(0, _slideUp.value),
              child: child,
            ),
          );
        },
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 36),
                Text(
                  'OUR MISSION',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 3,
                    color: Colors.white.withOpacity(0.3),
                    fontFamily: 'SF Pro Display',
                  ),
                ),
                const SizedBox(height: 14),
                ShaderMask(
                  shaderCallback: (bounds) => const LinearGradient(
                    colors: [Color(0xFF8B6FE8), Color(0xFFE88FC7), Color(0xFF86EFAC)],
                  ).createShader(bounds),
                  child: const Text(
                    'Life is complicated.\nMorphZing is not.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'SF Pro Display',
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                      height: 1.3,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  width: 36,
                  height: 3,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(2),
                    gradient: const LinearGradient(
                      colors: [Color(0xFF8B6FE8), Color(0xFFE88FC7)],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Get organized, inspired, and at peace.\nOne simple app. One beautiful journey.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'SF Pro Display',
                    fontSize: 15,
                    color: Colors.white.withOpacity(0.5),
                    height: 1.8,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 32),
                Image.asset(
                  'assets/images/treeoflifetransparent.png',
                  width: MediaQuery.of(context).size.width * 0.82,
                  fit: BoxFit.contain,
                ),
                const SizedBox(height: 28),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 38,
                      height: 38,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: [
                            Color(0xFF4F6BED),
                            Color(0xFFA78BFA),
                            Color(0xFFF0ABFC),
                            Color(0xFF86EFAC),
                          ],
                        ),
                      ),
                      child: const Center(
                        child: Text(
                          'MZ',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                            fontFamily: 'SF Pro Display',
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    ShaderMask(
                      shaderCallback: (bounds) => const LinearGradient(
                        colors: [Color(0xFFA78BFA), Color(0xFFF0ABFC)],
                      ).createShader(bounds),
                      child: const Text(
                        'MorphZing',
                        style: TextStyle(
                          fontFamily: 'SF Pro Display',
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 48),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
