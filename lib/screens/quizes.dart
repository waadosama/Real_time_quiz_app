import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:quiz_app/cubits/quizzes_cubit.dart';
import 'package:quiz_app/models/questions.dart';
import 'package:quiz_app/models/quiz.dart';
import 'package:quiz_app/screens/question_page.dart';
import 'package:quiz_app/wigets/quizes_cont.dart';
import 'package:quiz_app/wigets/search_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../firebase_messaging.dart'; // NotificationService

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
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<QuizModel> _filterQuizzes(QuizzesState state) {
    if (state.status != QuizzesStatus.success) return const [];

    final allQuizzes = state.quizzes;
    if (_searchQuery.isEmpty) return allQuizzes;

    final query = _searchQuery.toLowerCase();
    return allQuizzes
        .where((quiz) =>
            quiz.name.toLowerCase().contains(query) ||
            (quiz.date?.toIso8601String() ?? '').toLowerCase().contains(query))
        .toList();
  }

  int _parseDurationMinutes(String duration) {
    final parts = duration.split(' ');
    final parsed = int.tryParse(parts.isNotEmpty ? parts.first : '');
    return parsed ?? 30;
  }

  Future<void> _showAlert(String title, String message) async {
    if (!mounted) return;
    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  Future<T?> _showLoading<T>() async {
    if (!mounted) return null;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(
        child: CircularProgressIndicator(color: mainGreen),
      ),
    );
    return null;
  }

  Future<bool> _tryJoinQuiz(QuizModel quiz) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      await _showAlert('Login required', 'Please login to start the quiz.');
      return false;
    }

    // Use shared top-level quizzes collection (same as professor app)
    final quizRef = _firestore.collection('quizzes').doc(quiz.id);
    final attemptRef = quizRef.collection('attempts').doc(user.uid);

    final durationMinutes = _parseDurationMinutes(quiz.duration);
    final staleAfter =
        Duration(minutes: durationMinutes + 5); // small buffer after quiz time

    try {
      await _firestore.runTransaction((txn) async {
        final attemptSnap = await txn.get(attemptRef);
        if (attemptSnap.exists) {
          // Any existing attempt counts, regardless of status
          throw _JoinException(
              'You have already attempted this quiz and cannot retake it.');
        }

        final quizSnap = await txn.get(quizRef);
        // If quiz doc doesn't exist yet, create a minimal one so locking works
        if (!quizSnap.exists) {
          txn.set(
            quizRef,
            {
              'id': quiz.id,
              'courseId': widget.courseId,
              'createdAt': Timestamp.now(),
            },
            SetOptions(merge: true),
          );
        }

        final data = quizSnap.data() ?? {};
        final currentParticipant = data['currentParticipant'] as String?;
        final currentSince = data['currentParticipantSince'] as Timestamp?;
        final now = Timestamp.now();

        final isStale = currentParticipant != null &&
            currentSince != null &&
            now.millisecondsSinceEpoch - currentSince.millisecondsSinceEpoch >
                staleAfter.inMilliseconds;

        if (currentParticipant != null &&
            currentParticipant != user.uid &&
            !isStale) {
          throw _JoinException(
              'Another student is taking this quiz. Please wait.');
        }

        txn.set(
          quizRef,
          {
            'currentParticipant': user.uid,
            'currentParticipantSince': now,
          },
          SetOptions(merge: true),
        );

        txn.set(
          attemptRef,
          {
            'status': 'in_progress',
            'startedAt': now,
          },
          SetOptions(merge: true),
        );
      });
      return true;
    } on _JoinException catch (e) {
      // Customize title based on message content
      final msg = e.message;
      final title = msg.contains('already attempted')
          ? 'Attempt limit reached'
          : 'Quiz busy';
      await _showAlert(title, msg);
      return false;
    } catch (e) {
      await _showAlert('Error', 'Failed to join quiz: $e');
      return false;
    }
  }

  Future<void> _releaseSlot({
    required String quizId,
    required bool markCompleted,
    int? score,
    required int totalQuestions,
    required int durationMinutes,
  }) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    // Top-level quizzes collection
    final quizRef = _firestore.collection('quizzes').doc(quizId);
    final attemptRef = quizRef.collection('attempts').doc(user.uid);
    final now = Timestamp.now();

    // Fetch attempt start time and student name for accurate time + notification
    DateTime startedAtDate =
        now.toDate().subtract(Duration(minutes: durationMinutes));
    try {
      final attemptSnap = await attemptRef.get();
      final startedAtTs = attemptSnap.data()?['startedAt'] as Timestamp?;
      if (startedAtTs != null) {
        startedAtDate = startedAtTs.toDate();
      }
    } catch (_) {
      // fallback already set
    }

    String studentName = user.displayName ?? '';
    try {
      final studentDoc =
          await _firestore.collection('users').doc(user.uid).get();
      final data = studentDoc.data();
      if (data != null) {
        studentName = (data['name'] as String?) ??
            (data['username'] as String?) ??
            studentName;
      }
    } catch (_) {
      // ignore
    }
    if (studentName.isEmpty) {
      studentName = user.email ?? 'Student';
    }

    try {
      await _firestore.runTransaction((txn) async {
        final quizSnap = await txn.get(quizRef);
        final currentParticipant =
            quizSnap.data()?['currentParticipant'] as String?;

        // Only clear if the same user holds the slot
        if (currentParticipant == user.uid) {
          txn.set(
            quizRef,
            {
              'currentParticipant': null,
              'currentParticipantSince': null,
            },
            SetOptions(merge: true),
          );
        }

        final attemptData = <String, dynamic>{
          'status': markCompleted ? 'completed' : 'abandoned',
          'finishedAt': now,
        };
        if (score != null) attemptData['score'] = score;
        txn.set(
          attemptRef,
          attemptData,
          SetOptions(merge: true),
        );
      });

      // Also write an entry to quiz_results collection so professor app
      // dashboard & notifications can show scores.
      if (markCompleted && score != null) {
        final completedAt = now.toDate();
        final timeTakenSeconds =
            completedAt.difference(startedAtDate).inSeconds;
        final quizResultId = '${user.uid}_$quizId';

        await _firestore.collection('quiz_results').doc(quizResultId).set({
          'id': quizResultId,
          'studentId': user.uid,
          'studentName': studentName,
          'quizId': quizId,
          'startedAt': startedAtDate.toIso8601String(),
          'completedAt': completedAt.toIso8601String(),
          'timeTaken': timeTakenSeconds,
          'correctAnswers': score,
          'totalQuestions': totalQuestions,
          'score': score,
        }, SetOptions(merge: true));

        // After saving result, send push notification to professor app
        try {
          final notificationService = NotificationService();
          final timeMinutes = timeTakenSeconds ~/ 60;
          final timeSeconds = timeTakenSeconds % 60;
          final timeText = timeMinutes > 0
              ? '${timeMinutes}m ${timeSeconds}s'
              : '${timeSeconds}s';
          if (NotificationService.USE_API_MODE) {
            await notificationService.sendNotificationViaAPI(
              quizId: quizId,
              studentId: user.uid,
              studentName: studentName,
              score: score,
              totalQuestions: totalQuestions,
              timeTakenSeconds: timeTakenSeconds,
            );
          } else {
            await notificationService.sendNotificationToTopic(
              topic: 'quiz_results',
              title: 'Quiz finished by $studentName',
              body: 'Score: $score/$totalQuestions | Time: $timeText',
              data: {
                'quizId': quizId,
                'studentId': user.uid,
                'studentName': studentName,
                'score': score.toString(),
                'totalQuestions': totalQuestions.toString(),
                'timeTakenSeconds': timeTakenSeconds.toString(),
              },
            );
          }
        } catch (e) {
          // Do not block UI if notification sending fails
          // ignore: avoid_print
          print('Error sending quiz result notification: $e');
        }
      }
    } catch (_) {
      // We intentionally swallow errors here to avoid blocking UI on exit.
    }
  }

  Future<void> _updateAttemptProgress({
    required String quizId,
    required Map<int, int?> answers,
    required int currentQuestionIndex,
  }) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final quizRef = _firestore.collection('quizzes').doc(quizId);
    final attemptRef = quizRef.collection('attempts').doc(user.uid);

    final answersPayload = <String, dynamic>{};
    answers.forEach((key, value) {
      answersPayload[key.toString()] = value;
    });

    try {
      await attemptRef.set(
        {
          'currentQuestionIndex': currentQuestionIndex,
          'answers': answersPayload,
          'updatedAt': FieldValue.serverTimestamp(),
        },
        SetOptions(merge: true),
      );
    } catch (_) {
      // Non-blocking: ignore failures to avoid interrupting quiz flow
    }
  }

  Future<void> _handleQuizTap(QuizModel quiz) async {
    await _showLoading();
    final joined = await _tryJoinQuiz(quiz);
    if (mounted) Navigator.of(context, rootNavigator: true).pop();
    if (!joined) return;

    final durationMinutes = _parseDurationMinutes(quiz.duration);

    // Load questions from Firestore to display real content
    final quizDoc = await _firestore.collection('quizzes').doc(quiz.id).get();
    final data = quizDoc.data() ?? {};
    final List<dynamic> rawQuestions =
        (data['questions'] as List<dynamic>?) ?? [];
    final questions = rawQuestions.map((q) {
      final qm = q as Map<String, dynamic>? ?? {};
      final text = (qm['questionText'] as String?) ?? 'Question';
      final correctAnswer = qm['correctAnswer'] as bool? ?? true;
      return QuestionModel(
        question: text,
        options: const ['True', 'False'],
        correctIndex: correctAnswer ? 0 : 1,
      );
    }).toList();
    final totalQuestions = questions.isNotEmpty
        ? questions.length
        : (quiz.questionsCount > 0 ? quiz.questionsCount : 1);

    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => QuestionPage(
          questions: questions.isNotEmpty
              ? questions
              : List<QuestionModel>.generate(
                  totalQuestions,
                  (index) => QuestionModel(
                    question: 'Question ${index + 1}',
                    options: const ['True', 'False'],
                    correctIndex: 0,
                  ),
                ),
          initialIndex: 0,
          durationMinutes: durationMinutes,
          onSubmitScore: (score) => _releaseSlot(
            quizId: quiz.id,
            markCompleted: true,
            score: score,
            totalQuestions: totalQuestions,
            durationMinutes: durationMinutes,
          ),
          onSubmit: () async {
            if (!mounted) return;
            final showScore = quiz.showFinalScore;
            final scoreText = 'Your score: \$score / ${quiz.questionsCount}';
            await showDialog(
              context: context,
              builder: (_) => AlertDialog(
                title: Text(showScore ? 'Quiz Finished' : 'Great work!'),
                content: Text(
                  showScore
                      ? scoreText
                      : 'You have completed the quiz successfully.',
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('OK'),
                  ),
                ],
              ),
            );
            if (mounted) {
              Navigator.of(context).pop(); // Back to quizzes list
            }
          },
          onExit: () => _releaseSlot(
            quizId: quiz.id,
            markCompleted: false,
            score: 0,
            totalQuestions: totalQuestions,
            durationMinutes: durationMinutes,
          ),
          onAnswerProgress: (qIndex, selected, answers) =>
              _updateAttemptProgress(
            quizId: quiz.id,
            answers: answers,
            currentQuestionIndex: qIndex,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
                                final filtered = _filterQuizzes(state);
                                final count = filtered.length;
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
                            if (state.status == QuizzesStatus.loading ||
                                state.status == QuizzesStatus.initial) {
                              return const Center(
                                child: Padding(
                                  padding: EdgeInsets.all(32.0),
                                  child: CircularProgressIndicator(
                                    color: mainGreen,
                                  ),
                                ),
                              );
                            }

                            if (state.status == QuizzesStatus.failure) {
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
                                        state.errorMessage ??
                                            'Failed to load quizzes',
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

                            if (state.status == QuizzesStatus.success) {
                              final filtered = _filterQuizzes(state);
                              if (filtered.isEmpty) {
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
                                children: filtered.map((quiz) {
                                  final dateString = quiz.date != null
                                      ? DateFormat('dd MMM yyyy')
                                          .format(quiz.date!)
                                      : '';

                                  return Padding(
                                    padding: const EdgeInsets.only(bottom: 16),
                                    child: quizes_cont(
                                      name: quiz.name,
                                      date: dateString,
                                      duration: quiz.duration,
                                      questionsCount: quiz.questionsCount,
                                      onTap: () => _handleQuizTap(quiz),
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

class _JoinException implements Exception {
  final String message;
  _JoinException(this.message);
}
