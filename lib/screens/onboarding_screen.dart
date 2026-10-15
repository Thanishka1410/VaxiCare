import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';
import '../core/theme/app_animations.dart';
import '../widgets/primary_button.dart';

class OnboardingScreen extends StatefulWidget {
  final VoidCallback onFinish;

  const OnboardingScreen({super.key, required this.onFinish});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, dynamic>> _pages = [
    {
      'icon': Icons.notifications_active_rounded,
      'title': 'Smart Vaccine Tracking',
      'description': 'Never lose track of upcoming child doses or vaccination dates with intelligent reminders.',
      'color': AppColors.primaryBlue,
    },
    {
      'icon': Icons.verified_user_rounded,
      'title': 'Digital Passbook & Records',
      'description': 'Maintain verified immunization records with clinical notes, batch numbers, and hospital details.',
      'color': AppColors.secondaryMint,
    },
    {
      'icon': Icons.family_restroom_rounded,
      'title': 'Complete Family Care',
      'description': 'Easily switch between dependents and children with personalized immunization milestones.',
      'color': Color(0xFF6366F1),
    },
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: AppAnimations.medium,
        curve: AppAnimations.defaultCurve,
      );
    } else {
      widget.onFinish();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Top Bar with Skip
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: widget.onFinish,
                    child: const Text(
                      'Skip',
                      style: TextStyle(
                        color: AppColors.secondaryText,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // PageView
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) => setState(() => _currentPage = index),
                itemCount: _pages.length,
                itemBuilder: (context, index) {
                  final page = _pages[index];
                  final isCurrent = index == _currentPage;

                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AnimatedScale(
                          scale: isCurrent ? 1.0 : 0.88,
                          duration: AppAnimations.medium,
                          curve: AppAnimations.subtleSpring,
                          child: Container(
                            width: 120,
                            height: 120,
                            decoration: BoxDecoration(
                              color: (page['color'] as Color).withValues(alpha: 0.12),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              page['icon'] as IconData,
                              size: 60,
                              color: page['color'] as Color,
                            ),
                          ),
                        ),
                        const SizedBox(height: 36),
                        AnimatedOpacity(
                          opacity: isCurrent ? 1.0 : 0.0,
                          duration: AppAnimations.normal,
                          child: Text(
                            page['title'] as String,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w800,
                              color: AppColors.primaryText,
                              letterSpacing: -0.5,
                            ),
                          ),
                        ),
                        const SizedBox(height: 14),
                        AnimatedOpacity(
                          opacity: isCurrent ? 1.0 : 0.0,
                          duration: AppAnimations.medium,
                          child: Text(
                            page['description'] as String,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 14,
                              color: AppColors.secondaryText,
                              height: 1.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            // Bottom Controls
            Padding(
              padding: const EdgeInsets.fromLTRB(32, 16, 32, 32),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Animated Page Indicators
                  Row(
                    children: List.generate(
                      _pages.length,
                      (index) => AnimatedContainer(
                        duration: AppAnimations.normal,
                        curve: AppAnimations.defaultCurve,
                        margin: const EdgeInsets.only(right: 6),
                        width: _currentPage == index ? 24 : 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: _currentPage == index
                              ? AppColors.primaryBlue
                              : AppColors.border,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  ),
                  PrimaryButton(
                    width: 140,
                    text: _currentPage == _pages.length - 1 ? 'Get Started' : 'Next',
                    icon: _currentPage == _pages.length - 1 ? Icons.check : Icons.arrow_forward_rounded,
                    onPressed: _nextPage,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
