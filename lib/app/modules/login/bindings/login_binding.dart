import 'package:get/get.dart';
import '../controllers/login_controller.dart';
import '../../../data/providers/auth_provider.dart';
import '../../../data/controllers/auth_controller.dart';

class LoginBinding implements Bindings {

  //Le binding est le lien entre le controller et le provider et le repository
  //Get.put() est une fonction pour injecter les dépendances dans le controller il est garde en memoire avec permanent: true
  @override
  void dependencies() {
    // Controllers globaux
    // Ensure AuthController is registered before AuthRepository if it's a dependency
    Get.put(AuthController(), permanent: true);
    
    // Providers
    Get.put(AuthProvider(), permanent: true);
    
    // Controllers de page
    // Pass AuthProvider directly to LoginController
    Get.put(LoginController(Get.find<AuthProvider>(), Get.find<AuthController>()));
    
    print('LoginBinding initialized');
  }
}