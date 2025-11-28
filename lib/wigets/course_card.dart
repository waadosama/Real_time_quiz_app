import 'package:flutter/material.dart';

class CourseCard extends StatelessWidget {
  final String text;
  final String? imagePath;
  final IconData? icon;
  final VoidCallback? onTap;
  final Color mainGreen;
  final Color tileFill;

  const CourseCard({
    super.key,
    required this.text,
    this.imagePath,
    this.icon,
    this.onTap,
    this.mainGreen = const Color(0xFF0D4726),
    this.tileFill = const Color(0xFFF2E6D1),
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 6,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        color: tileFill,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (imagePath != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Image.asset(
                  imagePath!,
                  height: 50,
                  width: 50,
                  fit: BoxFit.contain,
                  errorBuilder: (_, __, ___) => Icon(
                    Icons.broken_image,
                    size: 50,
                    color: mainGreen,
                  ),
                ),
              )
            else if (icon != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Icon(
                  icon,
                  size: 48,
                  color: mainGreen,
                ),
              ),
            Text(
              text,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: mainGreen,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
