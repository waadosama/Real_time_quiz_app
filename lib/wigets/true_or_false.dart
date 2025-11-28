import 'package:flutter/material.dart';

/// True/False option widget with correctness feedback.
/// - When not selected: white background, gray border
/// - When selected (no feedback yet): light green background, green border
/// - When selected + correct: green background, green border
/// - When selected + incorrect: red background, red border
class TrueFalseOption extends StatelessWidget {
  final String label;
  final bool isSelected;
  final bool? isCorrect; // null when not evaluated, true/false after evaluation
  final VoidCallback onTap;

  const TrueFalseOption({
    super.key,
    required this.label,
    required this.isSelected,
    this.isCorrect,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final Color base = const Color(0xFF0D4726);
    Color bg;
    Color border;

    if (isSelected) {
      if (isCorrect == null) {
        // Selected but not evaluated yet
        bg = base.withOpacity(0.12);
        border = base;
      } else if (isCorrect == true) {
        // Correct answer
        bg = const Color(0xFF2ECC71).withOpacity(0.14);
        border = const Color(0xFF2ECC71);
      } else {
        // Incorrect answer
        bg = const Color(0xFFE74C3C).withOpacity(0.14);
        border = const Color(0xFFE74C3C);
      }
    } else {
      // Not selected
      bg = Colors.white;
      border = Colors.grey.shade300;
    }

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: border,
            width: isSelected ? 1.6 : 1,
          ),
        ),
        child: Text(
          label,
          textAlign: TextAlign.left,
          style: TextStyle(
            fontSize: 16,
            color: isSelected ? base : Colors.black87,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
