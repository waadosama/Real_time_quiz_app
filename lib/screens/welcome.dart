// import 'package:flutter/material.dart';
// import 'package:quiz_app/wigets/butom.dart';

// class WelcomePage extends StatelessWidget {
//   const WelcomePage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         width: double.infinity,
//         height: double.infinity,
//         decoration: const BoxDecoration(
//           gradient: RadialGradient(
//             center: Alignment.center,
//             radius: 1.5,
//             colors: [
//               Color.fromARGB(255, 26, 61, 101),
//               Color.fromARGB(255, 146, 191, 228),
//             ],
//             stops: [0.1, 0.6],
//           ),
//         ),
//         child: SafeArea(
//           child: Center(
//             child: SingleChildScrollView(
//               physics: const BouncingScrollPhysics(),
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   const SizedBox(height: 40),
//                   Container(
//                     width: 200, 
//                     height: 280,
//                     decoration: BoxDecoration(
//                       color: Color.fromARGB(176, 255, 255, 255), 
//                       borderRadius: BorderRadius.circular(40.0),
//                       boxShadow: [
//                         BoxShadow(
//                           color: Color.fromARGB(255, 43, 23, 23).withOpacity(0.15),
//                           spreadRadius: 3,
//                           blurRadius: 15,
//                           offset: const Offset(0, 10),
//                         ),
//                       ],
//                     ),
//                     child: Stack(
//                       alignment: Alignment.center,
//                       children: [
//                         Center(
//                           child: ClipRRect(
//                             borderRadius: BorderRadius.circular(30.0),
//                             child: Container(
//                               width: 265, 
//                               height: 265,
//                               color: _babyBlue, 
//                               child: Opacity(
//                                 opacity: 0.9, 
//                                 child: Image.asset(
//                                   _welcomeIconPath,
//                                   width: 180, 
//                                   height: 180,
//                                   fit: BoxFit.fitHeight,
//                                   errorBuilder: (context, error, stackTrace) {
//                                     return const SizedBox(
//                                       width: 180,
//                                       height: 180,
//                                       child: Center(
//                                         child: Text(
//                                           'Icon Missing!',
//                                           style: TextStyle(color: Colors.red, fontSize: 16),
//                                         ),
//                                       ),
//                                     );
//                                   },
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),

//                   const SizedBox(height: 40),

//                   const Text(
//                     'Welcome',
//                     style: TextStyle(
//                       color: Colors.white,
//                       fontSize: 30,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),

//                   const Text(
//                     'QuizByte',
//                     style: TextStyle(
//                       color: Color.fromARGB(255, 233, 229, 242),
//                       fontSize: 50,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),

//                   const SizedBox(height: 60),

//                   // Log In Button
//                   TransparentCard(
//                     title: 'Log In',
//                     onTap: () {
//                       ScaffoldMessenger.of(context).showSnackBar(
//                         const SnackBar(content: Text('Navigating to Log In...')),
//                       );
//                     },
//                   ),

//                   const SizedBox(height: 15),

//                   // Register Button
//                   TransparentCard(
//                     title: 'Register',
//                     onTap: () {
//                       ScaffoldMessenger.of(context).showSnackBar(
//                         const SnackBar(content: Text('Navigating to Register...')),
//                       );
//                     },
//                   ),

//                   const SizedBox(height: 60),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }