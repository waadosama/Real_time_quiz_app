import 'package:flutter/material.dart';

class quizes_cont extends StatelessWidget {
  final String name;
  final String date;
  final String duration;
  final int questionsCount;
  final String imagePath;
  final VoidCallback? onTap;
  final VoidCallback? onTrackingTap;

  const quizes_cont({
    super.key,
    required this.name,
    required this.date,
    required this.duration,
    this.questionsCount = 0,
    this.imagePath = 'assets/images/exam.png',
    this.onTap,
    this.onTrackingTap,
  });

  static const Color mainGreen = Color(0xFF0D4726);
  static const Color accentGreen = Color(0xFF1E6B3C);
  static const Color beigeLight = Color(0xFFFDF6EE);
  static const Color beigeDark = Color(0xFFF3DEC4);
  static const Color tileFill = Color(0xFFF2E6D1);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        color: tileFill,
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with image and title
              Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(14),
                    child: Image.asset(
                      imagePath,
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: mainGreen.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: const Icon(Icons.quiz, color: mainGreen),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: mainGreen,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 6),
                        Text(
                          date,
                          style: const TextStyle(
                            fontSize: 13,
                            color: Color.fromARGB(180, 13, 71, 38),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              // Info row: questions count and duration
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: mainGreen.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '$questionsCount Questions',
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: mainGreen,
                      ),
                    ),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: mainGreen,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      duration,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: beigeLight,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }
}
