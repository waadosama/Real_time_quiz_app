// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:quiz_app/screens/Home_page.dart';
// import 'package:quiz_app/wigets/butom.dart';
// import 'package:quiz_app/wigets/text_field.dart';
// import 'package:quiz_app/screens/regestir.dart';
// import 'package:quiz_app/cubits/auth_cubit.dart';

// class LoginPage extends StatefulWidget {
//   const LoginPage({super.key});

//   @override
//   State<LoginPage> createState() => _LoginPageState();
// }

// class _LoginPageState extends State<LoginPage> {
//   late TextEditingController usernameController;
//   late TextEditingController passwordController;

//   static const Color mainGreen = Color(0xFF0D4726);
//   static const Color accentGreen = Color(0xFF1E6B3C);
//   static const Color beigeLight = Color(0xFFFDF6EE);
//   static const Color beigeDark = Color(0xFFF3DEC4);
//   static const Color headingMuted = Color.fromARGB(200, 51, 89, 82);

//   @override
//   void initState() {
//     super.initState();
//     usernameController = TextEditingController();
//     passwordController = TextEditingController();
//   }

//   @override
//   void dispose() {
//     usernameController.dispose();
//     passwordController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: beigeLight,
//       body: Container(
//         width: double.infinity,
//         color: beigeLight,
//         child: SafeArea(
//           child: Center(
//             child: SingleChildScrollView(
//               padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 36),
//               child: ConstrainedBox(
//                 constraints: const BoxConstraints(maxWidth: 350),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Row(
//                       crossAxisAlignment: CrossAxisAlignment.center,
//                       children: [
//                         Container(
//                           width: 100,
//                           height: 100,
//                           padding: const EdgeInsets.all(5),
//                           child: Image.asset(
//                             'assets/images/innovation.png',
//                             fit: BoxFit.contain,
//                           ),
//                         ),
//                         const SizedBox(width: 20),
//                         Expanded(
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               const Text(
//                                 'Log in',
//                                 style: TextStyle(
//                                   color: mainGreen,
//                                   fontWeight: FontWeight.bold,
//                                   fontSize: 36,
//                                 ),
//                               ),
//                               const SizedBox(height: 6),
//                               const Text(
//                                 'Join our App to unlock  quizzes',
//                                 style: TextStyle(
//                                   color: Color.fromARGB(200, 51, 89, 82),
//                                   fontSize: 16,
//                                   height: 1.3,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                     const SizedBox(height: 32),
//                     CustomTextField(
//                       controller: usernameController,
//                       hintText: 'Username',
//                       prefixIcon: Icons.person_outline,
//                     ),
//                     const SizedBox(height: 16),
//                     CustomTextField(
//                       controller: passwordController,
//                       hintText: 'Password',
//                       prefixIcon: Icons.lock_outline,
//                       obscureText: true,
//                     ),
//                     const SizedBox(height: 12),
//                     Align(
//                       alignment: Alignment.centerRight,
//                       child: GestureDetector(
//                         onTap: () {
//                         },
//                         child: Text(
//                           'Forgot password?',
//                           style: TextStyle(
//                             color: accentGreen,
//                             fontSize: 14,
//                             fontWeight: FontWeight.w600,
//                           ),
//                         ),
//                       ),
//                     ),
//                     const SizedBox(height: 28),
//                     BlocConsumer<AuthCubit, AuthState>(
//                       listener: (context, state) {
//                         if (state is AuthAuthenticated) {
//                           Navigator.of(context).pushReplacement(
//                             MaterialPageRoute(
//                               builder: (_) => const HomePage(),
//                             ),
//                           );
//                         } else if (state is AuthError) {
//                           ScaffoldMessenger.of(context).showSnackBar(
//                             SnackBar(content: Text(state.message)),
//                           );
//                         }
//                       },
//                       builder: (context, state) {
//                         if (state is AuthLoading) {
//                           return const Center(
//                             child: CircularProgressIndicator(),
//                           );
//                         }
//                         return CustomButton(
//                           text: 'Log in',
//                           elevation: 6,
//                           onTap: () {
//                             if (usernameController.text.isEmpty ||
//                                 passwordController.text.isEmpty) {
//                               ScaffoldMessenger.of(context).showSnackBar(
//                                 const SnackBar(
//                                   content: Text('Please fill all fields'),
//                                 ),
//                               );
//                               return;
//                             }
//                             context.read<AuthCubit>().login(
//                                   username: usernameController.text,
//                                   email: usernameController.text,
//                                   password: passwordController.text,
//                                 );
//                           },
//                         );
//                       },
//                     ),
//                     const SizedBox(height: 18),
//                     Wrap(
//                       alignment: WrapAlignment.center,
//                       children: [
//                         Text(
//                           "Don't have an account? ",
//                           style: TextStyle(color: mainGreen.withOpacity(0.6)),
//                         ),
//                         GestureDetector(
//                           onTap: () {
//                             Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                 builder: (_) => const RegisterPage(),
//                               ),
//                             );
//                           },
//                           child: const Text(
//                             'Sign up',
//                             style: TextStyle(
//                               color: accentGreen,
//                               fontWeight: FontWeight.w700,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
