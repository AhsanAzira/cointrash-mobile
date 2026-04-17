import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../app_theme.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 2500), () {
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/onboarding');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: AppColors.primaryDark,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
                  'assets/images/logo.png',
                  width: 140,
                  height: 140,
                  fit: BoxFit.contain,
                )
                .animate()
                .fadeIn(duration: 800.ms)
                .scale(
                  begin: const Offset(0.5, 0.5),
                  end: const Offset(1.0, 1.0),
                  duration: 800.ms,
                  curve: Curves.elasticOut,
                ),
            const SizedBox(height: 16),
            RichText(
                  text: TextSpan(
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.5,
                    ),
                    children: [
                      const TextSpan(
                        text: 'COIN ',
                        style: TextStyle(color: AppColors.accentYellow),
                      ),
                      const TextSpan(
                        text: 'TRASH',
                        style: TextStyle(color: AppColors.primaryGreen),
                      ),
                    ],
                  ),
                )
                .animate(delay: 400.ms)
                .fadeIn(duration: 600.ms)
                .slideY(begin: 0.3, end: 0),
          ],
        ),
      ),
    );
  }
}
