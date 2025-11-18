import 'package:flutter/material.dart';
import 'package:quiz_app/wigets/quizes_cont.dart';
class Quizes extends StatelessWidget {
  const Quizes({super.key});
  static const Color mainGreen = Color(0xFF0D4726);
  static const Color accentGreen = Color(0xFF1E6B3C);
  static const Color beigeLight = Color(0xFFFDF6EE);
  static const Color beigeDark = Color(0xFFF3DEC4);
  static const Color headingMuted = Color.fromARGB(126, 51, 89, 82);

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
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 40),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 450),
                child:Column(crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                 Container(
                  decoration: BoxDecoration(
                    color: mainGreen,
                    borderRadius: BorderRadius.circular(28),
                  
                    boxShadow: [
                      BoxShadow(
                        color: beigeDark,
                        blurRadius: 9,
                        offset: Offset(3, 6),
                      ),
                    ],
                  ),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Search courses',
                      hintStyle: TextStyle(
                        color: beigeDark,
                        fontSize: 15,
                      ),
                      prefixIcon: Icon(Icons.search, color: beigeDark ),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 55,
                        vertical: 18,
                      ),
                    ),
                  ),
                ),
                   const SizedBox(height: 25),
                   const Text(
                  "Available Quizzes",
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: mainGreen,
                  ),
                ),
                  const SizedBox(height: 40),
                  quizes_cont(
                  name: "Flutter Basics",
                  date: "20/8",
                  duration: "30 min",
                  onTap: () {},
                ),
                const SizedBox(height: 20),
                  quizes_cont(
                  name: " Data structure",
                  date: "20/9 ",
                  duration: "20 min",
                  onTap: () {},
                ),
                const SizedBox(height: 20),
                  quizes_cont(
                  name: " Ai",
                  date: "13/7 ",
                  duration: "10 min",
                  onTap: () {},
                ),
                 const SizedBox(height: 20),
                  quizes_cont(
                  name: " Infromtion system",
                  date: "13/7 ",
                  duration: "10 min",
                  onTap: () {},
                ),
                 SizedBox(height: 20),
                  quizes_cont(
                  name: " Creative ",
                  date: "13/7 ",
                  duration: "10 min",
                  onTap: () {},
                ),
                SizedBox(height: 20),
                  quizes_cont(
                  name: " Data base 2 ",
                  date: "13/7 ",
                  duration: "50 min",
                  onTap: () {},
                ),
              ]
              ),

            ),
          ),
         
        ),
      ),
      ),  );
  }
}

