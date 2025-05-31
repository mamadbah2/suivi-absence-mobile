import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/providers/auth_provider.dart';
import '../../../data/controllers/auth_controller.dart';

class LoginController extends GetxController {
  final AuthProvider _authProvider;
  final AuthController _authController;
  
  LoginController(this._authProvider, this._authController);

  final email = ''.obs;
  final password = ''.obs;
  final isLoading = false.obs;
  final obscurePassword = true.obs; // Pour gérer la visibilité du mot de passe
  
  @override
  void onInit() {
    super.onInit();
    // Vérifier si l'utilisateur a déjà un token valide
    checkAuthStatus();
  }

  @override
  void onReady() {
    super.onReady();
    print('LoginController ready');
  }
  
  // Méthode pour vérifier l'état d'authentification au démarrage de l'application
  Future<void> checkAuthStatus() async {
    try {
      final isValid = await _authProvider.validateToken();
      if (isValid) {
        // Si le token est valide, on peut rediriger directement
        // mais on a besoin de récupérer les informations utilisateur d'abord
        final userData = await _authProvider.getUserFromStorage();
        if (userData != null) {
          _authController.setUser(userData);
          _redirectBasedOnRole(userData.role);
        }
      }
    } catch (e) {
      // Si une erreur se produit, on reste sur la page de login
      print('Erreur lors de la vérification du statut d\'authentification: $e');
    }
  }
  
  void setEmail(String value) {
    email.value = value;
  }
  
  void setPassword(String value) {
    password.value = value;
  }

  void togglePasswordVisibility() {
    obscurePassword.value = !obscurePassword.value;
  }

  Future<void> login() async {
    if (email.isEmpty || password.isEmpty) {
      Get.snackbar(
        'Erreur',
        'Veuillez remplir tous les champs',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
      );
      return;
    }

    isLoading.value = true;
    print('Tentative de connexion avec: ${email.value}');
    
    try {
      final user = await _authProvider.login(email.value, password.value);
      print('Connexion réussie');
      _authController.setUser(user);
      
      // Rediriger l'utilisateur vers la page appropriée selon son rôle
      _redirectBasedOnRole(user.role);
      
    } catch (e) {
      print('Erreur de connexion: $e');
      Get.snackbar(
        'Erreur de connexion',
        e is Exception ? e.toString().replaceFirst('Exception: ', '') : 'Une erreur est survenue',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
    } finally {
      isLoading.value = false;
    }
  }
  
  void _redirectBasedOnRole(String role) {
    switch (role.toLowerCase()) {
      case 'etudiant':
        print('Redirection vers la page étudiant');
        Get.offAllNamed('/etudiant');
        break;
      case 'enseignant':
      case 'admin':
      case 'professeur':
        print('Redirection vers la page pointage');
        Get.offAllNamed('/pointage');
        break;
      default:
        // Si le rôle n'est pas reconnu, on déconnecte l'utilisateur par sécurité
        _authProvider.logout();
        _authController.clearUser();
        Get.snackbar(
          'Erreur',
          'Rôle utilisateur non reconnu',
          snackPosition: SnackPosition.BOTTOM,
        );
    }
  }
}