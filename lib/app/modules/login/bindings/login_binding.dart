import 'package:get/get.dart';
import '../controllers/login_controller.dart';
import '../../../data/providers/auth_provider.dart';
import '../../../data/repositories/auth_repository.dart';
import '../../../data/controllers/auth_controller.dart';

class LoginBinding implements Bindings {

  //Le binding est le lien entre le controller et le provider et le repository
  //Get.put() est une fonction pour injecter les dépendances dans le controller il est garde en memoire avec permanent: true
  @override
  void dependencies() {
    // Controllers globaux
    Get.put(AuthController(), permanent: true);
    
    // Providers
    Get.put(AuthProvider(), permanent: true);
    
    // Repositories
    Get.put(AuthRepository(), permanent: true);
    
    // Controllers de page
    Get.put(LoginController());
    
    print('LoginBinding initialized');
  }
} 