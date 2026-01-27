import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_health_consultation/core/constants/app_colors.dart';
import 'package:smart_health_consultation/core/constants/app_styles.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, String>> _onboardingData = [
    {
      'title': 'Welcome to Smart Health',
      'subtitle': 'Book appointments with doctors instantly from your phone',
      'image': 'assets/images/onboarding1.svg',
    },
    {
      'title': 'Video Consultations',
      'subtitle': 'Connect with doctors through secure video calls',
      'image': 'assets/images/onboarding2.svg',
    },
    {
      'title': 'Digital Prescriptions',
      'subtitle': 'Receive and manage your prescriptions digitally',
      'image': 'assets/images/onboarding3.svg',
    },
    {
      'title': '24/7 Support',
      'subtitle': 'Chat with your doctor anytime for follow-up questions',
      'image': 'assets/images/onboarding4.svg',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _onboardingData.length,
                onPageChanged: (index) {
                  setState(() => _currentPage = index);
                },
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Image placeholder
                        Container(
                          height: 300,
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(24),
                          ),
                          child: const Icon(
                            Icons.medical_services,
                            size: 150,
                            color: AppColors.primary,
                          ),
                        ),
                        const SizedBox(height: 40),
                        Text(
                          _onboardingData[index]['title']!,
                          style: AppStyles.headlineMedium,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          _onboardingData[index]['subtitle']!,
                          style: AppStyles.bodyMedium,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      _onboardingData.length,
                      (index) => Container(
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: _currentPage == index ? 24 : 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: _currentPage == index
                              ? AppColors.primary
                              : Colors.grey[300],
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_currentPage < _onboardingData.length - 1) {
                          _pageController.nextPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        } else {
                          context.go('/auth');
                        }
                      },
                      style: AppStyles.primaryButton,
                      child: Text(
                        _currentPage == _onboardingData.length - 1
                            ? 'Get Started'
                            : 'Continue',
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  if (_currentPage == _onboardingData.length - 1)
                    TextButton(
                      onPressed: () => context.go('/auth'),
                      child: const Text('Already have an account? Sign In'),
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