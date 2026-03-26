import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../common/widgets/app_button.dart';
import '../../common/widgets/plan_card.dart';
import 'paywall_controller.dart';

class PaywallView extends GetView<PaywallController> {
  const PaywallView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0F1A),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 12),
              const Text(
                'Выберите тариф',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Откройте все функции с премиум-доступом',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.55),
                  fontSize: 15,
                ),
              ),
              const SizedBox(height: 40),
              Obx(() => PlanCard(
                    title: 'Годовой',
                    price: '2 990 ₽',
                    period: 'в год',
                    subtitle: 'Всего 249 ₽/мес · Скидка 50%',
                    badge: 'ВЫГОДНЕЕ',
                    isSelected: controller.selectedPlan.value == 'yearly',
                    onTap: () => controller.selectPlan('yearly'),
                  )),
              const SizedBox(height: 14),
              Obx(() => PlanCard(
                    title: 'Месячный',
                    price: '499 ₽',
                    period: 'в месяц',
                    isSelected: controller.selectedPlan.value == 'monthly',
                    onTap: () => controller.selectPlan('monthly'),
                  )),
              const Spacer(),
              Obx(() => AppButton(
                    label: 'Продолжить',
                    isLoading: controller.isLoading.value,
                    onPressed: controller.onContinue,
                  )),
              const SizedBox(height: 14),
              Center(
                child: Text(
                  'Отмена в любое время · Безопасная оплата',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.35),
                    fontSize: 13,
                  ),
                ),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}
