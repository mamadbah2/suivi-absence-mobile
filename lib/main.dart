import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'app/routes/app_pages.dart';

void main() {
  runApp(const SuiviAbsenceApp());
}

class SuiviAbsenceApp extends StatelessWidget {
  const SuiviAbsenceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Suivi Absence',
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

