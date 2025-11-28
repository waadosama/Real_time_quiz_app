import 'package:flutter/material.dart';
import 'package:quiz_app/wigets/quizes_cont.dart';
import 'package:quiz_app/wigets/search_bar.dart';
import 'package:quiz_app/screens/question_page.dart';

class Quizes extends StatefulWidget {
  const Quizes({super.key});

  @override
  State<Quizes> createState() => _QuizesState();
}

class _QuizesState extends State<Quizes> {
  String _searchQuery = '';

  static const Color mainGreen = Color(0xFF0D4726);
  static const Color accentGreen = Color(0xFF1E6B3C);
  static const Color beigeLight = Color(0xFFFDF6EE);
  static const Color beigeDark = Color(0xFFF3DEC4);

  final List<Map<String, String>> allQuizzes = [
    {"name": "Flutter Basics", "date": "20/8", "duration": "5 min"},
    {"name": "Data structure", "date": "20/9", "duration": "20 min"},
    {"name": "Ai", "date": "13/7", "duration": "10 min"},
    {"name": "Infromtion system", "date": "13/7", "duration": "10 min"},
    {"name": "Creative", "date": "13/7", "duration": "10 min"},
    {"name": "Data base 2", "date": "13/7", "duration": "50 min"},
  ];

  List<Map<String, String>> get filteredQuizzes {
    if (_searchQuery.isEmpty) {
      return allQuizzes;
    }
    final query = _searchQuery.toLowerCase();
    return allQuizzes
        .where((quiz) =>
            quiz['name']!.toLowerCase().contains(query) ||
            quiz['date']!.toLowerCase().contains(query))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    // static questions used for demo navigation (declared here so it's in scope)
    final sampleQuestions = <Map<String, dynamic>>[
      {
        'id': 'q1',
        'text': 'What is the output of 1 + 1?',
        'options': ['1', '2', '3', '4'],
        'correctIndex': 1,
      },
      {
        'id': 'q2',
        'text': 'Which language is used to build Flutter apps?',
        'options': ['Java', 'Kotlin', 'Dart', 'Swift'],
        'correctIndex': 2,
      },
      {
        'id': 'q3',
        'text': 'Which widget is used for layout in Flutter?',
        'options': ['Container', 'Row', 'Column', 'All of the above'],
        'correctIndex': 3,
      },
    ];

    return Scaffold(
      backgroundColor: beigeLight,
      body: SafeArea(
        child: Column(
          children: [
            // Header with shadow and better spacing
            Container(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
              decoration: BoxDecoration(
                color: beigeLight,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: mainGreen.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.arrow_back_ios_new_rounded,
                          color: mainGreen, size: 24),
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Expanded(
                    child: Text(
                      'Quizzes',
                      style: TextStyle(
                        color: mainGreen,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Content area
            Expanded(
              child: SingleChildScrollView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 450),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Search bar
                      ProfessionalSearchBar(
                        hintText: 'Search quizzes...',
                        mainGreen: mainGreen,
                        onChanged: (value) {
                          setState(() {
                            _searchQuery = value;
                          });
                        },
                      ),
                      const SizedBox(height: 28),
                      // Available quizzes title
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Available Quizzes",
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: mainGreen,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: mainGreen.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              '${filteredQuizzes.length}',
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: mainGreen,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      // Quizzes list
                      if (filteredQuizzes.isEmpty)
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 32),
                            child: Column(
                              children: [
                                Icon(
                                  Icons.search_off,
                                  size: 48,
                                  color: mainGreen.withOpacity(0.3),
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  'No quizzes found',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: mainGreen,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      else
                        ...filteredQuizzes.asMap().entries.map((entry) {
                          final quiz = entry.value;
                          // parse duration minutes from strings like "30 min"
                          final durationMinutes = int.tryParse(
                                  quiz['duration']!.split(' ').first) ??
                              30;

                          return Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: quizes_cont(
                              name: quiz['name']!,
                              date: quiz['date']!,
                              duration: quiz['duration']!,
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => QuestionPage(
                                      questions: sampleQuestions,
                                      initialIndex: 0,
                                      durationMinutes: durationMinutes,
                                      onSubmit: () {
                                        // simple submission flow: show a dialog
                                        showDialog(
                                          context: context,
                                          builder: (_) => AlertDialog(
                                            title: const Text('Quiz submitted'),
                                            content: const Text(
                                                'Your answers have been recorded (demo).'),
                                            actions: [
                                              TextButton(
                                                onPressed: () =>
                                                    Navigator.of(context).pop(),
                                                child: const Text('OK'),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                );
                              },
                            ),
                          );
                        }).toList(),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
