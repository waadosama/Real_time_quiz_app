import 'package:flutter/material.dart';
import '../wigets/butom.dart';
import '../wigets/floating.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  static const Color mainGreen = Color(0xFF0D4726);
  static const Color beigeLight = Color(0xFFFDF6EE);

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  final String _titleText = 'QuizByte';
  late List<bool> _titleVisibility;

  bool _titleGroupVisible = true;
  bool _contentVisible = false;

  // --- Timing Constants ---
  static const int _letterDelayMs = 150;
  static const int _titleHoldDelayMs = 800;
  static const int _titleFadeOutDurationMs = 500;
  static const int _contentFadeInDurationMs = 700;

  @override
  void initState() {
    super.initState();

    _titleVisibility = List.filled(_titleText.length, false);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startAnimationSequence();
    });
  }

 
  void _startAnimationSequence() {
    final totalLetterAppearanceTime = _letterDelayMs * _titleText.length;


    for (int i = 0; i < _titleText.length; i++) {
      Future.delayed(Duration(milliseconds: _letterDelayMs * i), () {
        if (mounted) {
          setState(() {
            _titleVisibility[i] = true;
          });
        }
      });
    }


    final fadeOutStartTime = totalLetterAppearanceTime + _titleHoldDelayMs;
    Future.delayed(Duration(milliseconds: fadeOutStartTime), () {
      if (mounted) {
        setState(() {
          _titleGroupVisible = false;
        });
      }
    });

    final contentInStartTime =
        fadeOutStartTime + _titleFadeOutDurationMs;
    Future.delayed(Duration(milliseconds: contentInStartTime), () {
      if (mounted) {
        setState(() {
          _contentVisible = true;
        });
      }
    });
  }

  Widget _buildAnimatedLetter(int index) {
    return AnimatedOpacity(
      opacity: _titleVisibility[index] ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 300),
      child: Text(
        _titleText[index],
        style: const TextStyle(
          color: WelcomePage.mainGreen,
          fontSize: 60,
          fontWeight: FontWeight.bold,
          height: 1.0,
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: WelcomePage.beigeLight,
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                
                AnimatedOpacity(
                  opacity: _titleGroupVisible ? 1.0 : 0.0,
                  duration: const Duration(
                      milliseconds: _titleFadeOutDurationMs),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      _titleText.length,
                      (index) => _buildAnimatedLetter(index),
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                // -----------------------
                // CONTENT AFTER ANIMATION
                // -----------------------
                AnimatedOpacity(
                  opacity: _contentVisible ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: _contentFadeInDurationMs),
                  child: _contentVisible
                      ? Column(
                          children: [
                            Container(
                              width: 240,
                              height: 300,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(36.0),
                              ),
                              child: const Center(
                                child: FloatingImage(),
                              ),
                            ),

                            const SizedBox(height: 10),

                            const Text(
                              'Welcome',
                              style: TextStyle(
                                color: WelcomePage.mainGreen,
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            const SizedBox(height: 50),
                            TransparentCard(
                              title: 'Log In',
                              onTap: () {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => const log_in()),
  );
},
                            ),

                            const SizedBox(height: 14),
                            TransparentCard(
                              title: 'Register',
                            onTap: () {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => const RegisterPage()),
  );
},
                            ),

                            const SizedBox(height: 48),
                          ],
                        )
                      : const SizedBox(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
