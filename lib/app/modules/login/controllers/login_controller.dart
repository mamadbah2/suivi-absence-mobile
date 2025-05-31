import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../../data/repositories/auth_repository.dart';
import '../../../data/controllers/auth_controller.dart';
import '../../../routes/app_pages.dart';

class LoginController extends GetxController {
  //Je recupere le repository pour faire la connexion avec Get.find()
  //LoginController herite de GetxController pour avoir acces aux fonctions de Getx

  //Le login controller est le lien entre la vue et le repository

  final AuthRepository _authRepository = Get.find<AuthRepository>();
  final AuthController _authController = Get.find<AuthController>();

  final username = TextEditingController();
  final password = TextEditingController();
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

  @override
  void onClose() {
    username.dispose();
    password.dispose();
    super.onClose();
  }

  void handleLogin() async {
    if (username.text.isEmpty || password.text.isEmpty) {
      Get.snackbar(
        'Erreur',
        'Veuillez remplir tous les champs',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    isLoading.value = true;

    try {
      final user = await _authRepository.login(
        username.text,
        password.text,
      );

      if (user != null) {
        _authController.setUser(user);

        // Redirection basée sur le rôle
        final role = user.role.toLowerCase();
        if (role == 'etudiant') {
          Get.offAllNamed(Routes.ABSENCES);
        } else if (role == 'vigile') {
          Get.offAllNamed(Routes.POINTAGE);
        } else if (role == 'admin') {
          Get.offAllNamed(Routes.ETUDIANT);
        } else {
          Get.snackbar(
            'Erreur',
            'Rôle non reconnu',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        }
      }
    } catch (e) {
      Get.snackbar(
        'Erreur',
        'Identifiants incorrects',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }
}
