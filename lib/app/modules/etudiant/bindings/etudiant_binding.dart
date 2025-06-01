import 'package:get/get.dart';
import '../controllers/etudiant_controller.dart';
import '../../../data/controllers/auth_controller.dart';
import '../../../data/providers/auth_provider.dart';
import '../../../data/providers/etudiant_provider.dart';

class EtudiantBinding implements Bindings {
  @override
  void dependencies() {
    // S'assurer que AuthProvider est disponible si nécessaire
    if (!Get.isRegistered<AuthProvider>()) {
      Get.put(AuthProvider(), permanent: true);
    }
    
    // S'assurer que AuthController est disponible
    if (!Get.isRegistered<AuthController>()) {
      Get.put(AuthController(), permanent: true);
    }
    
    // Initialiser EtudiantProvider si nécessaire
    if (!Get.isRegistered<EtudiantProvider>()) {
      Get.put(EtudiantProvider());
    }
    
    // Initialiser EtudiantController
    Get.lazyPut<EtudiantController>(
      () => EtudiantController(),
    );
  }
}