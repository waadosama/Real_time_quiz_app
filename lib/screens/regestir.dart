import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_app/wigets/butom.dart';
import 'package:quiz_app/wigets/text_field.dart';
import 'package:quiz_app/screens/log_in.dart';
import 'package:quiz_app/screens/welcome_new.dart';
import 'package:quiz_app/cubits/auth_cubit.dart';
import 'package:quiz_app/models/register_model.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  late TextEditingController usernameController;
  late TextEditingController emailController;
  late TextEditingController ageController;
  late TextEditingController passwordController;
  late TextEditingController confirmPasswordController;
  bool _isPasswordHidden = true;

  static const Color mainGreen = Color(0xFF0D4726);
  static const Color accentGreen = Color(0xFF1E6B3C);
  static const Color beigeLight = Color(0xFFFDF6EE);
  static const Color beigeDark = Color(0xFFF3DEC4);

  @override
  void initState() {
    super.initState();
    usernameController = TextEditingController();
    emailController = TextEditingController();
    ageController = TextEditingController();
    passwordController = TextEditingController();
    confirmPasswordController = TextEditingController();
  }

  @override
  void dispose() {
    usernameController.dispose();
    emailController.dispose();
    ageController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  void _showErrorDialog(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  bool _validateForm() {
    final registerData = RegisterModel(
      username: usernameController.text,
      email: emailController.text,
      password: passwordController.text,
      confirmPassword: confirmPasswordController.text,
      age: int.tryParse(ageController.text),
    );

    final validationError = registerData.validate();
    if (validationError != null) {
      _showErrorDialog(validationError);
      return false;
    }
    return true;
  }

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
                            const SizedBox(width: 20),
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
                      ],
                    ),
                    const SizedBox(height: 24),
                    CustomTextField(
                      controller: usernameController,
                      hintText: 'Username',
                      prefixIcon: Icons.person_outline,
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      controller: emailController,
                      hintText: 'Email',
                      prefixIcon: Icons.mail_outline,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      controller: ageController,
                      hintText: 'Age',
                      prefixIcon: Icons.cake_outlined,
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 16),
                    // CustomTextField(
                    //   controller: passwordController,
                    //   hintText: 'Password',
                    //   prefixIcon: Icons.lock_outline,
                    //   obscureText: true,
                    // )
                      CustomTextField(
  controller: passwordController,
  hintText: 'Password',
  prefixIcon: Icons.lock_outline,
  obscureText: _isPasswordHidden,
  suffixIcon: IconButton(
    icon: Icon(
      _isPasswordHidden
          ? Icons.visibility_off
          : Icons.visibility,
      color: const Color(0xFF7A8564),
    ),
    onPressed: () {
      setState(() {
        _isPasswordHidden = !_isPasswordHidden;
      });
    },
  ),
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
                      controller: confirmPasswordController,
                      hintText: 'Confirm Password',
                      prefixIcon: Icons.lock_reset_outlined,
                      obscureText: true,
                    ),
                    const SizedBox(height: 28),
                    BlocConsumer<AuthCubit, AuthState>(
                      listener: (context, state) {
                        if (state is AuthAuthenticated) {
                          // Navigate back to WelcomePage (root) and clear navigation stack
                          Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                              builder: (context) => const WelcomePage(),
                            ),
                            (route) => false, // Remove all previous routes
                          );
                        } else if (state is AuthError) {
                          _showErrorDialog(state.message);
                        }
                      },
                      builder: (context, state) {
                        if (state is AuthLoading) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        return CustomButton(
                          text: 'Register',
                          elevation: 6,
                          onTap: () {
                            if (!_validateForm()) {
                              return;
                            }
                            context.read<AuthCubit>().register(
                                  username: usernameController.text,
                                  email: emailController.text,
                                  password: passwordController.text,
                                );
                          },
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
                              MaterialPageRoute(
                                  builder: (_) => const LoginPage()),
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
