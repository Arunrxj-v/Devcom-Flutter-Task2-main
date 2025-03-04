import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'Auth/auth_bloc.dart';
import 'login_page.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    print('Attempting Firebase initialization...');
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    print('Firebase initialized successfully');
  } catch (e) {
    print('Firebase initialization error: $e');
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (context) => AuthBloc(FirebaseAuth.instance),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primaryColor: const Color(0xFF4285F4),
          scaffoldBackgroundColor: const Color.fromARGB(255, 255, 120, 24),
          colorScheme: ColorScheme.fromSwatch().copyWith(
            primary: const Color(0xFF4285F4),
            secondary: const Color(0xFF34A853),
            error: const Color(0xFFEA4335),
            surface: const Color(0xFFFBBC05),
          ),
          textTheme: const TextTheme(
            displayLarge: TextStyle(color: Color(0xFF4285F4)),
            displayMedium: TextStyle(color: Color(0xFF34A853)),
            bodyLarge: TextStyle(color: Color(0xFFEA4335)),
            bodyMedium: TextStyle(color: Color(0xFFFBBC05)),
          ),
        ),
        home: const LoginPage(),
      ),
    );
  }
}
