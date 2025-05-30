import 'package:get/get.dart';
import '../../../data/repositories/auth_repository.dart';
import '../../../data/controllers/auth_controller.dart';

class LoginController extends GetxController {
  //Je recupere le repository pour faire la connexion avec Get.find()
  //LoginController herite de GetxController pour avoir acces aux fonctions de Getx
  
  //Le login controller est le lien entre la vue et le repository
  
  final AuthRepository _authRepository = Get.find<AuthRepository>();
  final AuthController _authController = Get.find<AuthController>();
  
  final email = ''.obs;// .obs est un observable pour que le controller puisse observer les changements
  final password = ''.obs;
  final isLoading = false.obs;
  
  @override
  void onInit() {
    super.onInit();
    print('LoginController initialized');
  }

  @override
  void onReady() {
    super.onReady();
    print('LoginController ready');
  }
  
  void setEmail(String value) {
    email.value = value;
    print('Email set: $value');
  }
  
  void setPassword(String value) {
    password.value = value;
    print('Password set: $value');
  }

  Future<void> login() async {
    if (email.isEmpty || password.isEmpty) {
      Get.snackbar(
        'Erreur',
        'Veuillez remplir tous les champs',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    isLoading.value = true;
    print('Tentative de connexion avec: ${email.value}');
    
    try {
      final user = await _authRepository.login(email.value, password.value);
      if (user != null) {
        print('Connexion réussie');
        // Stockage de l'utilisateur dans le contrôleur global
        //Pour connaitre l'utilisateur connecte pendant la session
        _authController.setUser(user);
        if (user.role == 'Admin') {
          // Redirection vers la page d'administration
          Get.offNamed('/justification');
        } else if (user.role == 'Vigile') {
          // Redirection vers la page utilisateur
          Get.offNamed('/pointage');
        } else if (user.role == 'Etudiant') {
          // Redirection vers la page étudiant
          Get.offNamed('/etudiant');
        }
      } else {
        print('Échec de la connexion');
        Get.snackbar(
          'Erreur',
          'Identifiants invalides',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      print('Erreur de connexion: $e');
      Get.snackbar(
        'Erreur',
        'Une erreur est survenue',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }
} 