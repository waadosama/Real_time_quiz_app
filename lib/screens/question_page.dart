import 'package:flutter/material.dart';
import 'package:quiz_app/wigets/quiz_timer.dart';
import '../wigets/true_or_false.dart';

class QuestionPage extends StatefulWidget {
  final List<Map<String, dynamic>> questions;
  final int initialIndex;
  final int durationMinutes;
  final void Function(Map<String, dynamic> question, int selectedIndex)?
      onAnswer;
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
    // Evaluate correctness if provided (0=True, 1=False)
    final q = widget.questions[_currentIndex];
    final correctIndex = q['correctIndex'];
    if (correctIndex is int) {
      _isCorrect[_currentIndex] = (optionIndex == correctIndex);
    }
    widget.onAnswer?.call(q, optionIndex);
  }

  void _goNext() {
    if (_currentIndex < widget.questions.length - 1) {
      setState(() => _currentIndex++);
    } else {
      // last question -> submit
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

    return Scaffold(
      backgroundColor: const Color(0xFFFDF6EE),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: const Color(0xFF0D4726),
        title: Text('Question ${_currentIndex + 1}/${widget.questions.length}'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12.0, top: 8, bottom: 8),
            child: QuizTimer(
              compact: true,
              durationMinutes: widget.durationMinutes,
              onTimeUp: _onTimeUp,
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                question['text'] ?? 'No question text',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF0D4726),
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: Column(
                  children: [
                    TrueFalseOption(
                      label: 'True',
                      isSelected: selected == 0,
                      isCorrect: selected == null
                          ? null
                          : (selected == 0 ? _isCorrect[_currentIndex] : null),
                      onTap: () => _selectAnswer(0),
                    ),
                    const SizedBox(height: 12),
                    TrueFalseOption(
                      label: 'False',
                      isSelected: selected == 1,
                      isCorrect: selected == null
                          ? null
                          : (selected == 1 ? _isCorrect[_currentIndex] : null),
                      onTap: () => _selectAnswer(1),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _currentIndex > 0 ? _goPrev : null,
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFF0D4726),
                        side: BorderSide(color: const Color(0xFF0D4726)),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: const Text('Previous'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _goNext,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0D4726),
                        foregroundColor:
                            _currentIndex < widget.questions.length - 1
                                ? const Color(0xFFF5E6D3)
                                : Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: Text(_currentIndex < widget.questions.length - 1
                          ? 'Next'
                          : 'Submit'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
