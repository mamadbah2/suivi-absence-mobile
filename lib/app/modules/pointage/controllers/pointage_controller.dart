import 'package:get/get.dart';
import '../../../data/controllers/auth_controller.dart';

class PointageController extends GetxController {
  final AuthController _authController = Get.find<AuthController>();

  // Getter pour accéder aux informations de l'utilisateur
  String get userEmail => _authController.userEmail;
  String get userToken => _authController.userToken;

  @override
  void onInit() {
    super.onInit();
    // Vérifier si l'utilisateur est connecté
    if (!_authController.isAuthenticated.value) {
      Get.offNamed('/login');
      return;
    }
    print('PointageController initialized for user: ${_authController.userEmail}');
  }

  // Exemple de méthode utilisant les données de l'utilisateur
  void fairePointage() {
    print('Pointage pour l\'utilisateur: ${_authController.userEmail}');
    // Implémentez votre logique de pointage ici
  }
} 