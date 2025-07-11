import 'package:get/get.dart';
import '../models/user_model.dart';

class AuthController extends GetxController {
  final Rx<UserModel?> currentUser = Rx<UserModel?>(null);
  final RxBool isAuthenticated = false.obs;

  void setUser(UserModel user) {
    currentUser.value = user;
    isAuthenticated.value = true;
  }

  void clearUser() {
    currentUser.value = null;
    isAuthenticated.value = false;
  }

  // Getters pour faciliter l'accès aux données de l'utilisateur
  String get userEmail => currentUser.value?.email ?? '';
  String get userToken => currentUser.value?.password ?? '';
  String get userRole => currentUser.value?.role ?? ''; // Getter pour le rôle
  String get userMatricule => currentUser.value?.matricule ?? ''; // Getter pour le matricule
}