import 'package:flutter/material.dart';




class TrueFalseOption extends StatelessWidget {
  final String label;
  final bool isSelected;
  final bool? isCorrect; 
  final VoidCallback onTap;

  const TrueFalseOption({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onTap,
    this.isCorrect,
  });

  @override
  Widget build(BuildContext context) {
    // Determine if this option is 'True' or 'False' based on its label
    final bool isTrue = label.toLowerCase() == "true";

    // --- Color and Style Initialization ---
    Color baseColor = isTrue ? Colors.green : Colors.red;
    Color textColor = Colors.white; // Default text color
    Color glowColor = baseColor.withOpacity(0.6);

    // --- Logic for Post-Answer Coloring (isCorrect != null) ---
    if (isCorrect != null) {
      if (isSelected) {
        // User's selected option: show if they were correct or incorrect
        if (isCorrect == true) {
          baseColor = Colors.green.shade800; // Correct selection
        } else {
          baseColor = Colors.red.shade800; // Incorrect selection
        }
      } else {
        // Non-selected option: highlight if it was the correct answer
        if (isCorrect == true && isTrue) {
          baseColor = Colors.green.shade800; // Correct answer (True)
        } else if (isCorrect == false && !isTrue) {
          baseColor = Colors.red.shade800; // Correct answer (False)
        } else {
          // Other non-selected, incorrect options
          baseColor = Colors.grey.shade400; 
          textColor = Colors.grey.shade800;
        }
      }
    }

    // --- Widget Structure ---
    return GestureDetector(
      onTap: onTap,
      // Wrap the entire widget in a Center to ensure the button is centered 
      // when used in a Row or other parent widget like a Column
      child: Center(
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
          // Set fixed width/height for the circular button
          width: 100, 
          height: 100, 
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: baseColor,
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: glowColor,
                      blurRadius: 2,
                      spreadRadius: 4,
                    )
                  ]
                : [],
          ),
          alignment: Alignment.center,
          // Only display the Text, removing the Icon and the SizedBox for spacing
          child: Text(
            label.toUpperCase(),
            textAlign: TextAlign.center,
            style: TextStyle(
              color: textColor,
              fontSize: 20,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.3,
            ),
          ),
        ),
      ),
    );
  }
}