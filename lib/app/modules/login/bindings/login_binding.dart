import 'package:get/get.dart';
import '../controllers/login_controller.dart';
import '../../../data/providers/auth_provider.dart';
import '../../../data/repositories/auth_repository.dart';
import '../../../data/controllers/auth_controller.dart';

class LoginBinding implements Bindings {
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