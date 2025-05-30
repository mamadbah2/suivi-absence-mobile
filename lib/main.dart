import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'app/routes/app_pages.dart';

void main() {
  // Initialiser les services
  Get.put(EtudiantService());

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Suivi Absence',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFF3D2914),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF3D2914),
          primary: const Color(0xFF3D2914),
          secondary: const Color(0xFFD68D30),
        ),
      ),
      initialRoute: Routes.LOGIN,
      getPages: AppPages.routes,
    );
  }
}

