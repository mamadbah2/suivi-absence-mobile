import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'app/routes/app_pages.dart';
import 'app/data/providers/auth_provider.dart';
import 'app/data/services/supabase_service.dart'; // Import du service Supabase
import 'app/data/config/app_config.dart'; // Import des configurations

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialiser Supabase avant tout
  try {
    await SupabaseService.initialize(
      supabaseUrl: AppConfig.supabaseUrl,
      supabaseAnonKey: AppConfig.supabaseAnonKey,
    );
    print('Supabase initialisé avec succès');
  } catch (e) {
    print('Erreur lors de l\'initialisation de Supabase: $e');
  }
  
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

