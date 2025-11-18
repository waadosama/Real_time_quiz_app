import 'package:flutter/material.dart';
import 'package:quiz_app/screens/Home_page.dart';
import 'package:quiz_app/wigets/butom.dart';
import 'package:quiz_app/wigets/text_field.dart';
import 'package:quiz_app/screens/log_in.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  static const Color mainGreen = Color(0xFF0D4726);
  static const Color accentGreen = Color(0xFF1E6B3C);
  static const Color beigeLight = Color(0xFFFDF6EE);
  static const Color beigeDark = Color(0xFFF3DEC4);
  static const Color headingMuted = Color.fromARGB(200, 51, 89, 82);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 36),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 350),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              width: 100,
                              height: 100,
                              padding: const EdgeInsets.all(5),
                              child: Image.asset(
                                'assets/images/innovation.png',
                                fit: BoxFit.contain,
                              ),
                            ),
                            SizedBox(width: 20,),
                            Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    const Text(
      'Sign up',
      style: TextStyle(
        color: mainGreen,
        fontSize: 35,
        fontWeight: FontWeight.bold,
      ),
    ),
    const SizedBox(height: 8),
    const Text(
      'Create a new account',
      style: TextStyle(
        color: Color.fromARGB(200, 51, 89, 82),
        fontSize: 22,
      ),
    ),
  ],
),
                          ],
                        ),
                        // const SizedBox(height: 8),
                        // Text(
                        //   'Join our App to unlock personalized quizzes, reminders, and progress tracking.',
                        //   style: TextStyle(
                        //     color: mainGreen.withOpacity(0.7),
                        //     fontSize: 14,
                        //     height: 1.4,
                        //   ),
                        // ),
                      ],
                    ),
                    const SizedBox(height: 24),
                     CustomTextField(
                      hintText: 'Username',
                      prefixIcon: Icons.person_outline,
                    ),
                    const SizedBox(height: 16),
                     CustomTextField(
                      hintText: 'Email',
                      prefixIcon: Icons.mail_outline,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 16),
                   CustomTextField(
                      hintText: 'Age',
                      prefixIcon: Icons.cake_outlined,
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 16),
                     CustomTextField(
                      hintText: 'Password',
                      prefixIcon: Icons.lock_outline,
                      obscureText: true,
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Use at least 8 characters, including a number.',
                      style: TextStyle(
                        color: Color.fromARGB(150, 13, 71, 38),
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 12),
                     CustomTextField(
                      hintText: 'Confirm Password',
                      prefixIcon: Icons.lock_reset_outlined,
                      obscureText: true,
                    ),
                    const SizedBox(height: 28),
                    CustomButton(
                      text: 'Register',
                      elevation: 6,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const HomePage()),
                        );
                      },
                    ),
                    const SizedBox(height: 18),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Already have an account? ',
                          style: TextStyle(color: mainGreen.withOpacity(0.6)),
                        ),
                        GestureDetector(
                        onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) =>  LoginPage()),
                        );
                      },
                          child: const Text(
                            'Log in',
                            style: TextStyle(
                              color: accentGreen,
                              fontWeight: FontWeight.w700,
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
        ),
      ),
    );
  }
}