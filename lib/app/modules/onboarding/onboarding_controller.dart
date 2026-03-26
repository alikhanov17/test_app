import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../routes/app_routes.dart';

class OnboardingPage {
  final IconData icon;
  final String title;
  final String description;
  final Color color;

  const OnboardingPage({
    required this.icon,
    required this.title,
    required this.description,
    required this.color,
  });
}

class OnboardingController extends GetxController {
  final pageController = PageController();
  final currentPage = 0.obs;

  final pages = const [
    OnboardingPage(
      icon: Icons.rocket_launch_rounded,
      title: 'Добро пожаловать',
      description:
          'Откройте для себя удивительный контент, созданный специально для вас. Ваш путь начинается здесь.',
      color: Color(0xFF6C63FF),
    ),
    OnboardingPage(
      icon: Icons.auto_awesome_rounded,
      title: 'Откройте всё',
      description:
          'Получите неограниченный доступ ко всем функциям с премиум-подпиской. Без ограничений и границ.',
      color: Color(0xFFFF6584),
    ),
  ];

  void onPageChanged(int index) => currentPage.value = index;

  void onContinue() {
    if (currentPage.value < pages.length - 1) {
      pageController.nextPage(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
      );
    } else {
      Get.toNamed(Routes.paywall);
    }
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }
}
