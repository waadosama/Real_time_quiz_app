import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:quiz_app/screens/Home_page.dart';
import 'package:quiz_app/screens/welcome_new.dart';
import 'package:quiz_app/screens/log_in.dart';
import 'package:quiz_app/screens/regestir.dart';
import 'package:quiz_app/screens/quizes.dart';
import 'package:quiz_app/cubits/auth_cubit.dart';
import 'package:quiz_app/services/storage_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  runApp(MyApp(prefs: prefs));
}

class MyApp extends StatelessWidget {
  final SharedPreferences prefs;

  const MyApp({super.key, required this.prefs});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(
          create: (context) => StorageService(prefs),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => AuthCubit(
              storageService: context.read<StorageService>(),
            ),
          ),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          home: BlocBuilder<AuthCubit, AuthState>(
            builder: (context, state) {
              if (state is AuthInitial || state is AuthLoading) {
                return const Scaffold(
                  body: Center(child: CircularProgressIndicator()),
                );
              } else if (state is AuthAuthenticated) {
                return const HomePage();
              } else {
                return const HomePage();
              }
            },
          ),
        ),
      ),
    );
  }
}
