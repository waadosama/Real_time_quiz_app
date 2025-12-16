import 'dart:math' as math;
import 'package:flutter/material.dart';

const Color _kMainGreen = Color(0xFF0D4726);
const Color _kBeigeLight = Color(0xFFF5E6D3);
const Color _kBeigeDark = Color.fromARGB(255, 242, 217, 188);
const Color _kbiege = Color.fromARGB(255, 220, 177, 125);
const Color beigeLight = Color(0xFFFDF6EE);

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    required this.text,
    required this.onTap,
    this.elevation = 2,
  });

  final String text;
  final VoidCallback onTap;
  final double elevation;
  

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: elevation,
      borderRadius: BorderRadius.circular(18),
      color: _kMainGreen,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
          child: Center(
            child: Text(
              text,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class TransparentCard extends StatelessWidget {
  const TransparentCard({
    super.key,
    required this.title,
    required this.onTap,
  });

  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final cardMaxWidth = math.min(screenWidth * 2, 180.0);

    return Center(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minWidth: 180,
              maxWidth: cardMaxWidth,
            ),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
              margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
              decoration: BoxDecoration(
                // single light beige color
                color: beigeLight,
                borderRadius: BorderRadius.circular(16),
                // soften visible border and simulate blurred stroke with layered glows
                border: Border.all(
                  color: _kMainGreen,
                  width: 2.0,
                ),
                boxShadow: [
                  BoxShadow(
                    color: _kMainGreen.withOpacity(0.1),
                    blurRadius: 18,
                    spreadRadius: 2,
                    offset: const Offset(0, 0),
                  ),
                  // larger soft haze to diffuse the border
                  BoxShadow(
                    color: _kMainGreen.withOpacity(0.10),
                    blurRadius: 36,
                    spreadRadius: 6,
                    offset: const Offset(0, 0),
                  ),
                  // subtle drop shadow for elevation
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 10,
                    spreadRadius: 0,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // slim green accent on the left (smaller)
                  Container(
                    width: 6,
                    height: 36,
                    margin: const EdgeInsets.only(right: 10),
                    decoration: BoxDecoration(
                      color: _kMainGreen,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(10),
                        bottomLeft: Radius.circular(10),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: _kBeigeDark.withOpacity(0.16),
                          blurRadius: 6,
                          spreadRadius: 0,
                          offset: const Offset(0, 1),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Text(
                      title,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: _kMainGreen,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.6,
                        shadows: [
                          Shadow(
                            color: _kMainGreen.withOpacity(0.32),
                            offset: const Offset(0, 2),
                            blurRadius: 10,
                          ),
                          Shadow(
                            color: _kMainGreen.withOpacity(0.20),
                            offset: const Offset(0, 6),
                            blurRadius: 20,
                          ),
                          Shadow(
                            color: Colors.black.withOpacity(0.12),
                            offset: const Offset(0, 10),
                            blurRadius: 30,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
