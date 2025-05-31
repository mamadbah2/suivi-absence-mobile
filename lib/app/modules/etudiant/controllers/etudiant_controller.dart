import 'package:get/get.dart';
import '../../../data/controllers/auth_controller.dart';

class EtudiantController extends GetxController {
  final AuthController _authController = Get.find<AuthController>();

  // Getter pour accéder aux informations de l'utilisateur
  String get userEmail => _authController.userEmail;

  void voirAbsences() {
    // Navigation vers la page des absences
    Get.toNamed('/absences');
  }

  @override
  void onInit() {
    super.onInit();
    // Vérifier si l'utilisateur est connecté
    if (!_authController.isAuthenticated.value) {
      Get.offNamed('/login');
      return;
    }
    print('EtudiantController initialized for user: ${_authController.userEmail}');
  }
} 