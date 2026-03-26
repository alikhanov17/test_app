import 'package:get/get.dart';
import '../../data/services/storage_service.dart';
import '../../routes/app_routes.dart';

class PaywallController extends GetxController {
  final selectedPlan = 'yearly'.obs;
  final isLoading = false.obs;

  void selectPlan(String plan) => selectedPlan.value = plan;

  Future<void> onContinue() async {
    isLoading.value = true;
    // Simulate purchase delay
    await Future.delayed(const Duration(milliseconds: 900));
    await Get.find<StorageService>().saveSubscription(selectedPlan.value);
    isLoading.value = false;
    Get.offAllNamed(Routes.home);
  }
}
