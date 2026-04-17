import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app_theme.dart';
import 'store.dart';
import 'main_shell.dart';
import 'pages/splash_screen.dart';
import 'pages/onboarding_screen.dart';
import 'pages/signin_screen.dart';
import 'pages/signup_screen.dart';

import 'pages/forgot_password_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Set mobile-style status bar
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ),
  );

  // Initialize store
  final store = UserStore();
  await store.init();

  runApp(const CoinTrashApp());
}

class CoinTrashApp extends StatelessWidget {
  const CoinTrashApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CoinTrash',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.theme,
      initialRoute: '/',
      routes: {
        '/': (_) => const SplashScreen(),
        '/onboarding': (_) => const OnboardingScreen(),
        '/signin': (_) => const SignInScreen(),
        '/signup': (_) => const SignUpScreen(),

        '/forgot': (_) => const ForgotPasswordScreen(),
        '/main': (_) => const MainShell(),
      },
    );
  }
}
