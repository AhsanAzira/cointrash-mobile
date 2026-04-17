import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../app_theme.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int _currentPage = 0;

  final List<_OnboardingData> _pages = [
    _OnboardingData(
      title: 'Mari Cintai\nKebersihan',
      subtitle:
          'Setiap sampah yang kamu daur ulang, bernilai koin yang bisa ditukar hadiah menarik!',
      icon: Icons.eco_rounded,
    ),
    _OnboardingData(
      title: 'Gabung\nCoin Trash',
      subtitle:
          'Scan sampahmu, temukan lokasi drop-off terdekat, dan kumpulkan koin sekarang!',
      icon: Icons.monetization_on_rounded,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.primaryDark,
              AppColors.primaryGreen,
              Color(0xFF40916C),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: PageView.builder(
                  controller: _controller,
                  onPageChanged: (i) => setState(() => _currentPage = i),
                  itemCount: _pages.length,
                  itemBuilder: (context, index) {
                    final data = _pages[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                                width: 160,
                                height: 160,
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.15),
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: AppColors.accentYellow.withValues(
                                      alpha: 0.4,
                                    ),
                                    width: 3,
                                  ),
                                ),
                                child: Icon(
                                  data.icon,
                                  size: 80,
                                  color: AppColors.accentYellow,
                                ),
                              )
                              .animate()
                              .fadeIn(duration: 600.ms)
                              .scale(
                                begin: const Offset(0.8, 0.8),
                                end: const Offset(1.0, 1.0),
                                duration: 600.ms,
                              ),
                          const SizedBox(height: 48),
                          Text(
                                data.title,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.white,
                                  height: 1.2,
                                ),
                              )
                              .animate()
                              .fadeIn(delay: 200.ms, duration: 500.ms)
                              .slideY(begin: 0.2, end: 0),
                          const SizedBox(height: 16),
                          Text(
                            data.subtitle,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.white.withValues(alpha: 0.85),
                              height: 1.5,
                            ),
                          ).animate().fadeIn(delay: 400.ms, duration: 500.ms),
                        ],
                      ),
                    );
                  },
                ),
              ),
              // Page indicators
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  _pages.length,
                  (i) => AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: _currentPage == i ? 32 : 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: _currentPage == i
                          ? AppColors.accentYellow
                          : Colors.white.withValues(alpha: 0.4),
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 40),
              // Button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_currentPage < _pages.length - 1) {
                        _controller.nextPage(
                          duration: const Duration(milliseconds: 400),
                          curve: Curves.easeInOut,
                        );
                      } else {
                        Navigator.pushReplacementNamed(context, '/signin');
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.accentOrange,
                      foregroundColor: AppColors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      elevation: 8,
                      shadowColor: AppColors.accentOrange.withValues(
                        alpha: 0.4,
                      ),
                    ),
                    child: Text(
                      _currentPage < _pages.length - 1
                          ? 'Continue'
                          : 'Get Started',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 48),
            ],
          ),
        ),
      ),
    );
  }
}

class _OnboardingData {
  final String title;
  final String subtitle;
  final IconData icon;

  _OnboardingData({
    required this.title,
    required this.subtitle,
    required this.icon,
  });
}
