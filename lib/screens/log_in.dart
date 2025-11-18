import 'package:flutter/material.dart';
import 'package:quiz_app/screens/Home_page.dart';
import 'package:quiz_app/wigets/butom.dart';
import 'package:quiz_app/wigets/text_field.dart';
import 'package:quiz_app/screens/regestir.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

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
        color: beigeLight,
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 36),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 350),
                child: Column(
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
                        const SizedBox(width: 20),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Log in',
                                style: TextStyle(
                                  color: mainGreen,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 36,
                                ),
                              ),
                              const SizedBox(height: 6),
                              const Text(
                                'Join our App to unlock  quizzes',
                                style: TextStyle(
                                  color: Color.fromARGB(200, 51, 89, 82),
                                  fontSize: 16,
                                  height: 1.3,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                  CustomTextField(
                      hintText: 'Username',
                      prefixIcon: Icons.person_outline,
                    ),
                    const SizedBox(height: 16),
                     CustomTextField(
                      hintText: 'Password',
                      prefixIcon: Icons.lock_outline,
                      obscureText: true,
                    ),
                    const SizedBox(height: 12),
                    Align(
                      alignment: Alignment.centerRight,
                      child: GestureDetector(
                        onTap: () {
                       
                        },
                        child: Text(
                          'Forgot password?',
                          style: TextStyle(
                            color: accentGreen,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 28),
                    CustomButton(
                      text: 'Log in',
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
                          "Don't have an account? ",
                          style: TextStyle(color: mainGreen.withOpacity(0.6)),
                        ),
                      GestureDetector(
  onTap: () {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const RegisterPage()),
    );
  },
                          child: const Text(
                            'Sign up',
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
