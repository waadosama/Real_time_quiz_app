import 'package:flutter/material.dart';
import 'package:quiz_app/models/questions.dart';
import 'package:quiz_app/wigets/quiz_timer.dart';
import '../wigets/true_or_false.dart';

class QuestionPage extends StatefulWidget {
  static const Color mainGreen = Color(0xFF0D4726);
  static const Color accentGreen = Color(0xFF1E6B3C);
  static const Color beigeLight = Color(0xFFFDF6EE);
  static const Color tileFill = Color(0xFFF2E6D1);

  final List<QuestionModel> questions;
  final int initialIndex;
  final int durationMinutes;
  final void Function(QuestionModel question, int selectedIndex)? onAnswer;

  final VoidCallback? onSubmit;

  const QuestionPage({
    super.key,
    required this.questions,
    this.initialIndex = 0,
    this.durationMinutes = 30,
    this.onAnswer,
    this.onSubmit,
  });

  @override
  State<QuestionPage> createState() => _QuestionPageState();
}

class _QuestionPageState extends State<QuestionPage> {
  late int _currentIndex;

  final Map<int, int?> _selectedAnswers = {};

  final Map<int, bool> _isCorrect = {};

  @override
  void initState() {
    super.initState();

    _currentIndex = widget.initialIndex.clamp(0, widget.questions.length - 1);
  }

  void _selectAnswer(int optionIndex) {
    setState(() {
      _selectedAnswers[_currentIndex] = optionIndex;
    });
    final q = widget.questions[_currentIndex];
    final correctIndex = q.correctIndex;
    _isCorrect[_currentIndex] = (optionIndex == correctIndex);
    widget.onAnswer?.call(q, optionIndex);
  }

  void _goNext() {
    if (_currentIndex < widget.questions.length - 1) {
      setState(() => _currentIndex++);
    } else {

      widget.onSubmit?.call();
    }
  }

  void _goPrev() {
    if (_currentIndex > 0) setState(() => _currentIndex--);
  }

  void _onTimeUp() {
    widget.onSubmit?.call();
  }

  @override
  Widget build(BuildContext context) {
    final question = widget.questions[_currentIndex];
    final selected = _selectedAnswers[_currentIndex];
    final List<String> displayOptions = List<String>.from(question.options);
    if (displayOptions.length < 2) {
      displayOptions.addAll(
        List.generate(
          2 - displayOptions.length,
          (index) => 'Option ${displayOptions.length + index + 1}',
        ),
      );
    }

    return Scaffold(
      backgroundColor: QuestionPage.beigeLight,
      appBar: PreferredSize(
        preferredSize:
            const Size.fromHeight(100.0),
        child: SafeArea(
          child: Container(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
            decoration: BoxDecoration(
              color: QuestionPage.beigeLight,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: QuestionPage.mainGreen.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.arrow_back_ios_new_rounded,
                            color: QuestionPage.mainGreen, size: 24),
                      ),
                    ),
                    const SizedBox(width: 16),
                    const Text(
                      'Question',
                      style: TextStyle(
                        color: QuestionPage.mainGreen,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),

                QuizTimer(
                  compact: true,
                  durationMinutes: widget.durationMinutes,
                  onTimeUp: _onTimeUp,
                ),
              ],
            ),
          ),
        ),
      ),

     body: SafeArea(
  child: Center(
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(

        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Spacer(),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
            ),
            child: Text(
              question.question,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w700,
                color: Color(0xFF0D4726),
              ),
            ),
          ),

          const Spacer(), 
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [

                const SizedBox(height: 48),
                Expanded(
                  child: TrueFalseOption(
                    label: displayOptions[0],
                    isSelected: selected == 0,
                    isCorrect: selected == null
                        ? null
                        : (selected == 0 ? _isCorrect[_currentIndex] : null),
                    onTap: () => _selectAnswer(0),
                  ),
                ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: TrueFalseOption(
                        label: displayOptions[1],
                        isSelected: selected == 1,
                        isCorrect: selected == null
                            ? null
                            : (selected == 1
                                ? _isCorrect[_currentIndex]
                                : null),
                        onTap: () => _selectAnswer(1),
                      ),
                    ),
                  ],
                ),

                const Spacer(),
                Row(
                  children: [

                    if (_currentIndex > 0)
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _goPrev,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey.shade300,
                            foregroundColor: const Color(0xFF0D4726),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                          child: const Text('Previous'),
                        ),
                      ),

                    if (_currentIndex > 0) const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: selected != null ? _goNext : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF0D4726),
                          foregroundColor:
                              _currentIndex < widget.questions.length - 1
                                  ? const Color(0xFFF5E6D3)
                                  : Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        child: Text(
                          _currentIndex < widget.questions.length - 1
                              ? 'Next'
                              : 'Submit',
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}