import 'package:flutter/material.dart';
import 'package:quiz_app/wigets/add_category.dart';
import 'package:quiz_app/screens/quizes.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  static const Color mainGreen = Color(0xFF0D4726);
  static const Color beigeLight = Color(0xFFFDF6EE);
  static const Color beigeDark = Color(0xFFF3DEC4);
  static const Color tileFill = Color(0xFFF2E6D1);

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
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Welcome',
                            style: TextStyle(
                              color: mainGreen,
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 20),
                          Text(
                            'Start your quiz journey now…',
                            style: TextStyle(
                              fontSize: 15,
                              color: Color.fromARGB(180, 13, 71, 38),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                // Material(
                //   color: Colors.white,
                //   elevation: 5,
                //   borderRadius: BorderRadius.circular(28),
                //   child: TextField(
                //     decoration: InputDecoration(
                //       hintText: 'Search courses',
                //       hintStyle: TextStyle(
                //         color: mainGreen.withOpacity(0.55),
                //         fontSize: 15,
                //       ),
                //       prefixIcon: const Icon(Icons.search, color: mainGreen),
                //       border: InputBorder.none,
                //       contentPadding: const EdgeInsets.symmetric(
                //         horizontal: 18,
                //         vertical: 18,
                //       ),
                //     ),
                //   ),
                // ),
                //const SizedBox(height: 28),
                Container(
                  width: double.infinity,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
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
                GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  mainAxisSpacing: 18,
                  crossAxisSpacing: 18,
                  childAspectRatio: 1.05,
                  children: [
                    add_categorey(
                      text: 'Computer Science',
                      icon: Icons.code,
                     onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const Quizes()),
                        );
                      },
                    ),
                    add_categorey(text: 'Math 1', icon: Icons.calculate),
                    add_categorey(text: 'Creative', icon: Icons.psychology),
                    add_categorey(
                      text: 'Data Structure',
                      icon: Icons.data_object,
                    ),
                    add_categorey(text: 'Electronics', icon: Icons.memory),
                    add_categorey(text: 'AI', icon: Icons.smart_toy),
                  ],
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }
}