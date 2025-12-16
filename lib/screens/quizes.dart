import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_app/models/questions.dart';
import 'package:quiz_app/wigets/quizes_cont.dart';
import 'package:quiz_app/wigets/search_bar.dart';
import 'package:quiz_app/screens/question_page.dart';
import 'package:quiz_app/cubits/quizzes_cubit.dart';

class Quizes extends StatefulWidget {
  final String courseId;

  const Quizes({super.key, required this.courseId});

  @override
  State<Quizes> createState() => _QuizesState();
}

class _QuizesState extends State<Quizes> {
  String _searchQuery = '';

  static const Color mainGreen = Color(0xFF0D4726);
  static const Color beigeLight = Color(0xFFFDF6EE);

  List<Map<String, dynamic>> get filteredQuizzes {
    final state = context.watch<QuizzesCubit>().state;
    if (state is! QuizzesLoaded) return [];

    final allQuizzes = state.quizzes;
    if (_searchQuery.isEmpty) {
      return allQuizzes;
    }
    final query = _searchQuery.toLowerCase();
    return allQuizzes
        .where((quiz) =>
            (quiz['name'] as String).toLowerCase().contains(query) ||
            (quiz['date'] as String).toLowerCase().contains(query))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final sampleQuestionModels = <QuestionModel>[
      QuestionModel(
        question: 'What is the output of 1 + 1?',
        options: const ['True', 'False'],
        correctIndex: 1,
      ),
      QuestionModel(
        question: 'Which language is used to build Flutter apps?',
        options: const ['True', 'False'],
        correctIndex: 0,
      ),
      QuestionModel(
        question: 'Which widget is used for layout in Flutter?',
        options: const ['True', 'False'],
        correctIndex: 0,
      ),
    ];

    return BlocProvider(
      create: (context) => QuizzesCubit(courseId: widget.courseId),
      child: Scaffold(
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
                            BlocBuilder<QuizzesCubit, QuizzesState>(
                              builder: (context, state) {
                                final count = state is QuizzesLoaded
                                    ? filteredQuizzes.length
                                    : 0;
                                return Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: mainGreen.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    '$count',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: mainGreen,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        BlocBuilder<QuizzesCubit, QuizzesState>(
                          builder: (context, state) {
                            // Loading State
                            if (state is QuizzesLoading) {
                              return const Center(
                                child: Padding(
                                  padding: EdgeInsets.all(32.0),
                                  child: CircularProgressIndicator(
                                    color: mainGreen,
                                  ),
                                ),
                              );
                            }

                            // Error State
                            if (state is QuizzesError) {
                              return Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(32.0),
                                  child: Column(
                                    children: [
                                      const Icon(
                                        Icons.error_outline,
                                        color: Colors.red,
                                        size: 48,
                                      ),
                                      const SizedBox(height: 16),
                                      Text(
                                        state.message,
                                        style: const TextStyle(
                                          color: Colors.red,
                                          fontSize: 16,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                      const SizedBox(height: 16),
                                      ElevatedButton.icon(
                                        onPressed: () {
                                          context
                                              .read<QuizzesCubit>()
                                              .refreshQuizzes();
                                        },
                                        icon: const Icon(Icons.refresh),
                                        label: const Text('Retry'),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: mainGreen,
                                          foregroundColor: Colors.white,
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 24,
                                            vertical: 12,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }

                            // Loaded State
                            if (state is QuizzesLoaded) {
                              if (filteredQuizzes.isEmpty) {
                                return Center(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 32),
                                    child: Column(
                                      children: [
                                        Icon(
                                          Icons.search_off,
                                          size: 48,
                                          color: mainGreen.withOpacity(0.3),
                                        ),
                                        const SizedBox(height: 12),
                                        Text(
                                          _searchQuery.isEmpty
                                              ? 'No quizzes available'
                                              : 'No quizzes found',
                                          style: const TextStyle(
                                            fontSize: 16,
                                            color: mainGreen,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }

                              return Column(
                                children: filteredQuizzes
                                    .asMap()
                                    .entries
                                    .map((entry) {
                                  final quiz = entry.value;

                                  final durationMinutes = int.tryParse(
                                          (quiz['duration'] as String)
                                              .split(' ')
                                              .first) ??
                                      30;

                                  return Padding(
                                    padding: const EdgeInsets.only(bottom: 16),
                                    child: quizes_cont(
                                      name: quiz['name'] as String,
                                      date: quiz['date'] as String,
                                      duration: quiz['duration'] as String,
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) => QuestionPage(
                                              questions: sampleQuestionModels,
                                              initialIndex: 0,
                                              durationMinutes: durationMinutes,
                                              onSubmit: () {
                                                // simple submission flow: show a dialog
                                                showDialog(
                                                  context: context,
                                                  builder: (_) => AlertDialog(
                                                    title: const Text(
                                                        'Quiz submitted'),
                                                    content: const Text(
                                                        'Your answers have been recorded (demo).'),
                                                    actions: [
                                                      TextButton(
                                                        onPressed: () =>
                                                            Navigator.of(
                                                                    context)
                                                                .pop(),
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
                              );
                            }

                            // Initial State
                            return const SizedBox.shrink();
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
