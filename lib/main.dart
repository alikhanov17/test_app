import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'app/data/services/storage_service.dart';
import 'app/routes/app_pages.dart';
import 'app/routes/app_routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Get.putAsync(() => StorageService().init());

  final storage = Get.find<StorageService>();
  final initialRoute =
      storage.isSubscribed ? Routes.home : Routes.onboarding;

  runApp(
    GetMaterialApp(
      title: 'TestApp',
      debugShowCheckedModeBanner: false,
      initialRoute: initialRoute,
      getPages: AppPages.routes,
      theme: ThemeData(
        fontFamily: 'SF Pro Display',
        useMaterial3: true,
      ),
    ),
  );
}
