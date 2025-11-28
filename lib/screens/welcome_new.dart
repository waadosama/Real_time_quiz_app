import 'package:flutter/material.dart';
import 'package:quiz_app/wigets/butom.dart';
import '../wigets/floating.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  static const Color mainGreen = Color(0xFF0D4726);
  static const Color beigeLight = Color(0xFFFDF6EE);
  static const Color beigeDark = Color(0xFFF3DEC4);
  static const Color tileFill = Color(0xFFF2E6D1);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          color: beigeLight,
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 40),

                  const SizedBox(height: 28),

                  // TITLE TEXT
                
                   Container(
                    width: 240,
                    height: 300,
                    decoration: BoxDecoration(
                      //color: Colors.white.withOpacity(0.85),
                      borderRadius: BorderRadius.circular(36.0),
                      // boxShadow: [
                      //   BoxShadow(
                      //     color: Colors.black.withOpacity(0.08),
                      //     spreadRadius: 2,
                      //     blurRadius: 18,
                      //     offset: const Offset(0, 8),
                      //   ),
                      // ],
                    ),
                    child: const Center(
                      child: FloatingImage(),
                    ),
                  ),
const SizedBox(height: 10),
Column(
                    children: const [
                      // Text(
                      //   'Welcome',
                      //   style: TextStyle(
                      //     color: Color(0xFF0D4726),
                      //     fontSize: 28,
                      //     fontWeight: FontWeight.bold,
                      //   ),
                      // ),
                      SizedBox(height: 6),
                      Text(
                        'QuizByte',
                        style: TextStyle(
                          color: mainGreen,
                          fontSize: 60,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 30),

                  // LOGIN BUTTON
                  TransparentCard(
                    title: 'Log In',
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Navigating to Log In...'),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 14),

                  // REGISTER BUTTON
                  TransparentCard(
                    title: 'Register',
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Navigating to Register...'),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 48),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
