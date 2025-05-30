import 'package:get/get.dart';
import '../../../data/providers/auth_provider.dart'; // Changed import
import '../../../data/controllers/auth_controller.dart';

class LoginController extends GetxController {
  //Le login controller est le lien entre la vue et le provider
  
  final AuthProvider _authProvider; // Changed to AuthProvider
  final AuthController _authController;
  
  LoginController(this._authProvider, this._authController); // Updated constructor

  final email = ''.obs;
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
      // Call login on _authProvider directly
      final user = await _authProvider.login(email.value, password.value); 
      // Since _authProvider.login returns UserModel (non-nullable) or throws,
      // we can assume user is not null here if no exception was thrown.
      print('Connexion réussie');
      _authController.setUser(user);
      Get.offNamed('/pointage');
    } catch (e) {
      print('Erreur de connexion: $e');
      Get.snackbar(
        'Erreur',
        // Display the actual error message from the provider if it's an Exception
        e is Exception ? e.toString().replaceFirst('Exception: ', '') : 'Une erreur est survenue',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }
}