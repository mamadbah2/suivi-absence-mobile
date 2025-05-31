import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'app/routes/app_pages.dart';
import 'app/data/providers/auth_provider.dart'; // Import AuthProvider

void main() {
  // Initialiser les services et providers globaux
  Get.put(AuthProvider(), permanent: true);
  // Get.put(EtudiantService()); // Commented out as EtudiantService.dart is missing

  runApp(const SuiviAbsenceApp()); // Remplacé MyApp() par SuiviAbsenceApp() et ajouté const
}

class SuiviAbsenceApp extends StatelessWidget {
  const SuiviAbsenceApp({super.key});

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

