import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_app/wigets/course_card.dart';
import 'package:quiz_app/screens/quizes.dart';
import 'package:quiz_app/cubits/courses_cubit.dart';
import 'package:quiz_app/cubits/auth_cubit.dart';
import 'package:quiz_app/screens/welcome_new.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  static const Color mainGreen = Color(0xFF0D4726);
  static const Color beigeLight = Color(0xFFFDF6EE);
  static const Color beigeDark = Color(0xFFF3DEC4);
  static const Color tileFill = Color(0xFFF2E6D1);

  String _getUserName(BuildContext context) {
    final authState = context.read<AuthCubit>().state;
    if (authState is AuthAuthenticated) {
      return authState.user.username;
    }
    return 'User';
  }

  Future<void> _signOut(BuildContext context) async {
    try {
      await context.read<AuthCubit>().logout();
      if (context.mounted) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => const WelcomePage(),
          ),
          (route) => false,
        );
      }
    } catch (e) {
      debugPrint('Error signing out: $e');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to sign out: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          CoursesCubit(), // Real-time listener starts automatically
      child: Scaffold(
        backgroundColor: beigeLight,
        body: Container(
          width: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [beigeLight, beigeDark],
            ),
          ),
          child: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 36),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: 70,
                        height: 70,
                        padding: const EdgeInsets.all(6),
                        child: Image.asset(
                          'assets/images/innovation.png',
                          fit: BoxFit.contain,
                        ),
                      ),
                      const SizedBox(width: 18),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Welcome, ${_getUserName(context)}',
                              style: const TextStyle(
                                color: mainGreen,
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 5),
                            const Text(
                              'Start your quiz journey now…',
                              style: TextStyle(
                                fontSize: 15,
                                color: Color.fromARGB(180, 13, 71, 38),
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.logout, color: mainGreen),
                        onPressed: () => _signOut(context),
                        tooltip: 'Sign Out',
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 20),
                    decoration: BoxDecoration(
                      color: mainGreen,
                      borderRadius: BorderRadius.circular(26),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.12),
                          blurRadius: 18,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'More grades you get',
                                style: TextStyle(
                                  color: tileFill,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 22,
                                ),
                              ),
                              const SizedBox(height: 4),
                              const Text(
                                'Earn a badge for it.',
                                style: TextStyle(
                                  color: tileFill,
                                  fontSize: 15,
                                  height: 1.4,
                                ),
                              ),
                              const SizedBox(height: 12),
                              TextButton(
                                style: TextButton.styleFrom(
                                  backgroundColor: tileFill,
                                  foregroundColor: mainGreen,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 18,
                                    vertical: 12,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                ),
                                onPressed: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Tap it pressed!'),
                                    ),
                                  );
                                },
                                child: const Text(
                                  'Tap it',
                                  style: TextStyle(fontWeight: FontWeight.w700),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 18),
                        Container(
                          width: 96,
                          height: 96,
                          padding: const EdgeInsets.all(4),
                          child: Image.asset(
                            'assets/images/medal.png',
                            fit: BoxFit.contain,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 28),
                  const Text(
                    'Explore by courses',
                    style: TextStyle(
                      color: mainGreen,
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Pull to refresh wrapper with BlocBuilder
                  RefreshIndicator(
                    color: mainGreen,
                    onRefresh: () async {
                      await context.read<CoursesCubit>().refreshCourses();
                    },
                    child: BlocBuilder<CoursesCubit, CoursesState>(
                      builder: (context, state) {
                        // Loading State
                        if (state is CoursesLoading) {
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
                        if (state is CoursesError) {
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
                                          .read<CoursesCubit>()
                                          .loadCourses();
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
                        if (state is CoursesLoaded) {
                          // Empty courses
                          if (state.courses.isEmpty) {
                            return Center(
                              child: Padding(
                                padding: const EdgeInsets.all(32.0),
                                child: Column(
                                  children: [
                                    const Icon(
                                      Icons.school_outlined,
                                      color: mainGreen,
                                      size: 64,
                                    ),
                                    const SizedBox(height: 16),
                                    const Text(
                                      'No courses available',
                                      style: TextStyle(
                                        color: mainGreen,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    const Text(
                                      'Check back later for new courses',
                                      style: TextStyle(
                                        color: Color.fromARGB(180, 13, 71, 38),
                                        fontSize: 14,
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    TextButton.icon(
                                      onPressed: () {
                                        context
                                            .read<CoursesCubit>()
                                            .loadCourses();
                                      },
                                      icon: const Icon(Icons.refresh),
                                      label: const Text('Refresh'),
                                      style: TextButton.styleFrom(
                                        foregroundColor: mainGreen,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }

                          // Display courses grid
                          return GridView.builder(
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              mainAxisSpacing: 18,
                              crossAxisSpacing: 18,
                              childAspectRatio: 1.05,
                            ),
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: state.courses.length,
                            itemBuilder: (context, index) {
                              final course = state.courses[index];
                              return CourseCard(
                                text: course['name'] as String,
                                imagePath: course['imagePath'] as String?,
                                imageBase64: course['imageBase64'] as String?,
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => Quizes(
                                          courseId: course['id'] as String),
                                    ),
                                  );
                                },
                              );
                            },
                          );
                        }

                        // Initial/Default State
                        return const SizedBox.shrink();
                      },
                    ),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
