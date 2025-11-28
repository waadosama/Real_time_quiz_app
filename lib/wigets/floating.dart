import 'package:flutter/material.dart';
class FloatingImage extends StatefulWidget {
  const FloatingImage({super.key});

  @override
  _FloatingImageState createState() => _FloatingImageState();
}

class _FloatingImageState extends State<FloatingImage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: -10, end: 10).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _animation.value),
          child: child,
        );
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(26.0),
        child: Hero(
          tag: 'quiz_image',
          child: Image.asset(
            'assets/images/cheer-up.png',
            width: 1000,
            height: 1000,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}
